resource "cisco_iosxe_as_path_access_list" "as_path_list" {
  for_each = {
    for device in local.devices :
    device.name => device
    if try(local.device_config[device.name].as_path_access_list, null) != null
  }

  device = each.value.name

  name = try(
    local.device_config[each.value.name].as_path_access_list.name,
    local.defaults.iosxe.configuration.as_path_access_list.name,
    null
  )

  entries = [
    for entry in try(local.device_config[each.value.name].as_path_access_list.entries, []) : {
      action = try(entry.action, local.defaults.iosxe.configuration.as_path_access_list.entries.action)
      regex  = try(entry.regex, local.defaults.iosxe.configuration.as_path_access_list.entries.regex)
    }
  ]
}