locals {
  # One iosxe_privilege resource per device and mode. The provider recreates
  # the mode on any change to its levels, because IOS-XE refuses a NETCONF
  # delete of a single command or level.
  privilege_modes = flatten([
    for device in local.devices : [
      for mode in distinct([for m in try(local.device_config[device.name].aaa.privilege_command_mappings, []) : m.mode]) : {
        key    = format("%s/%s", device.name, mode)
        device = device.name
        mode   = mode
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

  mode   = each.value.mode
  levels = each.value.levels

  depends_on = [
    iosxe_cli.cli_pre_9,
  ]
}
