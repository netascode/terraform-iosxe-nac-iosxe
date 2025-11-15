resource "iosxe_vtp" "vtp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].vtp, null) != null || try(local.defaults.iosxe.configuration.vtp, null) != null }
  device   = each.value.name

  domain         = try(local.device_config[each.value.name].vtp.domain, local.defaults.iosxe.configuration.vtp.domain, null)
  file           = try(local.device_config[each.value.name].vtp.file, local.defaults.iosxe.configuration.vtp.file, null)
  interface      = try("${try(local.device_config[each.value.name].vtp.interface_type, local.defaults.iosxe.configuration.vtp.interface_type, null)}${try(trimprefix(local.device_config[each.value.name].vtp.interface_id, "$string "), local.defaults.iosxe.configuration.vtp.interface_id, null)}", null)
  interface_only = try(local.device_config[each.value.name].vtp.interface_only, local.defaults.iosxe.configuration.vtp.interface_only, null)

  # Simple mode attributes (when no mode_instance is specified)
  mode_client              = try(local.device_config[each.value.name].vtp.mode == "client" && try(local.device_config[each.value.name].vtp.mode_instance, null) == null, local.defaults.iosxe.configuration.vtp.mode == "client" && local.defaults.iosxe.configuration.vtp.mode_instance == null, false) ? true : false
  mode_off                 = try(local.device_config[each.value.name].vtp.mode == "off" && try(local.device_config[each.value.name].vtp.mode_instance, null) == null, local.defaults.iosxe.configuration.vtp.mode == "off" && local.defaults.iosxe.configuration.vtp.mode_instance == null, false) ? true : false
  mode_server              = try(local.device_config[each.value.name].vtp.mode == "server" && try(local.device_config[each.value.name].vtp.mode_instance, null) == null, local.defaults.iosxe.configuration.vtp.mode == "server" && local.defaults.iosxe.configuration.vtp.mode_instance == null, false) ? true : false
  mode_transparent         = try(local.device_config[each.value.name].vtp.mode == "transparent" && try(local.device_config[each.value.name].vtp.mode_instance, null) == null, local.defaults.iosxe.configuration.vtp.mode == "transparent" && local.defaults.iosxe.configuration.vtp.mode_instance == null, false) ? true : false
  mode_client_mst          = try(local.device_config[each.value.name].vtp.mode == "client" && local.device_config[each.value.name].vtp.mode_instance == "mst", local.defaults.iosxe.configuration.vtp.mode == "client" && local.defaults.iosxe.configuration.vtp.mode_instance == "mst", false) ? true : false
  mode_client_unknown      = try(local.device_config[each.value.name].vtp.mode == "client" && local.device_config[each.value.name].vtp.mode_instance == "unknown", local.defaults.iosxe.configuration.vtp.mode == "client" && local.defaults.iosxe.configuration.vtp.mode_instance == "unknown", false) ? true : false
  mode_client_vlan         = try(local.device_config[each.value.name].vtp.mode == "client" && local.device_config[each.value.name].vtp.mode_instance == "vlan", local.defaults.iosxe.configuration.vtp.mode == "client" && local.defaults.iosxe.configuration.vtp.mode_instance == "vlan", false) ? true : false
  mode_off_mst             = try(local.device_config[each.value.name].vtp.mode == "off" && local.device_config[each.value.name].vtp.mode_instance == "mst", local.defaults.iosxe.configuration.vtp.mode == "off" && local.defaults.iosxe.configuration.vtp.mode_instance == "mst", false) ? true : false
  mode_off_unknown         = try(local.device_config[each.value.name].vtp.mode == "off" && local.device_config[each.value.name].vtp.mode_instance == "unknown", local.defaults.iosxe.configuration.vtp.mode == "off" && local.defaults.iosxe.configuration.vtp.mode_instance == "unknown", false) ? true : false
  mode_off_vlan            = try(local.device_config[each.value.name].vtp.mode == "off" && local.device_config[each.value.name].vtp.mode_instance == "vlan", local.defaults.iosxe.configuration.vtp.mode == "off" && local.defaults.iosxe.configuration.vtp.mode_instance == "vlan", false) ? true : false
  mode_server_mst          = try(local.device_config[each.value.name].vtp.mode == "server" && local.device_config[each.value.name].vtp.mode_instance == "mst", local.defaults.iosxe.configuration.vtp.mode == "server" && local.defaults.iosxe.configuration.vtp.mode_instance == "mst", false) ? true : false
  mode_server_unknown      = try(local.device_config[each.value.name].vtp.mode == "server" && local.device_config[each.value.name].vtp.mode_instance == "unknown", local.defaults.iosxe.configuration.vtp.mode == "server" && local.defaults.iosxe.configuration.vtp.mode_instance == "unknown", false) ? true : false
  mode_server_vlan         = try(local.device_config[each.value.name].vtp.mode == "server" && local.device_config[each.value.name].vtp.mode_instance == "vlan", local.defaults.iosxe.configuration.vtp.mode == "server" && local.defaults.iosxe.configuration.vtp.mode_instance == "vlan", false) ? true : false
  mode_transparent_mst     = try(local.device_config[each.value.name].vtp.mode == "transparent" && local.device_config[each.value.name].vtp.mode_instance == "mst", local.defaults.iosxe.configuration.vtp.mode == "transparent" && local.defaults.iosxe.configuration.vtp.mode_instance == "mst", false) ? true : false
  mode_transparent_unknown = try(local.device_config[each.value.name].vtp.mode == "transparent" && local.device_config[each.value.name].vtp.mode_instance == "unknown", local.defaults.iosxe.configuration.vtp.mode == "transparent" && local.defaults.iosxe.configuration.vtp.mode_instance == "unknown", false) ? true : false
  mode_transparent_vlan    = try(local.device_config[each.value.name].vtp.mode == "transparent" && local.device_config[each.value.name].vtp.mode_instance == "vlan", local.defaults.iosxe.configuration.vtp.mode == "transparent" && local.defaults.iosxe.configuration.vtp.mode_instance == "vlan", false) ? true : false
  password                 = try(local.device_config[each.value.name].vtp.password, local.defaults.iosxe.configuration.vtp.password, null)
  password_hidden          = try(local.device_config[each.value.name].vtp.password_hidden, local.defaults.iosxe.configuration.vtp.password_hidden, null)
  password_secret          = try(local.device_config[each.value.name].vtp.password_secret, local.defaults.iosxe.configuration.vtp.password_secret, null)
  pruning                  = try(local.device_config[each.value.name].vtp.pruning, local.defaults.iosxe.configuration.vtp.pruning, null)
  version                  = try(local.device_config[each.value.name].vtp.version, local.defaults.iosxe.configuration.vtp.version, null)

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}
