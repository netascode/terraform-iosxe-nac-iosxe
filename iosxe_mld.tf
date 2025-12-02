resource "iosxe_mld_snooping" "mld_snooping" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].mld, null) != null || try(local.defaults.iosxe.configuration.mld, null) != null }
  device   = each.value.name

  snooping = try(local.device_config[each.value.name].mld.ipv6_mld_snooping, local.defaults.iosxe.configuration.mld.ipv6_mld_snooping, null)
  querier  = try(local.device_config[each.value.name].mld.ipv6_mld_snooping_querier, local.defaults.iosxe.configuration.mld.ipv6_mld_snooping_querier, null)
}
