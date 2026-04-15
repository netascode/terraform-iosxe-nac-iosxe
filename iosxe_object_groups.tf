locals {
  object_groups = {
    for device in local.devices : device.name => {
      device = device.name
      fqdn = try(length(local.device_config[device.name].object_groups_fqdn) == 0, true) ? null : [for og in local.device_config[device.name].object_groups_fqdn : {
        name        = og.name
        description = try(og.description, local.defaults.iosxe.configuration.object_groups_fqdn.description, null)
        group_objects = try(length(og.group_objects) == 0, true) ? null : [for g in og.group_objects : {
          group_name = g
        }]
        patterns = try(length(og.patterns) == 0, true) ? null : [for p in og.patterns : {
          fqdn_pattern = p
        }]
      }]
    } if try(length(local.device_config[device.name].object_groups_fqdn) > 0, false)
  }
}

resource "iosxe_object_group" "object_group" {
  for_each = local.object_groups
  device   = each.value.device

  fqdn = each.value.fqdn
}
