locals {
  stackwise_virtual_interfaces = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].stackwise_virtual.interfaces, []) : {
        key                   = format("%s/%s%s", device.name, try(int.type, local.defaults.iosxe.configuration.stackwise_virtual.interfaces.type, null), int.id)
        device                = device.name
        type                  = try(int.type, local.defaults.iosxe.configuration.stackwise_virtual.interfaces.type, null)
        id                    = int.id
        link                  = try(int.link, local.defaults.iosxe.configuration.stackwise_virtual.interfaces.link, null)
        dual_active_detection = try(int.dual_active_detection, local.defaults.iosxe.configuration.stackwise_virtual.interfaces.dual_active_detection, null)
      }
    ] if try(local.device_config[device.name].stackwise_virtual, null) != null
  ])
}

resource "iosxe_stackwise_virtual" "stackwise_virtual" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].stackwise_virtual, local.defaults.iosxe.configuration.stackwise_virtual, null) != null }
  device   = each.value.name

  domain                                         = try(local.device_config[each.value.name].stackwise_virtual.domain, local.defaults.iosxe.configuration.stackwise_virtual.domain, null)
  dual_active_detection_pagp                     = try(local.device_config[each.value.name].stackwise_virtual.dual_active_detection_pagp, local.defaults.iosxe.configuration.stackwise_virtual.dual_active_detection_pagp, null)
  dual_active_detection_pagp_trust_channel_group = try(local.device_config[each.value.name].stackwise_virtual.dual_active_detection_pagp_trust_channel_group, local.defaults.iosxe.configuration.stackwise_virtual.dual_active_detection_pagp_trust_channel_group, null)
}

resource "iosxe_interface_stackwise_virtual" "stackwise_virtual_interface" {
  for_each = { for v in local.stackwise_virtual_interfaces : v.key => v }

  device                = each.value.device
  type                  = each.value.type
  name                  = each.value.id
  link                  = each.value.link
  dual_active_detection = each.value.dual_active_detection

  depends_on = [
    iosxe_stackwise_virtual.stackwise_virtual
  ]
}
