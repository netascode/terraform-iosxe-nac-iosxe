# Copyright: (c) 2025, Daniel Schmidt <danischm@cisco.com>

import asyncio
import logging
import os
import re

from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.Collections import Collections
from robot.libraries.XML import XML
from robot.utils import is_truthy
from scrapli_netconf import AsyncNetconfDriver

# Map Robot Framework log levels to Python logging levels for scrapli/asyncssh
ROBOT_TO_SCRAPLI_LEVEL = {
    "TRACE": logging.DEBUG,
    "DEBUG": logging.INFO,
    "INFO": logging.WARNING,
    "WARN": logging.ERROR,
    "ERROR": logging.CRITICAL,
    "NONE": logging.CRITICAL + 1,
}

__version__ = "0.1.0"


class UtilsLib:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self.BuiltIn = BuiltIn()
        self.Collections = Collections()
        self.XML = XML()
        self.PabotLib = self.BuiltIn.get_library_instance("pabot.PabotLib")

    @keyword("Get Configs")
    def get_configs(self):
        # Align scrapli/asyncssh logging with Robot Framework log level
        robot_level = self.BuiltIn.get_variable_value("${LOG_LEVEL}", "INFO")
        log_level = ROBOT_TO_SCRAPLI_LEVEL.get(robot_level.upper(), logging.WARNING)
        for logger_name in ("asyncssh", "scrapli", "scrapli_netconf"):
            logging.getLogger(logger_name).setLevel(log_level)

        devices = self.BuiltIn.get_variable_value("${DEVICES}")
        asyncio.run(self._get_configs_async(devices))

    async def _get_configs_async(self, devices):
        tasks = [self._get_device_config(name, host) for name, host in devices.items()]
        results = await asyncio.gather(*tasks)
        for name, xml_string in results:
            self.PabotLib.set_parallel_value_for_key(f"{name}_config", xml_string)
            logger.info(
                f"Set Pabot parallel value '{name}_config' to the XML config string"
            )

    async def _get_device_config(self, name, host):
        username = os.environ.get("IOSXE_USERNAME")
        password = os.environ.get("IOSXE_PASSWORD")
        insecure = is_truthy(os.environ.get("IOSXE_INSECURE", "True"))

        # Extract port if appended to host (e.g., "192.168.1.1:831")
        port = 830
        if ":" in host:
            host, port_str = host.rsplit(":", 1)
            port = int(port_str)

        conn = AsyncNetconfDriver(
            host=host,
            port=port,
            auth_username=username,
            auth_password=password,
            auth_strict_key=not insecure,
            transport="asyncssh",
            strip_namespaces=True,
        )
        await conn.open()
        response = await conn.get_config(source="running")
        await conn.close()

        return name, response.result

    @keyword("Normalize String")
    def normalize_string(self, text):
        try:
            if isinstance(text, list):
                if len(text) == 0:
                    return ""
                text = text[0]
            text = str(text)
            if re.search(r"(\\n|\\t|\\r|  |\\x0[d,D]|\\x0[a,A]|\\x09)", text):
                text = (
                    text.replace("\\n", "\n")
                    .replace("\\r", "\r")
                    .replace("\\t", "\t")
                    .replace("  ", "${SPACE}${SPACE}")
                    .replace("\\x0d", "\r")
                    .replace("\\x0a", "\n")
                    .replace("\\x09", "\t")
                )
            # Strip leading newlines - IOS-XE devices don't preserve them in banners
            return text.lstrip("\n")
        except AttributeError:
            return text

    @keyword("Normalize Numeric")
    def normalize_numeric(self, value):
        """
        Normalize a numeric value to float for consistent comparison.
        Handles lists (extracts first element), integers, and floats.
        Returns the float value or None if not a valid number.
        """
        try:
            if isinstance(value, list):
                if len(value) == 0:
                    return None
                value = value[0]
            return float(value)
        except (ValueError, TypeError):
            return None

    @keyword("Should Be Equal Value Xml String")
    def should_be_equal_value_xml_string(self, xml, xpath, value=""):
        if not value:
            return
        xml_value = self.XML.get_element(xml, xpath).text
        xml_value = self.normalize_string(xml_value)
        value = self.normalize_string(value)
        self.BuiltIn.should_be_equal_as_strings(xml_value, value)

    @keyword("Should Be Equal Value Xml List")
    def should_be_equal_value_xml_list(
        self, xml, xpath, value: list[str] | None = None, normalize_types=False
    ):
        if not value:
            return
        xml_value = self.XML.get_elements_texts(xml, xpath)
        if normalize_types:
            # Convert both lists to strings for type-insensitive comparison
            xml_value_str = [str(x) for x in xml_value]
            value_str = [str(x) for x in value]
            self.Collections.lists_should_be_equal(
                xml_value_str, value_str, ignore_order=True
            )
        else:
            self.Collections.lists_should_be_equal(xml_value, value, ignore_order=True)

    @keyword("Should Be Equal Value Xml Bool")
    def should_be_equal_value_xml_bool(self, xml, xpath, value="", default=False):
        if value == "":
            return
        # Normalize case: "true" -> "True", "false" -> "False"
        # This allows Robot templates to use lowercase literals (e.g., "true")
        # which previously caused tests to always pass regardless of XML content
        if isinstance(value, str):
            value = value.capitalize()
        if len(self.XML.get_elements(xml, xpath)) == 0:
            if value == "True" and default:
                return
            elif value == "True":
                raise AssertionError("Expected True but got nothing")
            else:
                return
        xml_value = self.XML.get_element(xml, xpath).text
        if xml_value is None:
            xml_value = ""
        if value == "True":
            # Success if element exists or explicitly True
            if xml_value.strip() in ["true", ""]:
                return
            raise AssertionError(
                f"Expected True but got {xml_value}, type: {type(xml_value)}"
            )
        elif value == "False":
            # Success if element absent or explicitly False
            if xml_value == "false":
                return
            raise AssertionError(f"Expected False but got {xml_value}")

    @keyword("Should Be Equal Value Xml Numeric")
    def should_be_equal_value_xml_numeric(self, xml, xpath, value=""):
        """
        Compare XML values as numbers (normalizes int/float comparison).
        """
        if value == "":
            return
        xml_value = self.XML.get_element(xml, xpath).text
        xml_value = self.normalize_numeric(xml_value)
        value = self.normalize_numeric(value)
        if xml_value is None or value is None:
            raise AssertionError(
                f"Cannot compare non-numeric values: got={xml_value}, expected={value}"
            )
        self.BuiltIn.should_be_equal_as_numbers(xml_value, value)

    @keyword("Should Not Exist Xml Element")
    def should_not_exist_xml_element(self, xml, xpath, value=""):
        """
        Verify that an XML element does NOT exist at the given xpath.
        Used for inverse logic attributes where presence in config means
        the element should be absent from device (e.g., disabled_vlans).

        If value is empty/None, the check is skipped (following standard pattern).
        """
        if not value and value != 0:
            return
        elements = self.XML.get_elements(xml, xpath)
        if len(elements) > 0:
            raise AssertionError(
                f"Expected element at '{xpath}' to NOT exist, but found {len(elements)} element(s)"
            )
