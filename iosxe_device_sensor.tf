resource "iosxe_device_sensor" "device_sensor" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].device_sensor, null) != null }
  device   = each.value.name

  notify_all_changes = try(local.device_config[each.value.name].device_sensor.notify_all_changes, null)

  filter_lists_dhcp = try(length(local.device_config[each.value.name].device_sensor.dhcp_filter_lists) == 0, true) ? null : [for dhcp_filter in local.device_config[each.value.name].device_sensor.dhcp_filter_lists : {
    name                               = try(dhcp_filter.name, null)
    option_name_class_identifier       = try(dhcp_filter.option_name_class_identifier, null)
    option_name_client_fqdn            = try(dhcp_filter.option_name_client_fqdn, null)
    option_name_client_identifier      = try(dhcp_filter.option_name_client_identifier, null)
    option_name_default_ip_ttl         = try(dhcp_filter.option_name_default_ip_ttl, null)
    option_name_host_name              = try(dhcp_filter.option_name_host_name, null)
    option_name_parameter_request_list = try(dhcp_filter.option_name_parameter_request_list, null)
    option_name_requested_address      = try(dhcp_filter.option_name_requested_address, null)
  }]

  filter_lists_lldp = try(length(local.device_config[each.value.name].device_sensor.lldp_filter_lists) == 0, true) ? null : [for lldp_filter in local.device_config[each.value.name].device_sensor.lldp_filter_lists : {
    name                         = try(lldp_filter.name, null)
    tlv_name_port_description    = try(lldp_filter.tlv_name_port_description, null)
    tlv_name_port_id             = try(lldp_filter.tlv_name_port_id, null)
    tlv_name_system_description  = try(lldp_filter.tlv_name_system_description, null)
    tlv_name_system_capabilities = try(lldp_filter.tlv_name_system_capabilities, null)
    tlv_name_system_name         = try(lldp_filter.tlv_name_system_name, null)
  }]

  filter_lists_cdp = try(length(local.device_config[each.value.name].device_sensor.cdp_filter_lists) == 0, true) ? null : [for cdp_filter in local.device_config[each.value.name].device_sensor.cdp_filter_lists : {
    name                       = try(cdp_filter.name, null)
    tlv_name_device_name       = try(cdp_filter.tlv_name_device_name, null)
    tlv_name_address_type      = try(cdp_filter.tlv_name_address_type, null)
    tlv_name_port_id_type      = try(cdp_filter.tlv_name_port_id_type, null)
    tlv_name_capabilities_type = try(cdp_filter.tlv_name_capabilities_type, null)
    tlv_name_platform_type     = try(cdp_filter.tlv_name_platform_type, null)
  }]

  filter_spec_cdp_includes = try(length(local.device_config[each.value.name].device_sensor.filter_spec_cdp_includes) == 0, true) ? null : [for cdp_include in local.device_config[each.value.name].device_sensor.filter_spec_cdp_includes : {
    name = try(cdp_include, null)
  }]

  filter_spec_cdp_excludes = try(length(local.device_config[each.value.name].device_sensor.filter_spec_cdp_excludes) == 0, true) ? null : [for cdp_exclude in local.device_config[each.value.name].device_sensor.filter_spec_cdp_excludes : {
    name = try(cdp_exclude, null)
  }]

  filter_spec_dhcp_includes = try(length(local.device_config[each.value.name].device_sensor.filter_spec_dhcp_includes) == 0, true) ? null : [for dhcp_include in local.device_config[each.value.name].device_sensor.filter_spec_dhcp_includes : {
    name = try(dhcp_include, null)
  }]

  filter_spec_dhcp_excludes = try(length(local.device_config[each.value.name].device_sensor.filter_spec_dhcp_excludes) == 0, true) ? null : [for dhcp_exclude in local.device_config[each.value.name].device_sensor.filter_spec_dhcp_excludes : {
    name = try(dhcp_exclude, null)
  }]

  filter_spec_lldp_includes = try(length(local.device_config[each.value.name].device_sensor.filter_spec_lldp_includes) == 0, true) ? null : [for lldp_include in local.device_config[each.value.name].device_sensor.filter_spec_lldp_includes : {
    name = try(lldp_include, null)
  }]

  filter_spec_lldp_excludes = try(length(local.device_config[each.value.name].device_sensor.filter_spec_lldp_excludes) == 0, true) ? null : [for lldp_exclude in local.device_config[each.value.name].device_sensor.filter_spec_lldp_excludes : {
    name = try(lldp_exclude, null)
  }]
}