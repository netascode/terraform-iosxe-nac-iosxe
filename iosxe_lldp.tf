resource "iosxe_lldp" "lldp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].lldp, null) != null || try(local.defaults.iosxe.configuration.lldp, null) != null }
  device   = each.value.name

  run                       = try(local.device_config[each.value.name].lldp.run, local.defaults.iosxe.configuration.lldp.run, null)
  holdtime                  = try(local.device_config[each.value.name].lldp.holdtime, local.defaults.iosxe.configuration.lldp.holdtime, null)
  timer                     = try(local.device_config[each.value.name].lldp.timer, local.defaults.iosxe.configuration.lldp.timer, null)
  ipv4_management_addresses = try(local.device_config[each.value.name].lldp.ipv4_management_addresses, local.defaults.iosxe.configuration.lldp.ipv4_management_addresses, null)
  ipv6_management_addresses = try(local.device_config[each.value.name].lldp.ipv6_management_addresses, local.defaults.iosxe.configuration.lldp.ipv6_management_addresses, null)
  management_vlan           = try(local.device_config[each.value.name].lldp.management_vlan, local.defaults.iosxe.configuration.lldp.management_vlan, null)

  system_names = try(length(local.device_config[each.value.name].lldp.system_names) == 0, true) ? null : [for e in local.device_config[each.value.name].lldp.system_names : {
    switch_id = try(e.switch_id, local.defaults.iosxe.configuration.lldp.system_names.switch_id, null)
    name      = try(e.name, local.defaults.iosxe.configuration.lldp.system_names.name, null)
  }]
}