resource "iosxe_wireless_system" "wireless_system" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].wireless.management_interface_type, null) != null }
  device   = each.value.name

  interface_name = format("%s%s",
    try(local.device_config[each.value.name].wireless.management_interface_type, null),
    try(local.device_config[each.value.name].wireless.management_interface_id, null)
  )

  depends_on = [iosxe_interface_vlan.vlan]
}
