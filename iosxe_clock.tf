resource "iosxe_clock" "clock" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].clock, null) != null || try(local.defaults.iosxe.configuration.clock, null) != null }
  device   = each.value.name

  calendar_valid                      = try(local.device_config[each.value.name].clock.calendar_valid, local.defaults.iosxe.configuration.clock.calendar_valid, null)
  summer_time_zone                    = try(local.device_config[each.value.name].clock.summer_time.zone, local.defaults.iosxe.configuration.clock.summer_time.zone, null)
  summer_time_date                    = try(local.device_config[each.value.name].clock.summer_time.date, local.defaults.iosxe.configuration.clock.summer_time.date, null)
  summer_time_date_start_day          = try(local.device_config[each.value.name].clock.summer_time.date_start_day, local.defaults.iosxe.configuration.clock.summer_time.date_start_day, null)
  summer_time_date_start_month        = try(local.device_config[each.value.name].clock.summer_time.date_start_month, local.defaults.iosxe.configuration.clock.summer_time.date_start_month, null)
  summer_time_date_start_year         = try(local.device_config[each.value.name].clock.summer_time.date_start_year, local.defaults.iosxe.configuration.clock.summer_time.date_start_year, null)
  summer_time_date_start_time         = try(local.device_config[each.value.name].clock.summer_time.date_start_time, local.defaults.iosxe.configuration.clock.summer_time.date_start_time, null)
  summer_time_date_end_day            = try(local.device_config[each.value.name].clock.summer_time.date_end_day, local.defaults.iosxe.configuration.clock.summer_time.date_end_day, null)
  summer_time_date_end_month          = try(local.device_config[each.value.name].clock.summer_time.date_end_month, local.defaults.iosxe.configuration.clock.summer_time.date_end_month, null)
  summer_time_date_end_year           = try(local.device_config[each.value.name].clock.summer_time.date_end_year, local.defaults.iosxe.configuration.clock.summer_time.date_end_year, null)
  summer_time_date_end_time           = try(local.device_config[each.value.name].clock.summer_time.date_end_time, local.defaults.iosxe.configuration.clock.summer_time.date_end_time, null)
  summer_time_date_offset             = try(local.device_config[each.value.name].clock.summer_time.date_offset, local.defaults.iosxe.configuration.clock.summer_time.date_offset, null)
  summer_time_recurring               = try(local.device_config[each.value.name].clock.summer_time.recurring, local.defaults.iosxe.configuration.clock.summer_time.recurring, null)
  summer_time_recurring_start_week    = try(local.device_config[each.value.name].clock.summer_time.recurring_start_week, local.defaults.iosxe.configuration.clock.summer_time.recurring_start_week, null)
  summer_time_recurring_start_weekday = try(local.device_config[each.value.name].clock.summer_time.recurring_start_weekday, local.defaults.iosxe.configuration.clock.summer_time.recurring_start_weekday, null)
  summer_time_recurring_start_month   = try(local.device_config[each.value.name].clock.summer_time.recurring_start_month, local.defaults.iosxe.configuration.clock.summer_time.recurring_start_month, null)
  summer_time_recurring_start_time    = try(local.device_config[each.value.name].clock.summer_time.recurring_start_time, local.defaults.iosxe.configuration.clock.summer_time.recurring_start_time, null)
  summer_time_recurring_end_week      = try(local.device_config[each.value.name].clock.summer_time.recurring_end_week, local.defaults.iosxe.configuration.clock.summer_time.recurring_end_week, null)
  summer_time_recurring_end_weekday   = try(local.device_config[each.value.name].clock.summer_time.recurring_end_weekday, local.defaults.iosxe.configuration.clock.summer_time.recurring_end_weekday, null)
  summer_time_recurring_end_month     = try(local.device_config[each.value.name].clock.summer_time.recurring_end_month, local.defaults.iosxe.configuration.clock.summer_time.recurring_end_month, null)
  summer_time_recurring_end_time      = try(local.device_config[each.value.name].clock.summer_time.recurring_end_time, local.defaults.iosxe.configuration.clock.summer_time.recurring_end_time, null)
  summer_time_recurring_offset        = try(local.device_config[each.value.name].clock.summer_time.recurring_offset, local.defaults.iosxe.configuration.clock.summer_time.recurring_offset, null)
}