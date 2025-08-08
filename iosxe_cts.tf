resource "iosxe_cts" "cts" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].cts, null) != null || try(local.defaults.iosxe.configuration.cts, null) != null }
  device   = each.value.name

  authorization_list = try(local.device_config[each.value.name].cts.authorization_list, local.defaults.iosxe.configuration.cts.authorization_list, null)
}