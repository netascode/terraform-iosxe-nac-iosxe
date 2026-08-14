locals {
  eigrp_configurations_with_vrf = flatten([
    for device in local.devices : [
      for eigrp in try(local.device_config[device.name].routing.eigrp_processes, []) : {
        key    = format("%s/%s/%s", device.name, eigrp.name, eigrp.vrf)
        device = device.name

        name              = try(eigrp.name, null)
        vrf               = try(eigrp.vrf, null)
        autonomous_system = try(eigrp.autonomous_system, null)
        router_id         = try(eigrp.router_id, null)
        auto_summary      = try(eigrp.auto_summary, null)
        shutdown          = try(eigrp.shutdown, null)

        networks = try(length(eigrp.networks) == 0, true) ? null : [for network in eigrp.networks : {
          ip       = try(network.ip, null)
          wildcard = try(network.wildcard, null)
        }]
      } if try(eigrp.vrf, null) != null && try(eigrp.vrf, "") != ""
    ]
  ])

  eigrp_configurations_without_vrf = flatten([
    for device in local.devices : [
      for eigrp in try(local.device_config[device.name].routing.eigrp_processes, []) : {
        key    = format("%s/%s", device.name, eigrp.name)
        device = device.name

        name              = try(eigrp.name, null)
        autonomous_system = try(eigrp.autonomous_system, null)
        router_id         = try(eigrp.router_id, null)
        auto_summary      = try(eigrp.auto_summary, null)
        shutdown          = try(eigrp.shutdown, null)

        networks = try(length(eigrp.networks) == 0, true) ? null : [for network in eigrp.networks : {
          ip       = try(network.ip, null)
          wildcard = try(network.wildcard, null)
        }]
      } if try(eigrp.vrf, null) == null || try(eigrp.vrf, "") == ""
    ]
  ])
}

resource "iosxe_eigrp" "eigrp" {
  for_each = { for v in local.eigrp_configurations_without_vrf : v.key => v }

  device = each.value.device

  name              = each.value.name
  autonomous_system = each.value.autonomous_system
  router_id         = each.value.router_id
  auto_summary      = each.value.auto_summary
  shutdown          = each.value.shutdown
  networks          = each.value.networks
}

resource "iosxe_eigrp_vrf" "eigrp_vrf" {
  for_each = { for v in local.eigrp_configurations_with_vrf : v.key => v }

  device = each.value.device

  name              = each.value.name
  vrf               = each.value.vrf
  autonomous_system = each.value.autonomous_system
  router_id         = each.value.router_id
  auto_summary      = each.value.auto_summary
  shutdown          = each.value.shutdown
  networks          = each.value.networks
}
