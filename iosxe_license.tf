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
  feature_name                        = try(local.device_config[each.value.name].license.feature_name, local.defaults.iosxe.configuration.license.feature_name, null)
  feature_port_bulk                   = try(local.device_config[each.value.name].license.feature_port_bulk, local.defaults.iosxe.configuration.license.feature_port_bulk, null)
  feature_port_onegig                 = try(local.device_config[each.value.name].license.feature_port_onegig, local.defaults.iosxe.configuration.license.feature_port_onegig, null)
  feature_port_b_6xonegig             = try(local.device_config[each.value.name].license.feature_port_b_6xonegig, local.defaults.iosxe.configuration.license.feature_port_b_6xonegig, null)
  feature_port_tengig                 = try(local.device_config[each.value.name].license.feature_port_tengig, local.defaults.iosxe.configuration.license.feature_port_tengig, null)
}