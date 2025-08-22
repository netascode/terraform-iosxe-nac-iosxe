resource "iosxe_cts" "cts" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].cts, null) != null || try(local.defaults.iosxe.configuration.cts, null) != null }
  device   = each.value.name

  authorization_list = try(local.device_config[each.value.name].cts.authorization_list, local.defaults.iosxe.configuration.cts.authorization_list, null)

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}