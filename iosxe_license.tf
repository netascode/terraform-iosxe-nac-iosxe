resource "iosxe_license" "license" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].license, null) != null || try(local.defaults.iosxe.configuration.license, null) != null }
  device   = each.value.name

  boot_level_network_advantage        = try(local.device_config[each.value.name].license.boot_level, local.defaults.iosxe.configuration.license.boot_level, null) == "network-advantage"
  boot_level_network_advantage_addon  = try(local.device_config[each.value.name].license.boot_level_network_advantage_addon, local.defaults.iosxe.configuration.license.boot_level_network_advantage_addon, null)
  boot_level_network_essentials       = try(local.device_config[each.value.name].license.boot_level, local.defaults.iosxe.configuration.license.boot_level, null) == "network-essentials"
  boot_level_network_essentials_addon = try(local.device_config[each.value.name].license.boot_level_network_essentials_addon, local.defaults.iosxe.configuration.license.boot_level_network_essentials_addon, null)
  smart_transport_type                = try(local.device_config[each.value.name].license.smart_transport_type, local.defaults.iosxe.configuration.license.smart_transport_type, null)
  smart_url_cslu                      = try(local.device_config[each.value.name].license.smart_url_cslu, local.defaults.iosxe.configuration.license.smart_url_cslu, null)
  accept_agreement                    = try(local.device_config[each.value.name].license.accept_eula, local.defaults.iosxe.configuration.license.accept_eula, null)
  accept_end                          = try(local.device_config[each.value.name].license.accept_eula, local.defaults.iosxe.configuration.license.accept_eula, null)
  accept_user                         = try(local.device_config[each.value.name].license.accept_eula, local.defaults.iosxe.configuration.license.accept_eula, null)
  udi_pid                             = try(local.device_config[each.value.name].license.udi_pid, local.defaults.iosxe.configuration.license.udi_pid, null)
  udi_sn                              = try(local.device_config[each.value.name].license.udi_sn, local.defaults.iosxe.configuration.license.udi_sn, null)
}