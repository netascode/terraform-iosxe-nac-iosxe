locals {
  ospf_configurations_with_vrf = flatten([
    for device in local.devices : [
      for ospf in try(local.device_config[device.name].routing.ospf_processes, []) : {
        key    = format("%s/%s", device.name, ospf.id)
        device = device.name
        vrf    = try(ospf.vrf, local.defaults.iosxe.configuration.routing.ospf_processes.vrf, null)

        process_id                                    = try(ospf.id, local.defaults.iosxe.configuration.routing.ospf_processes.id, null)
        bfd_all_interfaces                            = try(ospf.bfd_all_interfaces, local.defaults.iosxe.configuration.routing.ospf_processes.bfd_all_interfaces, null)
        default_information_originate                 = try(ospf.default_information_originate, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate, null)
        default_information_originate_always          = try(ospf.default_information_originate_always, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate_always, null)
        default_metric                                = try(ospf.default_metric, local.defaults.iosxe.configuration.routing.ospf_processes.default_metric, null)
        distance                                      = try(ospf.distance, local.defaults.iosxe.configuration.routing.ospf_processes.distance, null)
        domain_tag                                    = try(ospf.domain_tag, local.defaults.iosxe.configuration.routing.ospf_processes.domain_tag, null)
        log_adjacency_changes                         = try(ospf.log_adjacency_changes, local.defaults.iosxe.configuration.routing.ospf_processes.log_adjacency_changes, null)
        log_adjacency_changes_detail                  = try(ospf.log_adjacency_changes_detail, local.defaults.iosxe.configuration.routing.ospf_processes.log_adjacency_changes_detail, null)
        max_metric_router_lsa                         = try(ospf.max_metric_router_lsa, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa, null)
        max_metric_router_lsa_external_lsa_metric     = try(ospf.max_metric_router_lsa_external_lsa_metric, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_external_lsa_metric, null)
        max_metric_router_lsa_include_stub            = try(ospf.max_metric_router_lsa_include_stub, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_include_stub, null)
        max_metric_router_lsa_on_startup_time         = try(ospf.max_metric_router_lsa_on_startup_time, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_on_startup_time, null)
        max_metric_router_lsa_on_startup_wait_for_bgp = try(ospf.max_metric_router_lsa_on_startup_wait_for_bgp, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_on_startup_wait_for_bgp, null)
        max_metric_router_lsa_summary_lsa_metric      = try(ospf.max_metric_router_lsa_summary_lsa_metric, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_summary_lsa_metric, null)
        mpls_ldp_autoconfig                           = try(ospf.mpls_ldp_autoconfig, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_autoconfig, null)
        mpls_ldp_sync                                 = try(ospf.mpls_ldp_sync, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_sync, null)
        nsf_cisco                                     = try(ospf.nsf_cisco, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_cisco, null)
        nsf_cisco_enforce_global                      = try(ospf.nsf_cisco_enforce_global, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_cisco_enforce_global, null)
        nsf_ietf                                      = try(ospf.nsf_ietf, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_ietf, null)
        nsf_ietf_restart_interval                     = try(ospf.nsf_ietf_restart_interval, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_ietf_restart_interval, null)
        priority                                      = try(ospf.priority, local.defaults.iosxe.configuration.routing.ospf_processes.priority, null)
        redistribute_connected_subnets                = try(ospf.redistribute_connected_subnets, local.defaults.iosxe.configuration.routing.ospf_processes.redistribute_connected_subnets, null)
        redistribute_static_subnets                   = try(ospf.redistribute_static_subnets, local.defaults.iosxe.configuration.routing.ospf_processes.redistribute_static_subnets, null)
        router_id                                     = try(ospf.router_id, local.defaults.iosxe.configuration.routing.ospf_processes.router_id, null)
        shutdown                                      = try(ospf.shutdown, local.defaults.iosxe.configuration.routing.ospf_processes.shutdown, null)
        passive_interface_default                     = try(ospf.passive_interface_default, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interface_default, null)
        auto_cost_reference_bandwidth                 = try(ospf.auto_cost_reference_bandwidth, local.defaults.iosxe.configuration.routing.ospf_processes.auto_cost_reference_bandwidth, null)
        passive_interface = try(length(ospf.passive_interfaces) == 0, true) ? null : [for pi in ospf.passive_interfaces :
          format("%s%s", try(pi.interface_type, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_type), try(pi.interface_id, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_id))
        if try(pi.interface_type, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_type, null) != null && try(pi.interface_id, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_id, null) != null]

        neighbor = try(length(ospf.neighbors) == 0, true) ? null : [for neighbor in ospf.neighbors : {
          ip       = try(neighbor.ip, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.ip, null)
          priority = try(neighbor.priority, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.priority, null)
          cost     = try(neighbor.cost, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.cost, null)
        }]

        network = try(length(ospf.networks) == 0, true) ? null : [for network in ospf.networks : {
          ip       = try(network.ip, local.defaults.iosxe.configuration.routing.ospf_processes.networks.ip, null)
          wildcard = try(network.wildcard, local.defaults.iosxe.configuration.routing.ospf_processes.networks.wildcard, null)
          area     = try(network.area, local.defaults.iosxe.configuration.routing.ospf_processes.networks.area, null)
        }]

        summary_address = try(length(ospf.summary_addresses) == 0, true) ? null : [for summary in ospf.summary_addresses : {
          ip   = try(summary.ip, local.defaults.iosxe.configuration.routing.ospf_processes.summary_addresses.ip, null)
          mask = try(summary.mask, local.defaults.iosxe.configuration.routing.ospf_processes.summary_addresses.mask, null)
        }]

        areas = try(length(ospf.areas) == 0, true) ? null : [for area in ospf.areas : {
          area_id                                        = try(area.id, local.defaults.iosxe.configuration.routing.ospf_processes.areas.id, null)
          authentication_message_digest                  = try(area.authentication_message_digest, local.defaults.iosxe.configuration.routing.ospf_processes.areas.authentication_message_digest, null)
          nssa                                           = try(area.nssa, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa, null)
          nssa_default_information_originate             = try(area.nssa_default_information_originate, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_default_information_originate, null)
          nssa_default_information_originate_metric      = try(area.nssa_default_information_originate_metric, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_default_information_originate_metric, null)
          nssa_default_information_originate_metric_type = try(area.nssa_default_information_originate_metric_type, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_default_information_originate_metric_type, null)
          nssa_no_summary                                = try(area.nssa_no_summary, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_no_summary, null)
          nssa_no_redistribution                         = try(area.nssa_no_redistribution, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_no_redistribution, null)
        }]
      } if try(ospf.vrf, local.defaults.iosxe.configuration.routing.ospf_processes.vrf, null) != null && try(ospf.vrf, local.defaults.iosxe.configuration.routing.ospf_processes.vrf, "") != ""
    ]
  ])

  ospf_configurations_without_vrf = flatten([
    for device in local.devices : [
      for ospf in try(local.device_config[device.name].routing.ospf_processes, []) : {
        key    = format("%s/%s", device.name, ospf.id)
        device = device.name

        process_id                                     = try(ospf.id, local.defaults.iosxe.configuration.routing.ospf_processes.id, null)
        bfd_all_interfaces                             = try(ospf.bfd_all_interfaces, local.defaults.iosxe.configuration.routing.ospf_processes.bfd_all_interfaces, null)
        default_information_originate                  = try(ospf.default_information_originate, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate, null)
        default_information_originate_always           = try(ospf.default_information_originate_always, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate_always, null)
        default_metric                                 = try(ospf.default_metric, local.defaults.iosxe.configuration.routing.ospf_processes.default_metric, null)
        distance                                       = try(ospf.distance, local.defaults.iosxe.configuration.routing.ospf_processes.distance, null)
        domain_tag                                     = try(ospf.domain_tag, local.defaults.iosxe.configuration.routing.ospf_processes.domain_tag, null)
        fast_reroute_per_prefix_enable_prefix_priority = try(ospf.fast_reroute_per_prefix_enable_prefix_priority, local.defaults.iosxe.configuration.routing.ospf_processes.fast_reroute_per_prefix_enable_prefix_priority, null)
        log_adjacency_changes                          = try(ospf.log_adjacency_changes, local.defaults.iosxe.configuration.routing.ospf_processes.log_adjacency_changes, null)
        log_adjacency_changes_detail                   = try(ospf.log_adjacency_changes_detail, local.defaults.iosxe.configuration.routing.ospf_processes.log_adjacency_changes_detail, null)
        max_metric_router_lsa                          = try(ospf.max_metric_router_lsa, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa, null)
        max_metric_router_lsa_external_lsa_metric      = try(ospf.max_metric_router_lsa_external_lsa_metric, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_external_lsa_metric, null)
        max_metric_router_lsa_include_stub             = try(ospf.max_metric_router_lsa_include_stub, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_include_stub, null)
        max_metric_router_lsa_on_startup_time          = try(ospf.max_metric_router_lsa_on_startup_time, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_on_startup_time, null)
        max_metric_router_lsa_on_startup_wait_for_bgp  = try(ospf.max_metric_router_lsa_on_startup_wait_for_bgp, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_on_startup_wait_for_bgp, null)
        max_metric_router_lsa_summary_lsa_metric       = try(ospf.max_metric_router_lsa_summary_lsa_metric, local.defaults.iosxe.configuration.routing.ospf_processes.max_metric_router_lsa_summary_lsa_metric, null)
        mpls_ldp_autoconfig                            = try(ospf.mpls_ldp_autoconfig, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_autoconfig, null)
        mpls_ldp_sync                                  = try(ospf.mpls_ldp_sync, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_sync, null)
        nsf_cisco                                      = try(ospf.nsf_cisco, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_cisco, null)
        nsf_cisco_enforce_global                       = try(ospf.nsf_cisco_enforce_global, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_cisco_enforce_global, null)
        nsf_ietf                                       = try(ospf.nsf_ietf, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_ietf, null)
        nsf_ietf_restart_interval                      = try(ospf.nsf_ietf_restart_interval, local.defaults.iosxe.configuration.routing.ospf_processes.nsf_ietf_restart_interval, null)
        priority                                       = try(ospf.priority, local.defaults.iosxe.configuration.routing.ospf_processes.priority, null)
        redistribute_connected_subnets                 = try(ospf.redistribute_connected_subnets, local.defaults.iosxe.configuration.routing.ospf_processes.redistribute_connected_subnets, null)
        redistribute_static_subnets                    = try(ospf.redistribute_static_subnets, local.defaults.iosxe.configuration.routing.ospf_processes.redistribute_static_subnets, null)
        router_id                                      = try(ospf.router_id, local.defaults.iosxe.configuration.routing.ospf_processes.router_id, null)
        shutdown                                       = try(ospf.shutdown, local.defaults.iosxe.configuration.routing.ospf_processes.shutdown, null)
        passive_interface_default                      = try(ospf.passive_interface_default, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interface_default, null)
        auto_cost_reference_bandwidth                  = try(ospf.auto_cost_reference_bandwidth, local.defaults.iosxe.configuration.routing.ospf_processes.auto_cost_reference_bandwidth, null)
        passive_interface = try(length(ospf.passive_interfaces) == 0, true) ? null : [for pi in ospf.passive_interfaces :
          format("%s%s", try(pi.interface_type, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_type), try(pi.interface_id, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_id))
        if try(pi.interface_type, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_type, null) != null && try(pi.interface_id, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interfaces.interface_id, null) != null]

        neighbors = try(length(ospf.neighbors) == 0, true) ? null : [for neighbor in ospf.neighbors : {
          ip       = try(neighbor.ip, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.ip, null)
          priority = try(neighbor.priority, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.priority, null)
          cost     = try(neighbor.cost, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.cost, null)
        }]

        networks = try(length(ospf.networks) == 0, true) ? null : [for network in ospf.networks : {
          ip       = try(network.ip, local.defaults.iosxe.configuration.routing.ospf_processes.networks.ip, null)
          wildcard = try(network.wildcard, local.defaults.iosxe.configuration.routing.ospf_processes.networks.wildcard, null)
          area     = try(network.area, local.defaults.iosxe.configuration.routing.ospf_processes.networks.area, null)
        }]

        summary_addresses = try(length(ospf.summary_addresses) == 0, true) ? null : [for summary in ospf.summary_addresses : {
          ip   = try(summary.ip, local.defaults.iosxe.configuration.routing.ospf_processes.summary_addresses.ip, null)
          mask = try(summary.mask, local.defaults.iosxe.configuration.routing.ospf_processes.summary_addresses.mask, null)
        }]

        areas = try(length(ospf.areas) == 0, true) ? null : [for area in ospf.areas : {
          area_id                                        = try(area.id, local.defaults.iosxe.configuration.routing.ospf_processes.areas.id, null)
          authentication_message_digest                  = try(area.authentication_message_digest, local.defaults.iosxe.configuration.routing.ospf_processes.areas.authentication_message_digest, null)
          nssa                                           = try(area.nssa, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa, null)
          nssa_default_information_originate             = try(area.nssa_default_information_originate, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_default_information_originate, null)
          nssa_default_information_originate_metric      = try(area.nssa_default_information_originate_metric, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_default_information_originate_metric, null)
          nssa_default_information_originate_metric_type = try(area.nssa_default_information_originate_metric_type, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_default_information_originate_metric_type, null)
          nssa_no_summary                                = try(area.nssa_no_summary, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_no_summary, null)
          nssa_no_redistribution                         = try(area.nssa_no_redistribution, local.defaults.iosxe.configuration.routing.ospf_processes.areas.nssa_no_redistribution, null)
        }]
      } if try(ospf.vrf, local.defaults.iosxe.configuration.routing.ospf_processes.vrf, null) == null || try(ospf.vrf, local.defaults.iosxe.configuration.routing.ospf_processes.vrf, "") == ""
    ]
  ])
}

