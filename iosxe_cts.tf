resource "iosxe_cts" "cts" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].cts, null) != null }
  device   = each.value.name

  authorization_list                      = try(local.device_config[each.value.name].cts.authorization_list, null)
  role_based_enforcement_logging_interval = try(local.device_config[each.value.name].cts.role_based_enforcement_logging_interval, null)
  role_based_enforcement_vlan_lists = try(
    provider::utils::normalize_vlans(
      try(local.device_config[each.value.name].cts.role_based_enforcement_vlans, null),
      "list"
    ),
    null
  )

  role_based_enforcement                  = try(local.device_config[each.value.name].cts.role_based_enforcement, null)
  role_based_permissions_default_acl_name = try(local.device_config[each.value.name].cts.role_based_permissions_default_acl_name, null)
  sgt                                     = try(local.device_config[each.value.name].cts.sgt, null)
  sxp_default_password                    = try(local.device_config[each.value.name].cts.sxp_default_password, null)
  sxp_default_password_type               = try(local.device_config[each.value.name].cts.sxp_default_password_type, null)
  sxp_enable                              = try(local.device_config[each.value.name].cts.sxp, null)
  sxp_listener_hold_max_time              = try(local.device_config[each.value.name].cts.sxp_listener_hold_max_time, null)
  sxp_listener_hold_min_time              = try(local.device_config[each.value.name].cts.sxp_listener_hold_min_time, null)
  sxp_retry_period                        = try(local.device_config[each.value.name].cts.sxp_retry_period, null)
  sxp_speaker_hold_time                   = try(local.device_config[each.value.name].cts.sxp_speaker_hold_time, null)

  sxp_connection_peers_ipv4 = try(length([for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : peer if try(peer.vrf, null) == null]) == 0, true) ? null : [
    for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : {
      ip              = try(peer.ip, null)
      connection_mode = try(peer.connection_mode, null)
      hold_time       = try(peer.hold_time, null)
      max_time        = try(peer.max_time, null)
      option          = try(peer.option, null)
      password        = try(peer.password, null)
      source_ip       = try(peer.source_ip, null)
    } if try(peer.vrf, null) == null
  ]

  sxp_connection_peers_ipv4_vrf = try(length([for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : peer if try(peer.vrf, null) != null]) == 0, true) ? null : [
    for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : {
      ip              = try(peer.ip, null)
      vrf             = try(peer.vrf, null)
      connection_mode = try(peer.connection_mode, null)
      hold_time       = try(peer.hold_time, null)
      max_time        = try(peer.max_time, null)
      option          = try(peer.option, null)
      password        = try(peer.password, null)
      source_ip       = try(peer.source_ip, null)
    } if try(peer.vrf, null) != null
  ]

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_access_list_role_based.access_list_role_based,
    iosxe_vrf.vrf
  ]
}