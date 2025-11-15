resource "iosxe_nat" "nat" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].nat, null) != null || try(local.defaults.iosxe.configuration.nat, null) != null }
  device   = each.value.name

  inside_source_interfaces = try(length(local.device_config[each.value.name].nat.inside_source_interfaces) == 0, true) ? null : [
    for isi in local.device_config[each.value.name].nat.inside_source_interfaces : {
      id = try(isi.id, local.defaults.iosxe.configuration.nat.inside_source_interfaces.id, null)
      interfaces = try(length(isi.interfaces) == 0, true) ? null : [
        for iface in isi.interfaces : {
          interface = "${try(iface.interface_type, local.defaults.iosxe.configuration.nat.inside_source_interfaces.interfaces.interface_type, "")}${try(trimprefix(iface.interface_id, "$string "), local.defaults.iosxe.configuration.nat.inside_source_interfaces.interfaces.interface_id, "")}"
          overload  = try(iface.overload, local.defaults.iosxe.configuration.nat.inside_source_interfaces.interfaces.overload, null)
        }
      ]
    }
  ]

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}