resource "iosxe_service" "service" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].service, null) != null }
  device   = each.value.name

  pad                                     = try(local.device_config[each.value.name].service.pad, local.defaults.iosxe.configuration.service.pad, null)
  password_encryption                     = try(local.device_config[each.value.name].service.password_encryption, local.defaults.iosxe.configuration.service.password_encryption, null)
  password_recovery                       = try(local.device_config[each.value.name].service.password_recovery, local.defaults.iosxe.configuration.service.password_recovery, null)
  timestamps                              = try(local.device_config[each.value.name].service.timestamps.enabled, local.defaults.iosxe.configuration.service.timestamps.enabled, null)
  timestamps_debug                        = try(local.device_config[each.value.name].service.timestamps.debug, local.defaults.iosxe.configuration.service.timestamps.debug, null)
  timestamps_debug_datetime               = try(local.device_config[each.value.name].service.timestamps.debug_datetime, local.defaults.iosxe.configuration.service.timestamps.debug_datetime, null)
  timestamps_debug_datetime_msec          = try(local.device_config[each.value.name].service.timestamps.debug_datetime_msec, local.defaults.iosxe.configuration.service.timestamps.debug_datetime_msec, null)
  timestamps_debug_datetime_localtime     = try(local.device_config[each.value.name].service.timestamps.debug_datetime_localtime, local.defaults.iosxe.configuration.service.timestamps.debug_datetime_localtime, null)
  timestamps_debug_datetime_show_timezone = try(local.device_config[each.value.name].service.timestamps.debug_datetime_show_timezone, local.defaults.iosxe.configuration.service.timestamps.debug_datetime_show_timezone, null)
  timestamps_debug_datetime_year          = try(local.device_config[each.value.name].service.timestamps.debug_datetime_year, local.defaults.iosxe.configuration.service.timestamps.debug_datetime_year, null)
  timestamps_debug_uptime                 = try(local.device_config[each.value.name].service.timestamps.debug_uptime, local.defaults.iosxe.configuration.service.timestamps.debug_uptime, null)
  timestamps_log                          = try(local.device_config[each.value.name].service.timestamps.log, local.defaults.iosxe.configuration.service.timestamps.log, null)
  timestamps_log_datetime                 = try(local.device_config[each.value.name].service.timestamps.log_datetime, local.defaults.iosxe.configuration.service.timestamps.log_datetime, null)
  timestamps_log_datetime_msec            = try(local.device_config[each.value.name].service.timestamps.log_datetime_msec, local.defaults.iosxe.configuration.service.timestamps.log_datetime_msec, null)
  timestamps_log_datetime_localtime       = try(local.device_config[each.value.name].service.timestamps.log_datetime_localtime, local.defaults.iosxe.configuration.service.timestamps.log_datetime_localtime, null)
  timestamps_log_datetime_show_timezone   = try(local.device_config[each.value.name].service.timestamps.log_datetime_show_timezone, local.defaults.iosxe.configuration.service.timestamps.log_datetime_show_timezone, null)
  timestamps_log_datetime_year            = try(local.device_config[each.value.name].service.timestamps.log_datetime_year, local.defaults.iosxe.configuration.service.timestamps.log_datetime_year, null)
  timestamps_log_uptime                   = try(local.device_config[each.value.name].service.timestamps.log_uptime, local.defaults.iosxe.configuration.service.timestamps.log_uptime, null)
  dhcp                                    = try(local.device_config[each.value.name].service.dhcp, local.defaults.iosxe.configuration.service.dhcp, null)
  tcp_keepalives_in                       = try(local.device_config[each.value.name].service.tcp_keepalives_in, local.defaults.iosxe.configuration.service.tcp_keepalives_in, null)
  tcp_keepalives_out                      = try(local.device_config[each.value.name].service.tcp_keepalives_out, local.defaults.iosxe.configuration.service.tcp_keepalives_out, null)
  compress_config                         = try(local.device_config[each.value.name].service.compress_config, local.defaults.iosxe.configuration.service.compress_config, null)
  sequence_numbers                        = try(local.device_config[each.value.name].service.sequence_numbers, local.defaults.iosxe.configuration.service.sequence_numbers, null)
  call_home                               = try(local.device_config[each.value.name].service.call_home, local.defaults.iosxe.configuration.service.call_home, null)
}
