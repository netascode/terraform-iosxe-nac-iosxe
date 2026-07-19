locals {
  # Non-VRF static routes
  static_routes = flatten([
    for device in local.devices : [
      for static_route in try(local.device_config[device.name].routing.static_routes, []) : {
        device_name = device.name
        prefix      = try(static_route.prefix, null)
        mask        = try(static_route.mask, null)
        next_hops = try(length(static_route.next_hops) == 0, true) ? null : [for hop in static_route.next_hops : {
          next_hop  = try(hop.ip, "${hop.interface_type}${trimprefix(hop.interface_id, "$string ")}", null)
          distance  = try(hop.distance, null)
          global    = try(hop.global, null)
          name      = try(hop.name, null)
          permanent = try(hop.permanent, null)
          tag       = try(hop.tag, null)
        } if try(hop.track_id, null) == null]
        next_hops_with_track = try(length(static_route.next_hops) == 0, true) ? null : [for hop in static_route.next_hops : {
          next_hop      = try(hop.ip, "${hop.interface_type}${trimprefix(hop.interface_id, "$string ")}", null)
          distance      = try(hop.distance, null)
          name          = try(hop.name, null)
          permanent     = try(hop.permanent, null)
          tag           = try(hop.tag, null)
          track_id_name = try(hop.track_id, null)
        } if try(hop.track_id, null) != null]
        key = format("%s/%s/%s", device.name,
          try(static_route.prefix, null),
        try(static_route.mask, null))
      } if try(static_route.vrf, null) == null # Only non-VRF routes
    ]
  ])

  # VRF static routes grouped by VRF
  static_routes_vrf = flatten([
    for device in local.devices : [
      for vrf_name, vrf_routes in {
        for static_route in try(local.device_config[device.name].routing.static_routes, []) :
        try(static_route.vrf, "") => static_route...
        if try(static_route.vrf, null) != null
        } : {
        device_name = device.name
        vrf         = vrf_name
        routes = try(length(vrf_routes) == 0, true) ? null : [for static_route in vrf_routes : {
          prefix = try(static_route.prefix, null)
          mask   = try(static_route.mask, null)
          next_hops = try(length(static_route.next_hops) == 0, true) ? null : [for hop in static_route.next_hops : {
            next_hop  = try(hop.ip, "${hop.interface_type}${trimprefix(hop.interface_id, "$string ")}", null)
            distance  = try(hop.distance, null)
            global    = try(hop.global, null)
            name      = try(hop.name, null)
            permanent = try(hop.permanent, null)
            tag       = try(hop.tag, null)
          } if try(hop.track_id, null) == null]
          next_hops_with_track = try(length(static_route.next_hops) == 0, true) ? null : [for hop in static_route.next_hops : {
            next_hop      = try(hop.ip, "${hop.interface_type}${trimprefix(hop.interface_id, "$string ")}", null)
            distance      = try(hop.distance, null)
            name          = try(hop.name, null)
            permanent     = try(hop.permanent, null)
            tag           = try(hop.tag, null)
            track_id_name = try(hop.track_id, null)
          } if try(hop.track_id, null) != null]
        }]
        key = format("%s/%s", device.name, vrf_name)
      }
    ]
  ])
}

resource "iosxe_static_route" "static_route" {
  for_each = {
    for route in local.static_routes : route.key => route
  }

  device               = each.value.device_name
  prefix               = each.value.prefix
  mask                 = each.value.mask
  next_hops            = each.value.next_hops
  next_hops_with_track = each.value.next_hops_with_track

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_interface_tunnel.tunnel
  ]
}

resource "iosxe_static_routes_vrf" "static_routes_vrf" {
  for_each = {
    for route_vrf in local.static_routes_vrf : route_vrf.key => route_vrf
  }

  device = each.value.device_name
  vrf    = each.value.vrf
  routes = each.value.routes

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_interface_tunnel.tunnel
  ]
}
