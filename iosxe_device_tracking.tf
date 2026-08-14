resource "iosxe_device_tracking" "device_tracking" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].device_tracking, null) != null }
  device   = each.value.name

  logging_theft                          = try(local.device_config[each.value.name].device_tracking.logging_theft, null)
  tracking_auto_source_fallback_ipv4     = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_ipv4, null)
  tracking_auto_source_fallback_mask     = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_mask, null)
  tracking_auto_source_fallback_override = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_override, null)
  tracking_retry_interval                = try(local.device_config[each.value.name].device_tracking.tracking_retry_interval, null)
  binding_reachable_lifetime             = try(local.device_config[each.value.name].device_tracking.binding_reachable_lifetime, null)
  policies = try(length(local.device_config[each.value.name].device_tracking.policies) == 0, true) ? null : [
    for policy in local.device_config[each.value.name].device_tracking.policies : {
      name                                        = try(policy.name, null)
      trusted_port                                = try(policy.trusted_port, null)
      device_role                                 = try(policy.device_role, null)
      device_role_node_legacy                     = try(policy.device_role_node_legacy, null)
      device_role_switch_legacy                   = try(policy.device_role_switch_legacy, null)
      device_role_router_legacy                   = try(policy.device_role_router_legacy, null)
      data_glean_log_only                         = try(policy.data_glean_log_only, null)
      data_glean_recovery_dhcp                    = try(policy.data_glean_recovery_dhcp, null)
      data_glean_recovery_ndp                     = try(policy.data_glean_recovery_ndp, null)
      prefix_glean                                = try(policy.prefix_glean, null)
      prefix_glean_only                           = try(policy.prefix_glean_only, null)
      destination_glean_log_only                  = try(policy.destination_glean_log_only, null)
      destination_glean_recovery_dhcp             = try(policy.destination_glean_recovery_dhcp, null)
      protocol_arp                                = try(policy.protocol_arp, null)
      protocol_arp_prefix_list                    = try(policy.protocol_arp_prefix_list, null)
      protocol_dhcp4                              = try(policy.protocol_dhcp4, null)
      protocol_dhcp4_prefix_list                  = try(policy.protocol_dhcp4_prefix_list, null)
      protocol_dhcp6                              = try(policy.protocol_dhcp6, null)
      protocol_dhcp6_prefix_list                  = try(policy.protocol_dhcp6_prefix_list, null)
      protocol_ndp                                = try(policy.protocol_ndp, null)
      protocol_ndp_prefix_list                    = try(policy.protocol_ndp_prefix_list, null)
      tracking_enable                             = try(policy.tracking_enable, null)
      tracking_enable_reachable_lifetime_seconds  = try(policy.tracking_enable_reachable_lifetime_seconds, null)
      tracking_enable_reachable_lifetime_infinite = try(policy.tracking_enable_reachable_lifetime_infinite, null)
      tracking_disable                            = try(policy.tracking_disable, null)
      tracking_disable_stale_lifetime             = try(policy.tracking_disable_stale_lifetime, null)
      limit_address_count                         = try(policy.limit_address_count, null)
      security_level_glean                        = try(policy.security_level_glean, null)
      security_level_guard                        = try(policy.security_level_guard, null)
      security_level_inspect                      = try(policy.security_level_inspect, null)
      medium_type_wireless                        = try(policy.medium_type_wireless, null)
    }
  ]
}
