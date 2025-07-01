locals {
  static_routes = flatten([
    for device in local.devices : [
      for static_route in try(local.device_config[device.name].routing.static_routes, []) : {
        device_name = device.name
        prefix      = try(static_route.prefix, local.defaults.iosxe.configuration.routing.static_routes.prefix, null)
        mask        = try(static_route.mask, local.defaults.iosxe.configuration.routing.static_routes.mask, null)
        next_hops = [for hop in try(static_route.next_hops, local.defaults.iosxe.configuration.routing.static_routes.next_hops, []) : {
          next_hop  = try(hop.ip, local.defaults.iosxe.configuration.routing.static_routes.next_hops.ip, null)
          metric    = try(hop.metric, local.defaults.iosxe.configuration.routing.static_routes.next_hops.metric, null)
          global    = try(hop.global, local.defaults.iosxe.configuration.routing.static_routes.next_hops.global, null)
          name      = try(hop.name, local.defaults.iosxe.configuration.routing.static_routes.next_hops.name, null)
          permanent = try(hop.permanent, local.defaults.iosxe.configuration.routing.static_routes.next_hops.permanent, null)
          tag       = try(hop.tag, local.defaults.iosxe.configuration.routing.static_routes.next_hops.tag, null)
        }]
        key = format("%s/%s/%s", device.name,
          try(static_route.prefix, local.defaults.iosxe.configuration.routing.static_routes.prefix, null),
        try(static_route.mask, local.defaults.iosxe.configuration.routing.static_routes.mask, null))
      }
    ]
  ])
}

resource "iosxe_static_route" "static_routes" {
  for_each = {
    for route in local.static_routes : route.key => route
  }

  device    = each.value.device_name
  prefix    = each.value.prefix
  mask      = each.value.mask
  next_hops = each.value.next_hops
}
