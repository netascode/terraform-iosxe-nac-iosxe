locals {
  device_sensors = flatten([
    for device in local.devices : [
      for dev_sensor in [try(local.device_config[device.name].device_sensor, null)] : {
        key                = device.name
        device             = device.name
        delete_mode        = try(dev_sensor.delete_mode, local.defaults.iosxe.configuration.device_sensor.delete_mode, null)
        notify_all_changes = try(dev_sensor.notify_all_changes, local.defaults.iosxe.configuration.device_sensor.notify_all_changes, null)
        filter_lists_dhcp = [for dhcp_filter in try(dev_sensor.filter_lists_dhcp, []) : {
          name                               = try(dhcp_filter.name, null)
          option_name_class_identifier       = try(dhcp_filter.option_name_class_identifier, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_class_identifier, null)
          option_name_client_fqdn            = try(dhcp_filter.option_name_client_fqdn, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_client_fqdn, null)
          option_name_client_identifier      = try(dhcp_filter.option_name_client_identifier, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_client_identifier, null)
          option_name_default_ip_ttl         = try(dhcp_filter.option_name_default_ip_ttl, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_default_ip_ttl, null)
          option_name_host_name              = try(dhcp_filter.option_name_host_name, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_host_name, null)
          option_name_parameter_request_list = try(dhcp_filter.option_name_parameter_request_list, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_parameter_request_list, null)
          option_name_requested_address      = try(dhcp_filter.option_name_requested_address, local.defaults.iosxe.configuration.device_sensor.filter_lists_dhcp.option_name_requested_address, null)
        }]
        filter_lists_lldp = [for lldp_filter in try(dev_sensor.filter_lists_lldp, []) : {
          name                        = try(lldp_filter.name, null)
          tlv_name_port_description   = try(lldp_filter.tlv_name_port_description, local.defaults.iosxe.configuration.device_sensor.filter_lists_lldp.tlv_name_port_description, null)
          tlv_name_port_id            = try(lldp_filter.tlv_name_port_id, local.defaults.iosxe.configuration.device_sensor.filter_lists_lldp.tlv_name_port_id, null)
          tlv_name_system_description = try(lldp_filter.tlv_name_system_description, local.defaults.iosxe.configuration.device_sensor.filter_lists_lldp.tlv_name_system_description, null)
          tlv_name_system_name        = try(lldp_filter.tlv_name_system_name, local.defaults.iosxe.configuration.device_sensor.filter_lists_lldp.tlv_name_system_name, null)
        }]
        filter_lists_cdp = [for cdp_filter in try(dev_sensor.filter_lists_cdp, []) : {
          name                   = try(cdp_filter.name, null)
          tlv_name_address_type  = try(cdp_filter.tlv_name_address_type, local.defaults.iosxe.configuration.device_sensor.filter_lists_cdp.tlv_name_address_type, null)
          tlv_name_device_name   = try(cdp_filter.tlv_name_device_name, local.defaults.iosxe.configuration.device_sensor.filter_lists_cdp.tlv_name_device_name, null)
          tlv_name_platform_type = try(cdp_filter.tlv_name_platform_type, local.defaults.iosxe.configuration.device_sensor.filter_lists_cdp.tlv_name_platform_type, null)
        }]
        filter_spec_cdp_includes = [for cdp_include in try(dev_sensor.filter_spec_cdp_includes, []) : {
          name = try(cdp_include.name, null)
        }]
        filter_spec_cdp_excludes = [for cdp_exclude in try(dev_sensor.filter_spec_cdp_excludes, []) : {
          name = try(cdp_exclude.name, null)
        }]
        filter_spec_dhcp_includes = [for dhcp_include in try(dev_sensor.filter_spec_dhcp_includes, []) : {
          name = try(dhcp_include.name, null)
        }]
        filter_spec_dhcp_excludes = [for dhcp_exclude in try(dev_sensor.filter_spec_dhcp_excludes, []) : {
          name = try(dhcp_exclude.name, null)
        }]
        filter_spec_lldp_includes = [for lldp_include in try(dev_sensor.filter_spec_lldp_includes, []) : {
          name = try(lldp_include.name, null)
        }]
        filter_spec_lldp_excludes = [for lldp_exclude in try(dev_sensor.filter_spec_lldp_excludes, []) : {
          name = try(lldp_exclude.name, null)
        }]
      }
      if try(local.device_config[device.name].device_sensor, null) != null
    ]
  ])
}

resource "iosxe_device_sensor" "device_sensor" {
  for_each = { for e in local.device_sensors : e.key => e }
  device   = each.value.device

  delete_mode               = each.value.delete_mode
  notify_all_changes        = each.value.notify_all_changes
  filter_lists_dhcp         = each.value.filter_lists_dhcp
  filter_lists_lldp         = each.value.filter_lists_lldp
  filter_spec_cdp_excludes  = each.value.filter_spec_cdp_excludes
  filter_spec_dhcp_includes = each.value.filter_spec_dhcp_includes
  filter_spec_lldp_includes = each.value.filter_spec_lldp_includes
  # TODO: Uncomment when available in Terraform Registry:
  # filter_lists_cdp          = each.value.filter_lists_cdp
  # filter_spec_cdp_includes  = each.value.filter_spec_cdp_includes
  # filter_spec_dhcp_excludes = each.value.filter_spec_dhcp_excludes
  # filter_spec_lldp_excludes = each.value.filter_spec_lldp_excludes
}