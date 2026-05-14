locals {
  zone_pair_security = flatten([
    for device in local.devices : [
      for zone_pair in try(local.device_config[device.name].zone_pair_security, []) : {
        key                         = format("%s/%s", device.name, try(zone_pair.name, null))
        device                      = device.name
        name                        = try(zone_pair.name, local.defaults.iosxe.configuration.zone_pair_security.name, null)
        source                      = try(zone_pair.source, local.defaults.iosxe.configuration.zone_pair_security.source, null)
        destination                 = try(zone_pair.destination, local.defaults.iosxe.configuration.zone_pair_security.destination, null)
        description                 = try(zone_pair.description, local.defaults.iosxe.configuration.zone_pair_security.description, null)
        service_policy_type_inspect = try(zone_pair.service_policy_type_inspect, local.defaults.iosxe.configuration.zone_pair_security.service_policy_type_inspect, null)
      }
    ]
  ])
}

resource "iosxe_zone_pair_security" "zone_pair_security" {
  for_each = { for e in local.zone_pair_security : e.key => e }
  device   = each.value.device

  name                        = each.value.name
  source                      = each.value.source
  destination                 = each.value.destination
  description                 = each.value.description
  service_policy_type_inspect = each.value.service_policy_type_inspect
}
