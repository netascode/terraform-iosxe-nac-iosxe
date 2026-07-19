resource "iosxe_lldp" "lldp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].lldp, null) != null }
  device   = each.value.name

  run                       = try(local.device_config[each.value.name].lldp.run, null)
  holdtime                  = try(local.device_config[each.value.name].lldp.holdtime, null)
  timer                     = try(local.device_config[each.value.name].lldp.timer, null)
  ipv4_management_addresses = try(local.device_config[each.value.name].lldp.ipv4_management_addresses, null)
  ipv6_management_addresses = try(local.device_config[each.value.name].lldp.ipv6_management_addresses, null)
  management_vlan           = try(local.device_config[each.value.name].lldp.management_vlan, null)

  system_names = try(length(local.device_config[each.value.name].lldp.system_names) == 0, true) ? null : [for e in local.device_config[each.value.name].lldp.system_names : {
    switch_id = try(e.switch_id, null)
    name      = try(e.name, null)
  }]
}