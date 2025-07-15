resource "iosxe_bgp" "bgp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].routing.bgp, null) != null }
  device   = each.value.name

  asn                  = try(local.device_config[each.value.name].routing.bgp.as_number, local.defaults.iosxe.configuration.routing.bgp.as_number, null)
  default_ipv4_unicast = try(local.device_config[each.value.name].routing.bgp.default_ipv4_unicast, local.defaults.iosxe.configuration.routing.bgp.default_ipv4_unicast, null)
  log_neighbor_changes = try(local.device_config[each.value.name].routing.bgp.log_neighbor_changes, local.defaults.iosxe.configuration.routing.bgp.log_neighbor_changes, null)
  router_id_loopback   = try(local.device_config[each.value.name].routing.bgp.router_id_loopback, local.defaults.iosxe.configuration.routing.bgp.router_id_loopback, null)
}

locals {
  bgp_neighbors = flatten([
    for device in local.devices : [
      for neighbor in try(local.device_config[device.name].routing.bgp.neighbors, []) : {
        key                                       = format("%s/%s", device.name, neighbor.ip)
        device                                    = device.name
        asn                                       = iosxe_bgp.bgp[device.name].asn
        ip                                        = try(neighbor.ip, null)
        remote_as                                 = try(neighbor.remote_as, local.defaults.iosxe.configuration.routing.bgp.neighbors.remote_as, null)
        description                               = try(neighbor.description, local.defaults.iosxe.configuration.routing.bgp.neighbors.description, null)
        shutdown                                  = try(neighbor.shutdown, local.defaults.iosxe.configuration.routing.bgp.neighbors.shutdown, null)
        cluster_id                                = try(neighbor.cluster_id, local.defaults.iosxe.configuration.routing.bgp.neighbors.cluster_id, null)
        version                                   = try(neighbor.version, local.defaults.iosxe.configuration.routing.bgp.neighbors.version, null)
        disable_connected_check                   = try(neighbor.disable_connected_check, local.defaults.iosxe.configuration.routing.bgp.neighbors.disable_connected_check, null)
        fall_over_default_enable                  = try(neighbor.fall_over_default_enable, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_default_enable, null)
        fall_over_default_route_map               = try(neighbor.fall_over_default_route_map, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_default_route_map, null)
        fall_over_bfd_multi_hop                   = try(neighbor.fall_over_bfd_multi_hop, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_bfd_multi_hop, null)
        fall_over_bfd_single_hop                  = try(neighbor.fall_over_bfd_single_hop, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_bfd_single_hop, null)
        fall_over_bfd_check_control_plane_failure = try(neighbor.fall_over_bfd_check_control_plane_failure, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_bfd_check_control_plane_failure, null)
        fall_over_bfd_strict_mode                 = try(neighbor.fall_over_bfd_strict_mode, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_bfd_strict_mode, null)
        fall_over_maximum_metric_route_map        = try(neighbor.fall_over_maximum_metric_route_map, local.defaults.iosxe.configuration.routing.bgp.neighbors.fall_over_maximum_metric_route_map, null)
        local_as                                  = try(neighbor.local_as, local.defaults.iosxe.configuration.routing.bgp.neighbors.local_as, null)
        local_as_no_prepend                       = try(neighbor.local_as_no_prepend, local.defaults.iosxe.configuration.routing.bgp.neighbors.local_as_no_prepend, null)
        local_as_replace_as                       = try(neighbor.local_as_replace_as, local.defaults.iosxe.configuration.routing.bgp.neighbors.local_as_replace_as, null)
        local_as_dual_as                          = try(neighbor.local_as_dual_as, local.defaults.iosxe.configuration.routing.bgp.neighbors.local_as_dual_as, null)
        log_neighbor_changes                      = try(neighbor.log_neighbor_changes, local.defaults.iosxe.configuration.routing.bgp.neighbors.log_neighbor_changes, null)
        password_type                             = try(neighbor.password_type, local.defaults.iosxe.configuration.routing.bgp.neighbors.password_type, null)
        password                                  = try(neighbor.password, local.defaults.iosxe.configuration.routing.bgp.neighbors.password, null)
        peer_group                                = try(neighbor.peer_group, local.defaults.iosxe.configuration.routing.bgp.neighbors.peer_group, null)
        timers_keepalive_interval                 = try(neighbor.timers_keepalive, local.defaults.iosxe.configuration.routing.bgp.neighbors.timers_keepalive, null)
        timers_holdtime                           = try(neighbor.timers_holdtime, local.defaults.iosxe.configuration.routing.bgp.neighbors.timers_holdtime, null)
        timers_minimum_neighbor_hold              = try(neighbor.timers_minimum_neighbor_holdtime, local.defaults.iosxe.configuration.routing.bgp.neighbors.timers_minimum_neighbor_holdtime, null)
        ttl_security_hops                         = try(neighbor.ttl_security_hops, local.defaults.iosxe.configuration.routing.bgp.neighbors.ttl_security_hops, null)
        update_source_loopback                    = try(neighbor.update_source_loopback, local.defaults.iosxe.configuration.routing.bgp.neighbors.update_source_loopback, null)
        ebgp_multihop                             = try(neighbor.ebgp_multihop, local.defaults.iosxe.configuration.routing.bgp.neighbors.ebgp_multihop, null)
        ebgp_multihop_max_hop                     = try(neighbor.ebgp_multihop_max_hop, local.defaults.iosxe.configuration.routing.bgp.neighbors.ebgp_multihop_max_hop, null)
      }
    ]
  ])
}

