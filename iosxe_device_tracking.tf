resource "iosxe_device_tracking" "device_tracking" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].device_tracking, null) != null }
  device   = each.value.name

  logging_theft                          = try(local.device_config[each.value.name].device_tracking.logging_theft, null)
  tracking_auto_source_fallback_ipv4     = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_ipv4, null)
  tracking_auto_source_fallback_mask     = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_mask, null)
  tracking_auto_source_fallback_override = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_override, null)
  tracking_retry_interval                = try(local.device_config[each.value.name].device_tracking.tracking_retry_interval, null)
}

locals {
  device_tracking_policies = flatten([
    for device in local.devices : [
      for policy in try(local.device_config[device.name].device_tracking.policies, []) : {
        key                                         = format("%s/%s", device.name, policy.name)
        device                                      = device.name
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
  ])
}

resource "iosxe_device_tracking_policy" "device_tracking_policy" {
  for_each = { for e in local.device_tracking_policies : e.key => e }
  device   = each.value.device

  name                                        = each.value.name
  trusted_port                                = each.value.trusted_port
  device_role                                 = each.value.device_role
  device_role_node_legacy                     = each.value.device_role_node_legacy
  device_role_switch_legacy                   = each.value.device_role_switch_legacy
  device_role_router_legacy                   = each.value.device_role_router_legacy
  data_glean_log_only                         = each.value.data_glean_log_only
  data_glean_recovery_dhcp                    = each.value.data_glean_recovery_dhcp
  data_glean_recovery_ndp                     = each.value.data_glean_recovery_ndp
  prefix_glean                                = each.value.prefix_glean
  prefix_glean_only                           = each.value.prefix_glean_only
  destination_glean_log_only                  = each.value.destination_glean_log_only
  destination_glean_recovery_dhcp             = each.value.destination_glean_recovery_dhcp
  protocol_arp                                = each.value.protocol_arp
  protocol_arp_prefix_list                    = each.value.protocol_arp_prefix_list
  protocol_dhcp4                              = each.value.protocol_dhcp4
  protocol_dhcp4_prefix_list                  = each.value.protocol_dhcp4_prefix_list
  protocol_dhcp6                              = each.value.protocol_dhcp6
  protocol_dhcp6_prefix_list                  = each.value.protocol_dhcp6_prefix_list
  protocol_ndp                                = each.value.protocol_ndp
  protocol_ndp_prefix_list                    = each.value.protocol_ndp_prefix_list
  tracking_enable                             = each.value.tracking_enable
  tracking_enable_reachable_lifetime_seconds  = each.value.tracking_enable_reachable_lifetime_seconds
  tracking_enable_reachable_lifetime_infinite = each.value.tracking_enable_reachable_lifetime_infinite
  tracking_disable                            = each.value.tracking_disable
  tracking_disable_stale_lifetime             = each.value.tracking_disable_stale_lifetime
  limit_address_count                         = each.value.limit_address_count
  security_level_glean                        = each.value.security_level_glean
  security_level_guard                        = each.value.security_level_guard
  security_level_inspect                      = each.value.security_level_inspect
  medium_type_wireless                        = each.value.medium_type_wireless

  depends_on = [iosxe_device_tracking.device_tracking]
}
