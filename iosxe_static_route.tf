locals {
  static_routes = flatten([
    for device in local.devices : [
      for static_route in try(local.device_config[device.name].routing.static_routes, local.defaults.iosxe.devices.configuration.routing.static_routes, []) : {
        device_name = device.name
        prefix      = try(static_route.prefix, null)
        mask        = try(static_route.mask, null)
        next_hops   = try(static_route.next_hops, [])
        key         = "${device.name}->${static_route.prefix}->${static_route.mask}"
      }
    ]
  ])
}

resource "iosxe_static_route" "static_routes" {
  for_each = {
    for route in local.static_routes : route.key => route
  }

  device    = try(each.value.device_name, null)
  prefix    = try(each.value.prefix, null)
  mask      = try(each.value.mask, null)
  next_hops = try(each.value.next_hops, null)
}