resource "iosxe_ospf" "ospf" {
  for_each = { for o in local.ospf_configurations_without_vrf : o.key => o }
  device   = each.value.device

  process_id                                     = each.value.process_id
  router_id                                      = each.value.router_id
  shutdown                                       = each.value.shutdown
  priority                                       = each.value.priority
  default_metric                                 = each.value.default_metric
  distance                                       = each.value.distance
  domain_tag                                     = each.value.domain_tag
  fast_reroute_per_prefix_enable_prefix_priority = each.value.fast_reroute_per_prefix_enable_prefix_priority
  log_adjacency_changes                          = each.value.log_adjacency_changes
  log_adjacency_changes_detail                   = each.value.log_adjacency_changes_detail
  max_metric_router_lsa                          = each.value.max_metric_router_lsa
  max_metric_router_lsa_external_lsa_metric      = each.value.max_metric_router_lsa_external_lsa_metric
  max_metric_router_lsa_include_stub             = each.value.max_metric_router_lsa_include_stub
  max_metric_router_lsa_on_startup_time          = each.value.max_metric_router_lsa_on_startup_time
  max_metric_router_lsa_on_startup_wait_for_bgp  = each.value.max_metric_router_lsa_on_startup_wait_for_bgp
  max_metric_router_lsa_summary_lsa_metric       = each.value.max_metric_router_lsa_summary_lsa_metric
  mpls_ldp_autoconfig                            = each.value.mpls_ldp_autoconfig
  mpls_ldp_sync                                  = each.value.mpls_ldp_sync
  nsf_cisco                                      = each.value.nsf_cisco
  nsf_cisco_enforce_global                       = each.value.nsf_cisco_enforce_global
  nsf_ietf                                       = each.value.nsf_ietf
  nsf_ietf_restart_interval                      = each.value.nsf_ietf_restart_interval
  redistribute_connected_subnets                 = each.value.redistribute_connected_subnets
  redistribute_static_subnets                    = each.value.redistribute_static_subnets
  bfd_all_interfaces                             = each.value.bfd_all_interfaces
  default_information_originate                  = each.value.default_information_originate
  default_information_originate_always           = each.value.default_information_originate_always
  passive_interface_default                      = each.value.passive_interface_default
  auto_cost_reference_bandwidth                  = each.value.auto_cost_reference_bandwidth
  passive_interface                              = each.value.passive_interface
  neighbors                                      = each.value.neighbors
  networks                                       = each.value.networks
  summary_addresses                              = each.value.summary_addresses
  areas                                          = each.value.areas

  depends_on = [iosxe_system.system]
}

