resource "iosxe_igmp_snooping" "igmp_snooping" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].igmp_snooping, null) != null || try(local.defaults.iosxe.configuration.igmp_snooping, null) != null }
  device   = each.value.name

  querier                         = try(local.device_config[each.value.name].igmp_snooping.querier, local.defaults.iosxe.configuration.igmp_snooping.querier, null)
  querier_entry_version           = try(local.device_config[each.value.name].igmp_snooping.querier_version, local.defaults.iosxe.configuration.igmp_snooping.querier_version, null)
  querier_entry_max_response_time = try(local.device_config[each.value.name].igmp_snooping.querier_max_response_time, local.defaults.iosxe.configuration.igmp_snooping.querier_max_response_time, null)
  querier_entry_timer_expiry      = try(local.device_config[each.value.name].igmp_snooping.querier_timer_expiry, local.defaults.iosxe.configuration.igmp_snooping.querier_timer_expiry, null)
}

