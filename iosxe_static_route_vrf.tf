resource "cisco_iosxe_static_route_vrf" "static_routes" {
  for_each = {
    for device in local.devices :
    device.name => device
    if try(local.device_config[device.name].static_routes, null) != null
  }

  device = each.value.name

  vrf = try(
    local.device_config[each.value.name].static_routes.vrf,
    local.defaults.iosxe.configuration.static_routes.vrf,
    null
  )

  routes = [
    for route in try(local.device_config[each.value.name].static_routes.routes, []) : {
      prefix = try(route.prefix, local.defaults.iosxe.configuration.static_routes.routes.prefix)
      mask   = try(route.mask, local.defaults.iosxe.configuration.static_routes.routes.mask)

      next_hops = [
        for hop in try(route.next_hops, []) : {
          next_hop  = try(hop.next_hop, local.defaults.iosxe.configuration.static_routes.routes.next_hops.next_hop)
          metric    = try(hop.metric, local.defaults.iosxe.configuration.static_routes.routes.next_hops.metric, null)
          permanent = try(hop.permanent, local.defaults.iosxe.configuration.static_routes.routes.next_hops.permanent, null)
          tag       = try(hop.tag, local.defaults.iosxe.configuration.static_routes.routes.next_hops.tag, null)
          name      = try(hop.name, local.defaults.iosxe.configuration.static_routes.routes.next_hops.name, null)
          global    = try(hop.global, local.defaults.iosxe.configuration.static_routes.routes.next_hops.global, null)
        }
      ]
    }
  ]
}