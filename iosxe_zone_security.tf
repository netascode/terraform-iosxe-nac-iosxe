locals {
  zone_security = flatten([
    for device in local.devices : [
      for zone in try(local.device_config[device.name].zone_security.zones, []) : {
        key         = format("%s/%s", device.name, zone.name)
        device      = device.name
        name        = try(zone.name, local.defaults.iosxe.configuration.zone_security.zones.name, null)
        description = try(zone.description, local.defaults.iosxe.configuration.zone_security.zones.description, null)
        protection  = try(zone.protection, local.defaults.iosxe.configuration.zone_security.zones.protection, null)
        vpns        = try(zone.vpns, local.defaults.iosxe.configuration.zone_security.zones.vpns, null)
      }
    ]
  ])
}

resource "iosxe_zone_security" "zone_security" {
  for_each = { for e in local.zone_security : e.key => e }
  device   = each.value.device

  name        = each.value.name
  description = each.value.description
  protection  = each.value.protection

  vpns = each.value.vpns == null ? null : [for e in each.value.vpns : {
    id = e.id
  }]
}
