resource "iosxe_fhrp" "fhrp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].fhrp, null) != null }
  device   = each.value.name

  version_vrrp = try(local.device_config[each.value.name].fhrp.version_vrrp, null)
}
