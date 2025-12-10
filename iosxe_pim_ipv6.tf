resource "iosxe_pim_ipv6" "pim_ipv6" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].ipv6_pim, null) != null }
  device   = each.value.name

  rp_address             = try(local.device_config[each.value.name].ipv6_pim.rp_address, local.defaults.iosxe.configuration.ipv6_pim.rp_address, null)
  rp_address_access_list = try(local.device_config[each.value.name].ipv6_pim.rp_address_access_list, local.defaults.iosxe.configuration.ipv6_pim.rp_address_access_list, null)
  rp_address_bidir       = try(local.device_config[each.value.name].ipv6_pim.rp_address_bidir, local.defaults.iosxe.configuration.ipv6_pim.rp_address_bidir, null)

  vrfs = try(length(local.device_config[each.value.name].ipv6_pim.vrfs) == 0, true) ? null : [for vrf in local.device_config[each.value.name].ipv6_pim.vrfs : {
    vrf                    = try(vrf.vrf, local.defaults.iosxe.configuration.ipv6_pim.vrfs.vrf, null)
    rp_address             = try(vrf.rp_address, local.defaults.iosxe.configuration.ipv6_pim.vrfs.rp_address, null)
    rp_address_access_list = try(vrf.rp_address_access_list, local.defaults.iosxe.configuration.ipv6_pim.vrfs.rp_address_access_list, null)
    rp_address_bidir       = try(vrf.rp_address_bidir, local.defaults.iosxe.configuration.ipv6_pim.vrfs.rp_address_bidir, null)
  }]

  depends_on = [
    iosxe_vrf.vrf
  ]
}

