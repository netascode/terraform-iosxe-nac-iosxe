resource "iosxe_udld" "udld" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].udld, null) != null }
  device   = each.value.name

  aggressive        = try(local.device_config[each.value.name].udld.aggressive, null)
  enable            = try(local.device_config[each.value.name].udld.enable, null)
  message_time      = try(local.device_config[each.value.name].udld.message_time, null)
  recovery_interval = try(local.device_config[each.value.name].udld.recovery_interval, null)
}