resource "iosxe_bgp_neighbor" "bgp_neighbor" {
  for_each = { for e in local.bgp_neighbors : e.key => e }
  device   = each.value.device

  asn                                       = each.value.asn
  ip                                        = each.value.ip
  remote_as                                 = each.value.remote_as
  description                               = each.value.description
  shutdown                                  = each.value.shutdown
  cluster_id                                = each.value.cluster_id
  version                                   = each.value.version
  disable_connected_check                   = each.value.disable_connected_check
  fall_over_default_enable                  = each.value.fall_over_default_enable
  fall_over_default_route_map               = each.value.fall_over_default_route_map
  fall_over_bfd_multi_hop                   = each.value.fall_over_bfd_multi_hop
  fall_over_bfd_single_hop                  = each.value.fall_over_bfd_single_hop
  fall_over_bfd_check_control_plane_failure = each.value.fall_over_bfd_check_control_plane_failure
  fall_over_bfd_strict_mode                 = each.value.fall_over_bfd_strict_mode
  fall_over_maximum_metric_route_map        = each.value.fall_over_maximum_metric_route_map
  local_as                                  = each.value.local_as
  local_as_no_prepend                       = each.value.local_as_no_prepend
  local_as_replace_as                       = each.value.local_as_replace_as
  local_as_dual_as                          = each.value.local_as_dual_as
  log_neighbor_changes                      = each.value.log_neighbor_changes
  password_type                             = each.value.password_type
  password                                  = each.value.password
  peer_group                                = each.value.peer_group
  timers_keepalive_interval                 = each.value.timers_keepalive_interval
  timers_holdtime                           = each.value.timers_holdtime
  timers_minimum_neighbor_hold              = each.value.timers_minimum_neighbor_hold
  ttl_security_hops                         = each.value.ttl_security_hops
  update_source_loopback                    = each.value.update_source_loopback
  ebgp_multihop                             = each.value.ebgp_multihop
  ebgp_multihop_max_hop                     = each.value.ebgp_multihop_max_hop
}

resource "iosxe_bgp_address_family_ipv4" "bgp_address_family_ipv4" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].routing.bgp.address_family.ipv4_unicast, null) != null }
  device   = each.value.name

  asn                                 = iosxe_bgp.bgp[each.value.name].asn
  af_name                             = "unicast"
  ipv4_unicast_redistribute_connected = try(local.device_config[each.value.name].routing.bgp.address_family.ipv4_unicast.redistribute_connected, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.redistribute_connected, null)
  ipv4_unicast_redistribute_static    = try(local.device_config[each.value.name].routing.bgp.address_family.ipv4_unicast.redistribute_static, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.redistribute_static, null)
  ipv4_unicast_aggregate_addresses = [for agg in try(local.device_config[each.value.name].routing.bgp.address_family.ipv4_unicast.aggregate_addresses, []) : {
    ipv4_address = try(agg.address, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.aggregate_addresses.address, null)
    ipv4_mask    = try(agg.mask, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.aggregate_addresses.mask, null)
  }]
  ipv4_unicast_networks_mask = [for net in try(local.device_config[each.value.name].routing.bgp.address_family.ipv4_unicast.networks, []) : {
    network   = try(net.network, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.networks.network, null)
    mask      = try(net.mask, null)
    route_map = try(net.route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.networks.route_map, null)
    backdoor  = try(net.backdoor, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.networks.backdoor, null)
  } if try(net.mask, null) != null]
  ipv4_unicast_networks = [for net in try(local.device_config[each.value.name].routing.bgp.address_family.ipv4_unicast.networks, []) : {
    network   = try(net.network, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.networks.network, null)
    route_map = try(net.route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.networks.route_map, null)
    backdoor  = try(net.backdoor, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.networks.backdoor, null)
  } if try(net.mask, null) == null]
}

