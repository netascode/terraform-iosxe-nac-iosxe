locals {
  privilege_modes = flatten([
    for device in local.devices : [
      for mode in distinct([for m in try(local.device_config[device.name].aaa.privilege_command_mappings, []) : m.mode]) : {
        key    = format("%s/%s", device.name, mode)
        device = device.name
        name   = mode
        levels = [for m in try(local.device_config[device.name].aaa.privilege_command_mappings, []) : {
          level = m.level
          commands = [for c in try(m.commands, []) : {
            command = c
          }]
        } if m.mode == mode]
      }
    ]
  ])
}

resource "iosxe_privilege" "privilege" {
  for_each = { for e in local.privilege_modes : e.key => e }
  device   = each.value.device

  name   = each.value.name
  levels = each.value.levels
}
