resource "iosxe_mpls" "mpls" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].mpls, null) != null }
  device   = each.value.name

  label_protocol                              = try(local.device_config[each.value.name].mpls.label_protocol, local.defaults.iosxe.configuration.mpls.label_protocol, null)
  label_mode_all_vrfs_all_afs_per_vrf         = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_all_afs_per_vrf, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_all_afs_per_vrf, null)
  label_mode_all_vrfs_all_afs_per_prefix      = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_all_afs_per_prefix, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_all_afs_per_prefix, null)
  label_mode_all_vrfs_all_afs_per_ce          = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_all_afs_per_ce, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_all_afs_per_ce, null)
  label_mode_all_vrfs_all_afs_vrf_conn_aggr   = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_all_afs_vrf_conn_aggr, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_all_afs_vrf_conn_aggr, null)
  label_mode_all_vrfs_bgp_vpnv4_per_vrf       = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv4_per_vrf, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv4_per_vrf, null)
  label_mode_all_vrfs_bgp_vpnv4_per_prefix    = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv4_per_prefix, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv4_per_prefix, null)
  label_mode_all_vrfs_bgp_vpnv4_per_ce        = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv4_per_ce, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv4_per_ce, null)
  label_mode_all_vrfs_bgp_vpnv4_vrf_conn_aggr = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv4_vrf_conn_aggr, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv4_vrf_conn_aggr, null)
  label_mode_all_vrfs_bgp_vpnv6_per_vrf       = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv6_per_vrf, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv6_per_vrf, null)
  label_mode_all_vrfs_bgp_vpnv6_per_prefix    = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv6_per_prefix, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv6_per_prefix, null)
  label_mode_all_vrfs_bgp_vpnv6_per_ce        = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv6_per_ce, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv6_per_ce, null)
  label_mode_all_vrfs_bgp_vpnv6_vrf_conn_aggr = try(local.device_config[each.value.name].mpls.label_mode_all_vrfs_bgp_vpnv6_vrf_conn_aggr, local.defaults.iosxe.configuration.mpls.label_mode_all_vrfs_bgp_vpnv6_vrf_conn_aggr, null)
}