resource "iosxe_bgp_address_family_ipv6" "bgp_address_family_ipv6" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].routing.bgp.address_family.ipv6_unicast, null) != null }
  device   = each.value.name

  asn                                 = iosxe_bgp.bgp[each.value.name].asn
  af_name                             = "unicast"
  ipv6_unicast_redistribute_connected = try(local.device_config[each.value.name].routing.bgp.address_family.ipv6_unicast.redistribute_connected, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.redistribute_connected, null)
  ipv6_unicast_redistribute_static    = try(local.device_config[each.value.name].routing.bgp.address_family.ipv6_unicast.redistribute_static, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.redistribute_static, null)
  ipv6_unicast_networks = [for net in try(local.device_config[each.value.name].routing.bgp.address_family.ipv6_unicast.networks, []) : {
    network   = try(net.network, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.networks.network, null)
    route_map = try(net.route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.networks.route_map, null)
    backdoor  = try(net.backdoor, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.networks.backdoor, null)
  }]
}

resource "iosxe_bgp_address_family_l2vpn" "bgp_address_family_l2vpn" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].routing.bgp.address_family.l2vpn_evpn, null) != null }
  device   = each.value.name

  asn     = iosxe_bgp.bgp[each.value.name].asn
  af_name = "evpn"
}

resource "iosxe_bgp_address_family_ipv4_vrf" "bgp_address_family_ipv4_vrf" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].routing.bgp.address_family.ipv4_unicast.vrfs, null) != null }
  device   = each.value.name

  asn     = iosxe_bgp.bgp[each.value.name].asn
  af_name = "unicast"
  vrfs = [for vrf in try(local.device_config[each.value.name].routing.bgp.address_family.ipv4_unicast.vrfs, []) : {
    name                                = vrf.vrf
    ipv4_unicast_advertise_l2vpn_evpn   = try(vrf.advertise_l2vpn_evpn, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.advertise_l2vpn_evpn, null)
    ipv4_unicast_redistribute_connected = try(vrf.redistribute_connected, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.redistribute_connected, null)
    ipv4_unicast_router_id_loopback     = try(vrf.router_id_loopback, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.router_id_loopback, null)
    ipv4_unicast_aggregate_addresses = [for agg in try(vrf.aggregate_addresses, []) : {
      ipv4_address = try(agg.address, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.aggregate_addresses.address, null)
      ipv4_mask    = try(agg.mask, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.aggregate_addresses.mask, null)
    }]
    ipv4_unicast_redistribute_static = try(vrf.redistribute_static, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.redistribute_static, null)
    ipv4_unicast_networks_mask = [for net in try(vrf.networks, []) : {
      network   = try(net.network, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.networks.network, null)
      mask      = try(net.mask, null)
      route_map = try(net.route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.networks.route_map, null)
      backdoor  = try(net.backdoor, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.networks.backdoor, null)
    } if try(net.mask, null) != null]
    ipv4_unicast_networks = [for net in try(vrf.networks, []) : {
      network   = try(net.network, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.networks.network, null)
      route_map = try(net.route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.networks.route_map, null)
      backdoor  = try(net.backdoor, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.networks.backdoor, null)
    } if try(net.mask, null) == null]
  }]
}

resource "iosxe_bgp_address_family_ipv6_vrf" "bgp_address_family_ipv6_vrf" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].routing.bgp.address_family.ipv6_unicast.vrfs, null) != null }
  device   = each.value.name

  asn     = iosxe_bgp.bgp[each.value.name].asn
  af_name = "unicast"
  vrfs = [for vrf in try(local.device_config[each.value.name].routing.bgp.address_family.ipv6_unicast.vrfs, []) : {
    name                                = vrf.vrf
    ipv6_unicast_advertise_l2vpn_evpn   = try(vrf.advertise_l2vpn_evpn, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.advertise_l2vpn_evpn, null)
    ipv6_unicast_redistribute_connected = try(vrf.redistribute_connected, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.redistribute_connected, null)
    ipv6_unicast_redistribute_static    = try(vrf.redistribute_static, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.redistribute_static, null)
    ipv6_unicast_networks = [for net in try(vrf.networks, []) : {
      network   = try(net.network, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.networks.network, null)
      route_map = try(net.route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.networks.route_map, null)
      backdoor  = try(net.backdoor, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.networks.backdoor, null)
      evpn      = try(net.evpn, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.vrfs.networks.evpn, null)
    }]
  }]
}

