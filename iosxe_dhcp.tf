resource "iosxe_dhcp" "dhcp" {
  for_each                                              = { for device in local.devices : device.name => device if try(local.device_config[device.name].dhcp, null) != null }
  device                                                = each.value.name
  compatibility_suboption_link_selection                = try(local.device_config[each.value.name].dhcp.compatibility_suboption_link_selection, local.defaults.iosxe.configuration.dhcp.compatibility_suboption_link_selection, null)
  compatibility_suboption_server_override               = try(local.device_config[each.value.name].dhcp.compatibility_suboption_server_override, local.defaults.iosxe.configuration.dhcp.compatibility_suboption_server_override, null)
  relay_information_trust_all                           = try(local.device_config[each.value.name].dhcp.relay_information_trust_all, local.defaults.iosexe.configuration.dhcp.relay_information_trust_all, null)
  relay_information_option_default                      = try(local.device_config[each.value.name].dhcp.relay_information_option_default, local.defaults.iosexe.configuration.dhcp.relay_information_option_default, null)
  relay_information_option_vpn                          = try(local.device_config[each.value.name].dhcp.relay_information_option_vpn, local.defaults.iosexe.configuration.dhcp.relay_information_option_vpn, null)
  snooping                                              = try(local.device_config[each.value.name].dhcp.snooping, local.defaults.iosexe.configuration.dhcp.snooping, null)
  snooping_information_option_format_remote_id_hostname = try(local.device_config[each.value.name].dhcp.snooping_information_option_format_remote_id_hostname, local.defaults.iosexe.configuration.dhcp.snooping_information_option_format_remote_id_hostname, null)
}
