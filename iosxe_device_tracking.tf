resource "iosxe_device_tracking" "device_tracking" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].device_tracking, null) != null || try(local.defaults.iosxe.configuration.device_tracking, null) != null }
  device   = each.value.name

  logging_theft                          = try(local.device_config[each.value.name].device_tracking.logging_theft, local.defaults.iosxe.configuration.device_tracking.logging_theft, null)
  tracking_auto_source_fallback_ipv4     = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_ipv4, local.defaults.iosxe.configuration.device_tracking.tracking_auto_source_fallback_ipv4, null)
  tracking_auto_source_fallback_mask     = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_mask, local.defaults.iosxe.configuration.device_tracking.tracking_auto_source_fallback_mask, null)
  tracking_auto_source_fallback_override = try(local.device_config[each.value.name].device_tracking.tracking_auto_source_fallback_override, local.defaults.iosxe.configuration.device_tracking.tracking_auto_source_fallback_override, null)
  tracking_retry_interval                = try(local.device_config[each.value.name].device_tracking.tracking_retry_interval, local.defaults.iosxe.configuration.device_tracking.tracking_retry_interval, null)
}

locals {
  device_tracking_policies = flatten([
    for device in local.devices : [
      for policy in try(local.device_config[device.name].device_tracking.policies, []) : {
        key                       = format("%s/%s", device.name, policy.name)
        device                    = device.name
        name                      = try(policy.name, local.defaults.iosxe.configuration.device_tracking.policies.name, null)
        trusted_port              = try(policy.trusted_port, local.defaults.iosxe.configuration.device_tracking.policies.trusted_port, null)
        device_role               = try(policy.device_role, local.defaults.iosxe.configuration.device_tracking.policies.device_role, null)
        device_role_node_legacy   = try(policy.device_role_node_legacy, local.defaults.iosxe.configuration.device_tracking.policies.device_role_node_legacy, null)
        device_role_switch_legacy = try(policy.device_role_switch_legacy, local.defaults.iosxe.configuration.device_tracking.policies.device_role_switch_legacy, null)
        device_role_router_legacy = try(policy.device_role_router_legacy, local.defaults.iosxe.configuration.device_tracking.policies.device_role_router_legacy, null)
      }
    ]
  ])
}

resource "iosxe_device_tracking_policy" "device_tracking_policy" {
  for_each = { for e in local.device_tracking_policies : e.key => e }
  device   = each.value.device

  name                      = each.value.name
  trusted_port              = each.value.trusted_port
  device_role               = each.value.device_role
  device_role_node_legacy   = each.value.device_role_node_legacy
  device_role_switch_legacy = each.value.device_role_switch_legacy
  device_role_router_legacy = each.value.device_role_router_legacy

  depends_on = [iosxe_device_tracking.device_tracking]
}
