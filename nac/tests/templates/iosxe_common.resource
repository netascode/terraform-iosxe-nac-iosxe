*** Settings ***
Library   pabot.PabotLib
Library   XML
Library   Collections
Library   OperatingSystem
Library   ./lib/UtilsLib.py

*** Variables ***
&{DEVICES}
{% for device in iosxe.devices | default([]) %}
...   {{ device.name }}={{ device.host }}
{% endfor %}
