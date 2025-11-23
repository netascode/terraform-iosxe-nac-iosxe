resource "iosxe_multicast" "multicast" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].multicast, null) != null || try(local.defaults.iosxe.configuration.multicast, null) != null }
  device   = each.value.name

  multipath          = try(local.device_config[each.value.name].multicast.multipath, local.defaults.iosxe.configuration.multicast.multipath, null)
  multipath_s_g_hash = try(local.device_config[each.value.name].multicast.multipath_s_g_hash, local.defaults.iosxe.configuration.multicast.multipath_s_g_hash, null)

  vrfs = try(length(local.device_config[each.value.name].multicast.vrfs) == 0, true) ? null : [for vrf in local.device_config[each.value.name].multicast.vrfs : {
    vrf                = try(vrf.vrf, null)
    multipath          = try(vrf.multipath, local.defaults.iosxe.configuration.multicast.vrfs.multipath, null)
    multipath_s_g_hash = try(vrf.multipath_s_g_hash, local.defaults.iosxe.configuration.multicast.vrfs.multipath_s_g_hash, null)
  }]

  depends_on = [
    iosxe_vrf.vrf
  ]
}
