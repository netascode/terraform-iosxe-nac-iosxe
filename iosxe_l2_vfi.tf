resource "iosxe_l2_vfi" "l2_vfi" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].l2_vfi, null) != null }
  device   = each.value.name

  name   = try(local.device_config[each.value.name].l2_vfi.name, local.defaults.iosxe.configuration.l2_vfi.name, null)
  mode   = try(local.device_config[each.value.name].l2_vfi.mode, local.defaults.iosxe.configuration.l2_vfi.mode, null)
  vpn_id = try(local.device_config[each.value.name].l2_vfi.vpn_id, local.defaults.iosxe.configuration.l2_vfi.vpn_id, null)
  neighbors = [for neighbor in try(local.device_config[each.value.name].l2_vfi.neighbors, []) : {
    ip_address    = neighbor.ip_address
    encapsulation = try(neighbor.encapsulation, local.defaults.iosxe.configuration.l2_vfi.neighbors.encapsulation, null)
  }]
}
