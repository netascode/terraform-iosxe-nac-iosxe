resource "iosxe_wireless_system" "wireless_system" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].wireless.management_interface_type, null) != null && try(local.device_config[device.name].wireless.management_interface_id, null) != null }
  device   = each.value.name

  interface_name = format("%s%s",
    try(local.device_config[each.value.name].wireless.management_interface_type, null),
    try(local.device_config[each.value.name].wireless.management_interface_id, null)
  )

  depends_on = [
    iosxe_cli.cli_pre_9,
    iosxe_interface_vlan.vlan,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_port_channel.port_channel,
  ]
}
