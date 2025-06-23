locals {
  static_routes = flatten([
    for device in local.devices : [
      for static_route in try(local.device_config[device.name].routing.static_routes, []) : {
        device_name = device.name
        prefix      = static_route.prefix
        mask        = static_route.mask
        next_hops   = static_route.next_hops
      }
    ]
  ])
}

# Resource definition for configuring static routes on devices
resource "iosxe_static_route" "static_routes" {
  # Loop through each static route in the flattened list
  for_each = {
    for route in local.static_routes : "${route.device_name}->${route.prefix}->${route.mask}" => route
  }

  device    = each.value.device_name
  prefix    = each.value.prefix
  mask      = each.value.mask
  next_hops = try(each.value.next_hops, null)
}