resource "iosxe_ospf_vrf" "ospf_vrf" {
  for_each = { for o in local.ospf_configurations_with_vrf : o.key => o }
  device   = each.value.device

  vrf                                           = each.value.vrf
  process_id                                    = each.value.process_id
  router_id                                     = each.value.router_id
  shutdown                                      = each.value.shutdown
  priority                                      = each.value.priority
  default_metric                                = each.value.default_metric
  distance                                      = each.value.distance
  domain_tag                                    = each.value.domain_tag
  log_adjacency_changes                         = each.value.log_adjacency_changes
  log_adjacency_changes_detail                  = each.value.log_adjacency_changes_detail
  max_metric_router_lsa                         = each.value.max_metric_router_lsa
  max_metric_router_lsa_external_lsa_metric     = each.value.max_metric_router_lsa_external_lsa_metric
  max_metric_router_lsa_include_stub            = each.value.max_metric_router_lsa_include_stub
  max_metric_router_lsa_on_startup_time         = each.value.max_metric_router_lsa_on_startup_time
  max_metric_router_lsa_on_startup_wait_for_bgp = each.value.max_metric_router_lsa_on_startup_wait_for_bgp
  max_metric_router_lsa_summary_lsa_metric      = each.value.max_metric_router_lsa_summary_lsa_metric
  mpls_ldp_autoconfig                           = each.value.mpls_ldp_autoconfig
  mpls_ldp_sync                                 = each.value.mpls_ldp_sync
  nsf_cisco                                     = each.value.nsf_cisco
  nsf_cisco_enforce_global                      = each.value.nsf_cisco_enforce_global
  nsf_ietf                                      = each.value.nsf_ietf
  nsf_ietf_restart_interval                     = each.value.nsf_ietf_restart_interval
  redistribute_connected_subnets                = each.value.redistribute_connected_subnets
  redistribute_static_subnets                   = each.value.redistribute_static_subnets
  bfd_all_interfaces                            = each.value.bfd_all_interfaces
  default_information_originate                 = each.value.default_information_originate
  default_information_originate_always          = each.value.default_information_originate_always
  passive_interface_default                     = each.value.passive_interface_default
  auto_cost_reference_bandwidth                 = each.value.auto_cost_reference_bandwidth
  passive_interface                             = each.value.passive_interface
  neighbor                                      = each.value.neighbor
  network                                       = each.value.network
  summary_address                               = each.value.summary_address
  areas                                         = each.value.areas

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_system.system
  ]
}