locals {
  bgp_ipv4_unicast_neighbors = flatten([
    for device in local.devices : [
      for neighbor in try(local.device_config[device.name].routing.bgp.address_family.ipv4_unicast.neighbors, []) : {
        key                         = format("%s/%s", device.name, neighbor.ip)
        device                      = device.name
        asn                         = iosxe_bgp.bgp[device.name].asn
        ip                          = neighbor.ip
        activate                    = try(neighbor.activate, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.activate, true)
        send_community              = try(neighbor.send_community, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.send_community, null)
        route_reflector_client      = try(neighbor.route_reflector_client, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.route_reflector_client, null)
        soft_reconfiguration        = try(neighbor.soft_reconfiguration, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.soft_reconfiguration, null)
        default_originate           = try(neighbor.default_originate, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.default_originate, null)
        default_originate_route_map = try(neighbor.default_originate_route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.default_originate_route_map, null)
        route_maps = [for rm in try(neighbor.route_maps, []) : {
          in_out         = try(rm.direction, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.route_maps.direction, null)
          route_map_name = try(rm.name, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.neighbors.route_maps.name, null)
        }]
      }
    ]
  ])
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "bgp_ipv4_unicast_neighbor" {
  for_each = { for e in local.bgp_ipv4_unicast_neighbors : e.key => e }
  device   = each.value.device

  asn                         = each.value.asn
  ip                          = each.value.ip
  activate                    = each.value.activate
  send_community              = each.value.send_community
  route_reflector_client      = each.value.route_reflector_client
  soft_reconfiguration        = each.value.soft_reconfiguration
  default_originate           = each.value.default_originate
  default_originate_route_map = each.value.default_originate_route_map
  route_maps                  = each.value.route_maps

  depends_on = [iosxe_bgp_neighbor.bgp_neighbor]
}

locals {
  bgp_ipv6_unicast_neighbors = flatten([
    for device in local.devices : [
      for neighbor in try(local.device_config[device.name].routing.bgp.address_family.ipv6_unicast.neighbors, []) : {
        key                         = format("%s/%s", device.name, neighbor.ip)
        device                      = device.name
        asn                         = iosxe_bgp.bgp[device.name].asn
        ip                          = neighbor.ip
        activate                    = try(neighbor.activate, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.activate, true)
        send_community              = try(neighbor.send_community, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.send_community, null)
        route_reflector_client      = try(neighbor.route_reflector_client, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.route_reflector_client, null)
        soft_reconfiguration        = try(neighbor.soft_reconfiguration, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.soft_reconfiguration, null)
        default_originate           = try(neighbor.default_originate, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.default_originate, null)
        default_originate_route_map = try(neighbor.default_originate_route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.default_originate_route_map, null)
        route_maps = [for rm in try(neighbor.route_maps, []) : {
          in_out         = try(rm.in_out, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.route_maps.in_out, null)
          route_map_name = try(rm.route_map_name, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv6_unicast.neighbors.route_maps.route_map_name, null)
        }]
      }
    ]
  ])
}

resource "iosxe_bgp_ipv6_unicast_neighbor" "bgp_ipv6_unicast_neighbor" {
  for_each = { for e in local.bgp_ipv6_unicast_neighbors : e.key => e }
  device   = each.value.device

  asn                         = each.value.asn
  ip                          = each.value.ip
  activate                    = each.value.activate
  send_community              = each.value.send_community
  route_reflector_client      = each.value.route_reflector_client
  soft_reconfiguration        = each.value.soft_reconfiguration
  default_originate           = each.value.default_originate
  default_originate_route_map = each.value.default_originate_route_map
  route_maps                  = each.value.route_maps
}

locals {
  bgp_l2vpn_evpn_neighbors = flatten([
    for device in local.devices : [
      for neighbor in try(local.device_config[device.name].routing.bgp.address_family.l2vpn_evpn.neighbors, []) : {
        key                    = format("%s/%s", device.name, neighbor.ip)
        device                 = device.name
        asn                    = iosxe_bgp.bgp[device.name].asn
        ip                     = neighbor.ip
        activate               = try(neighbor.activate, local.defaults.iosxe.configuration.routing.bgp.address_family.l2vpn_evpn.neighbors.activate, true)
        send_community         = try(neighbor.send_community, local.defaults.iosxe.configuration.routing.bgp.address_family.l2vpn_evpn.neighbors.send_community, null)
        route_reflector_client = try(neighbor.route_reflector_client, local.defaults.iosxe.configuration.routing.bgp.address_family.l2vpn_evpn.neighbors.route_reflector_client, null)
        soft_reconfiguration   = try(neighbor.soft_reconfiguration, local.defaults.iosxe.configuration.routing.bgp.address_family.l2vpn_evpn.neighbors.soft_reconfiguration, null)
      }
    ]
  ])
}

resource "iosxe_bgp_l2vpn_evpn_neighbor" "bgp_l2vpn_evpn_neighbor" {
  for_each = { for e in local.bgp_l2vpn_evpn_neighbors : e.key => e }
  device   = each.value.device

  asn                    = each.value.asn
  ip                     = each.value.ip
  activate               = each.value.activate
  send_community         = each.value.send_community
  route_reflector_client = each.value.route_reflector_client
  soft_reconfiguration   = each.value.soft_reconfiguration
}

locals {
  bgp_ipv4_unicast_vrf_neighbors = flatten([
    for device in local.devices : [
      for vrf in try(local.device_config[device.name].routing.bgp.address_family.ipv4_unicast.vrfs, []) : [
        for neighbor in try(vrf.neighbors, []) : {
          key                                       = format("%s/%s/%s", device.name, vrf.vrf, neighbor.ip)
          device                                    = device.name
          asn                                       = iosxe_bgp.bgp[device.name].asn
          vrf                                       = vrf.vrf
          ip                                        = neighbor.ip
          remote_as                                 = try(neighbor.remote_as, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.remote_as, null)
          description                               = try(neighbor.description, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.description, null)
          shutdown                                  = try(neighbor.shutdown, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.shutdown, null)
          cluster_id                                = try(neighbor.cluster_id, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.cluster_id, null)
          log_neighbor_changes_disable              = try(!neighbor.log_neighbor_changes, !local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.log_neighbor_changes, null)
          password_type                             = try(neighbor.password_type, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.password_type, null)
          password                                  = try(neighbor.password, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.password, null)
          timers_keepalive_interval                 = try(neighbor.timers_keepalive, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.timers_keepalive, null)
          timers_holdtime                           = try(neighbor.timers_holdtime, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.timers_holdtime, null)
          timers_minimum_neighbor_hold              = try(neighbor.timers_minimum_neighbor_holdtime, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.timers_minimum_neighbor_holdtime, null)
          fall_over_default_route_map               = try(neighbor.fall_over_default_route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_default_route_map, null)
          fall_over_bfd                             = try(neighbor.fall_over_bfd, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_bfd, null)
          fall_over_bfd_multi_hop                   = try(neighbor.fall_over_bfd_multi_hop, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_bfd_multi_hop, null)
          fall_over_bfd_single_hop                  = try(neighbor.fall_over_bfd_single_hop, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_bfd_single_hop, null)
          fall_over_bfd_check_control_plane_failure = try(neighbor.fall_over_bfd_check_control_plane_failure, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_bfd_check_control_plane_failure, null)
          fall_over_bfd_strict_mode                 = try(neighbor.fall_over_bfd_strict_mode, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_bfd_strict_mode, null)
          fall_over_maximum_metric_route_map        = try(neighbor.fall_over_maximum_metric_route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.fall_over_maximum_metric_route_map, null)
          disable_connected_check                   = try(neighbor.disable_connected_check, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.disable_connected_check, null)
          ttl_security_hops                         = try(neighbor.ttl_security_hops, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.ttl_security_hops, null)
          local_as                                  = try(neighbor.local_as, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.local_as, null)
          local_as_no_prepend                       = try(neighbor.local_as_no_prepend, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.local_as_no_prepend, null)
          local_as_replace_as                       = try(neighbor.local_as_replace_as, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.local_as_replace_as, null)
          local_as_dual_as                          = try(neighbor.local_as_dual_as, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.local_as_dual_as, null)
          update_source_loopback                    = try(neighbor.update_source_loopback, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.update_source_loopback, null)
          activate                                  = try(neighbor.activate, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.activate, true)
          send_community                            = try(neighbor.send_community, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.send_community, null)
          route_reflector_client                    = try(neighbor.route_reflector_client, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.route_reflector_client, null)
          soft_reconfiguration                      = try(neighbor.soft_reconfiguration, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.soft_reconfiguration, null)
          default_originate                         = try(neighbor.default_originate, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.default_originate, null)
          default_originate_route_map               = try(neighbor.default_originate_route_map, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.default_originate_route_map, null)
          route_maps = [for rm in try(neighbor.route_maps, []) : {
            in_out         = try(rm.direction, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.route_maps.direction, null)
            route_map_name = try(rm.name, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.route_maps.name, null)
          }]
          ebgp_multihop            = try(neighbor.ebgp_multihop, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.ebgp_multihop, null)
          ebgp_multihop_max_hop    = try(neighbor.ebgp_multihop_max_hop, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.ebgp_multihop_max_hop, null)
          ha_mode_graceful_restart = try(neighbor.ha_mode_graceful_restart, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.ha_mode_graceful_restart, null)
          next_hop_self            = try(neighbor.next_hop_self, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.next_hop_self, null)
          next_hop_self_all        = try(neighbor.next_hop_self_all, local.defaults.iosxe.configuration.routing.bgp.address_family_ipv4_unicast.vrfs.neighbors.next_hop_self_all, null)
          advertisement_interval   = try(neighbor.advertisement_interval, local.defaults.iosxe.configuration.routing.bgp.address_family.ipv4_unicast.vrfs.neighbors.advertisement_interval, null)
        }
      ]
    ]
  ])
}

resource "iosxe_bgp_ipv4_unicast_vrf_neighbor" "bgp_ipv4_unicast_vrf_neighbor" {
  for_each = { for e in local.bgp_ipv4_unicast_vrf_neighbors : e.key => e }
  device   = each.value.device

  asn                                       = each.value.asn
  vrf                                       = each.value.vrf
  ip                                        = each.value.ip
  remote_as                                 = each.value.remote_as
  description                               = each.value.description
  shutdown                                  = each.value.shutdown
  cluster_id                                = each.value.cluster_id
  log_neighbor_changes_disable              = each.value.log_neighbor_changes_disable
  password_type                             = each.value.password_type
  password                                  = each.value.password
  timers_keepalive_interval                 = each.value.timers_keepalive_interval
  timers_holdtime                           = each.value.timers_holdtime
  timers_minimum_neighbor_hold              = each.value.timers_minimum_neighbor_hold
  fall_over_default_route_map               = each.value.fall_over_default_route_map
  fall_over_bfd                             = each.value.fall_over_bfd
  fall_over_bfd_multi_hop                   = each.value.fall_over_bfd_multi_hop
  fall_over_bfd_single_hop                  = each.value.fall_over_bfd_single_hop
  fall_over_bfd_check_control_plane_failure = each.value.fall_over_bfd_check_control_plane_failure
  fall_over_bfd_strict_mode                 = each.value.fall_over_bfd_strict_mode
  fall_over_maximum_metric_route_map        = each.value.fall_over_maximum_metric_route_map
  disable_connected_check                   = each.value.disable_connected_check
  ttl_security_hops                         = each.value.ttl_security_hops
  local_as                                  = each.value.local_as
  local_as_no_prepend                       = each.value.local_as_no_prepend
  local_as_replace_as                       = each.value.local_as_replace_as
  local_as_dual_as                          = each.value.local_as_dual_as
  update_source_loopback                    = each.value.update_source_loopback
  activate                                  = each.value.activate
  send_community                            = each.value.send_community
  route_reflector_client                    = each.value.route_reflector_client
  soft_reconfiguration                      = each.value.soft_reconfiguration
  default_originate                         = each.value.default_originate
  default_originate_route_map               = each.value.default_originate_route_map
  route_maps                                = each.value.route_maps
  ebgp_multihop                             = each.value.ebgp_multihop
  ebgp_multihop_max_hop                     = each.value.ebgp_multihop_max_hop
  ha_mode_graceful_restart                  = each.value.ha_mode_graceful_restart
  next_hop_self                             = each.value.next_hop_self
  next_hop_self_all                         = each.value.next_hop_self_all
  advertisement_interval                    = each.value.advertisement_interval
}
