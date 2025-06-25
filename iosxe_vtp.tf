resource "iosxe_vtp" "vtp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].vtp, null) != null || try(local.defaults.iosxe.configuration.vtp, null) != null }
  device   = each.value.name

  domain                   = try(local.device_config[each.value.name].vtp.domain, local.defaults.iosxe.configuration.vtp.domain, null)
  file                     = try(local.device_config[each.value.name].vtp.file, local.defaults.iosxe.configuration.vtp.file, null)
  interface                = try(local.device_config[each.value.name].vtp.interface, local.defaults.iosxe.configuration.vtp.interface, null)
  interface_only           = try(local.device_config[each.value.name].vtp.interface_only, local.defaults.iosxe.configuration.vtp.interface_only, null)
  mode_client_mst          = try(local.device_config[each.value.name].vtp.mode_client_mst, local.defaults.iosxe.configuration.vtp.mode_client_mst, null)
  mode_client_unknown      = try(local.device_config[each.value.name].vtp.mode_client_unknown, local.defaults.iosxe.configuration.vtp.mode_client_unknown, null)
  mode_client_vlan         = try(local.device_config[each.value.name].vtp.mode_client_vlan, local.defaults.iosxe.configuration.vtp.mode_client_vlan, null)
  mode_off_mst             = try(local.device_config[each.value.name].vtp.mode_off_mst, local.defaults.iosxe.configuration.vtp.mode_off_mst, null)
  mode_off_unknown         = try(local.device_config[each.value.name].vtp.mode_off_unknown, local.defaults.iosxe.configuration.vtp.mode_off_unknown, null)
  mode_off_vlan            = try(local.device_config[each.value.name].vtp.mode_off_vlan, local.defaults.iosxe.configuration.vtp.mode_off_vlan, null)
  mode_server_mst          = try(local.device_config[each.value.name].vtp.mode_server_mst, local.defaults.iosxe.configuration.vtp.mode_server_mst, null)
  mode_server_unknown      = try(local.device_config[each.value.name].vtp.mode_server_unknown, local.defaults.iosxe.configuration.vtp.mode_server_unknown, null)
  mode_server_vlan         = try(local.device_config[each.value.name].vtp.mode_server_vlan, local.defaults.iosxe.configuration.vtp.mode_server_vlan, null)
  mode_transparent_mst     = try(local.device_config[each.value.name].vtp.mode_transparent_mst, local.defaults.iosxe.configuration.vtp.mode_transparent_mst, null)
  mode_transparent_unknown = try(local.device_config[each.value.name].vtp.mode_transparent_unknown, local.defaults.iosxe.configuration.vtp.mode_transparent_unknown, null)
  mode_transparent_vlan    = try(local.device_config[each.value.name].vtp.mode_transparent_vlan, local.defaults.iosxe.configuration.vtp.mode_transparent_vlan, null)
  password                 = try(local.device_config[each.value.name].vtp.password, local.defaults.iosxe.configuration.vtp.password, null)
  password_hidden          = try(local.device_config[each.value.name].vtp.password_hidden, local.defaults.iosxe.configuration.vtp.password_hidden, null)
  password_secret          = try(local.device_config[each.value.name].vtp.password_secret, local.defaults.iosxe.configuration.vtp.password_secret, null)
  pruning                  = try(local.device_config[each.value.name].vtp.pruning, local.defaults.iosxe.configuration.vtp.pruning, null)
  version                  = try(local.device_config[each.value.name].vtp.version, local.defaults.iosxe.configuration.vtp.version, null)
  delete_mode              = "all"
}