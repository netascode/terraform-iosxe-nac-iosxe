resource "iosxe_cts" "cts" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].cts, null) != null || try(local.defaults.iosxe.configuration.cts, null) != null }
  device   = each.value.name

  authorization_list                      = try(local.device_config[each.value.name].cts.authorization_list, local.defaults.iosxe.configuration.cts.authorization_list, null)
  role_based_enforcement_logging_interval = try(local.device_config[each.value.name].cts.role_based_enforcement_logging_interval, local.defaults.iosxe.configuration.cts.role_based_enforcement_logging_interval, null)
  role_based_enforcement_vlan_lists = try(
    provider::utils::normalize_vlans(
      try(local.device_config[each.value.name].cts.role_based_enforcement_vlans, local.defaults.iosxe.configuration.cts.role_based_enforcement_vlans),
      "list"
    ),
    null
  )

  role_based_enforcement                  = try(local.device_config[each.value.name].cts.role_based_enforcement, local.defaults.iosxe.configuration.cts.role_based_enforcement, null)
  role_based_permissions_default_acl_name = try(local.device_config[each.value.name].cts.role_based_permissions_default_acl_name, local.defaults.iosxe.configuration.cts.role_based_permissions_default_acl_name, null)
  sgt                                     = try(local.device_config[each.value.name].cts.sgt, local.defaults.iosxe.configuration.cts.sgt, null)
  sxp_default_password                    = try(local.device_config[each.value.name].cts.sxp_default_password, local.defaults.iosxe.configuration.cts.sxp_default_password, null)
  sxp_default_password_type               = try(local.device_config[each.value.name].cts.sxp_default_password_type, local.defaults.iosxe.configuration.cts.sxp_default_password_type, null)
  sxp_enable                              = try(local.device_config[each.value.name].cts.sxp, local.defaults.iosxe.configuration.cts.sxp, null)
  sxp_listener_hold_max_time              = try(local.device_config[each.value.name].cts.sxp_listener_hold_max_time, local.defaults.iosxe.configuration.cts.sxp_listener_hold_max_time, null)
  sxp_listener_hold_min_time              = try(local.device_config[each.value.name].cts.sxp_listener_hold_min_time, local.defaults.iosxe.configuration.cts.sxp_listener_hold_min_time, null)
  sxp_retry_period                        = try(local.device_config[each.value.name].cts.sxp_retry_period, local.defaults.iosxe.configuration.cts.sxp_retry_period, null)
  sxp_speaker_hold_time                   = try(local.device_config[each.value.name].cts.sxp_speaker_hold_time, local.defaults.iosxe.configuration.cts.sxp_speaker_hold_time, null)

  sxp_connection_peers_ipv4 = try(length([for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : peer if try(peer.vrf, null) == null]) == 0, true) ? null : [
    for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : {
      ip              = try(peer.ip, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.ip, null)
      connection_mode = try(peer.connection_mode, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.connection_mode, null)
      hold_time       = try(peer.hold_time, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.hold_time, null)
      max_time        = try(peer.max_time, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.max_time, null)
      option          = try(peer.option, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.option, null)
      password        = try(peer.password, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.password, null)
      source_ip       = try(peer.source_ip, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.source_ip, null)
    } if try(peer.vrf, null) == null
  ]

  sxp_connection_peers_ipv4_vrf = try(length([for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : peer if try(peer.vrf, null) != null]) == 0, true) ? null : [
    for peer in local.device_config[each.value.name].cts.sxp_connection_peers_ipv4 : {
      ip              = try(peer.ip, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.ip, null)
      vrf             = try(peer.vrf, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.vrf, null)
      connection_mode = try(peer.connection_mode, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.connection_mode, null)
      hold_time       = try(peer.hold_time, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.hold_time, null)
      max_time        = try(peer.max_time, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.max_time, null)
      option          = try(peer.option, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.option, null)
      password        = try(peer.password, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.password, null)
      source_ip       = try(peer.source_ip, local.defaults.iosxe.configuration.cts.sxp_connection_peers_ipv4.source_ip, null)
    } if try(peer.vrf, null) != null
  ]

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_vrf.vrf
  ]
}