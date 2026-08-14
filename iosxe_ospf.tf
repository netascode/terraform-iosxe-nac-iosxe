locals {
  ospf_configurations_with_vrf = flatten([
    for device in local.devices : [
      for ospf in try(local.device_config[device.name].routing.ospf_processes, []) : {
        key    = format("%s/%s", device.name, ospf.id)
        device = device.name
        vrf    = try(ospf.vrf, null)

        process_id                                    = try(ospf.id, null)
        bfd_all_interfaces                            = try(ospf.bfd_all_interfaces, null)
        default_information_originate                 = try(ospf.default_information_originate, null)
        default_information_originate_always          = try(ospf.default_information_originate_always, null)
        default_information_originate_metric          = try(ospf.default_information_originate_metric, null)
        default_information_originate_metric_type     = try(ospf.default_information_originate_metric_type, null)
        default_information_originate_route_map       = try(ospf.default_information_originate_route_map, null)
        default_metric                                = try(ospf.default_metric, null)
        distance                                      = try(ospf.distance, null)
        domain_tag                                    = try(ospf.domain_tag, null)
        log_adjacency_changes                         = try(ospf.log_adjacency_changes, null)
        log_adjacency_changes_detail                  = try(ospf.log_adjacency_changes_detail, null)
        max_metric_router_lsa                         = try(ospf.max_metric_router_lsa, null)
        max_metric_router_lsa_external_lsa_metric     = try(ospf.max_metric_router_lsa_external_lsa_metric, null)
        max_metric_router_lsa_include_stub            = try(ospf.max_metric_router_lsa_include_stub, null)
        max_metric_router_lsa_on_startup_time         = try(ospf.max_metric_router_lsa_on_startup_time, null)
        max_metric_router_lsa_on_startup_wait_for_bgp = try(ospf.max_metric_router_lsa_on_startup_wait_for_bgp, null)
        max_metric_router_lsa_summary_lsa_metric      = try(ospf.max_metric_router_lsa_summary_lsa_metric, null)
        mpls_ldp_autoconfig                           = try(ospf.mpls_ldp_autoconfig, null)
        mpls_ldp_sync                                 = try(ospf.mpls_ldp_sync, null)
        nsf_cisco                                     = try(ospf.nsf_cisco, null)
        nsf_cisco_enforce_global                      = try(ospf.nsf_cisco_enforce_global, null)
        nsf_ietf                                      = try(ospf.nsf_ietf, null)
        nsf_ietf_restart_interval                     = try(ospf.nsf_ietf_restart_interval, null)
        priority                                      = try(ospf.priority, null)
        redistribute_connected_subnets                = try(ospf.redistribute.connected, null)
        redistribute_connected_metric                 = try(ospf.redistribute.connected_metric, null)
        redistribute_connected_metric_type            = try(tostring(ospf.redistribute.connected_metric_type), null)
        redistribute_connected_route_map              = try(ospf.redistribute.connected_route_map, null)
        redistribute_connected_tag                    = try(ospf.redistribute.connected_tag, null)
        redistribute_static_subnets                   = try(ospf.redistribute.static, null)
        redistribute_static_metric                    = try(ospf.redistribute.static_metric, null)
        redistribute_static_metric_type               = try(tostring(ospf.redistribute.static_metric_type), null)
        redistribute_static_route_map                 = try(ospf.redistribute.static_route_map, null)
        redistribute_static_tag                       = try(ospf.redistribute.static_tag, null)
        redistribute_ospf = try(length(ospf.redistribute.ospf) == 0, true) ? null : [for r in ospf.redistribute.ospf : {
          process_id            = try(r.process_id, null)
          match_internal        = try(r.match_internal, null)
          match_external_1      = try(r.match_external_1 == true ? 1 : null, null)
          match_external_2      = try(r.match_external_2 == true ? 2 : null, null)
          match_nssa_external_1 = try(r.match_nssa_external_1 == true ? 1 : null, null)
          match_nssa_external_2 = try(r.match_nssa_external_2 == true ? 2 : null, null)
          metric                = try(r.metric, null)
          metric_type           = try(tostring(r.metric_type), null)
          subnets               = try(r.subnets, null)
          route_map             = try(r.route_map, null)
          tag                   = try(r.tag, null)
          nssa_only             = try(r.nssa_only, null)
          vrf                   = try(r.vrf, null)
        }]
        distribute_list_in_access_lists  = try(ospf.distribute_list_in, null) != null ? [{ in = "in", access_list = ospf.distribute_list_in }] : null
        distribute_list_out_access_lists = try(ospf.distribute_list_out, null) != null ? [{ out = "out", access_list = ospf.distribute_list_out }] : null
        router_id                        = try(ospf.router_id, null)
        shutdown                         = try(ospf.shutdown, null)
        passive_interface_default        = try(ospf.passive_interface_default, null)
        auto_cost_reference_bandwidth    = try(ospf.auto_cost_reference_bandwidth, null)
        passive_interface = try(length(ospf.passive_interfaces) == 0, true) ? null : [for pi in ospf.passive_interfaces :
          format("%s%s", try(pi.interface_type, null), try(pi.interface_id, null))
        if try(pi.interface_type, null) != null && try(pi.interface_id, null) != null]

        passive_interface_disable_gigabit_ethernets              = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "GigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "GigabitEthernet"] : null
        passive_interface_disable_two_gigabit_ethernets          = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TwoGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TwoGigabitEthernet"] : null
        passive_interface_disable_five_gigabit_ethernets         = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "FiveGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "FiveGigabitEthernet"] : null
        passive_interface_disable_ten_gigabit_ethernets          = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TenGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TenGigabitEthernet"] : null
        passive_interface_disable_twenty_five_gigabit_ethernets  = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TwentyFiveGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TwentyFiveGigabitEthernet"] : null
        passive_interface_disable_forty_gigabit_ethernets        = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "FortyGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "FortyGigabitEthernet"] : null
        passive_interface_disable_hundred_gigabit_ethernets      = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "HundredGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "HundredGigabitEthernet"] : null
        passive_interface_disable_two_hundred_gigabit_ethernets  = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TwoHundredGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TwoHundredGigabitEthernet"] : null
        passive_interface_disable_four_hundred_gigabit_ethernets = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "FourHundredGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "FourHundredGigabitEthernet"] : null
        passive_interface_disable_loopbacks                      = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Loopback"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Loopback"] : null
        passive_interface_disable_vlans                          = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Vlan"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Vlan"] : null
        passive_interface_disable_tunnels                        = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Tunnel"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Tunnel"] : null
        passive_interface_disable_port_channels                  = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Port-channel"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Port-channel"] : null
        passive_interface_disable_port_channel_subinterfaces     = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Port-channel-subinterface"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Port-channel-subinterface"] : null

        neighbor = try(length(ospf.neighbors) == 0, true) ? null : [for neighbor in ospf.neighbors : {
          ip       = try(neighbor.ip, null)
          priority = try(neighbor.priority, null)
          cost     = try(neighbor.cost, null)
        }]

        network = try(length(ospf.networks) == 0, true) ? null : [for network in ospf.networks : {
          ip       = try(network.ip, null)
          wildcard = try(network.wildcard, null)
          area     = try(network.area, null)
        }]

        summary_address = try(length(ospf.summary_addresses) == 0, true) ? null : [for summary in ospf.summary_addresses : {
          ip   = try(summary.ip, null)
          mask = try(summary.mask, null)
        }]

        areas = try(length(ospf.areas) == 0, true) ? null : [for area in ospf.areas : {
          area_id                                        = try(area.id, null)
          authentication_message_digest                  = try(area.authentication_message_digest, null)
          nssa                                           = try(area.nssa, null)
          nssa_default_information_originate             = try(area.nssa_default_information_originate, null)
          nssa_default_information_originate_metric      = try(area.nssa_default_information_originate_metric, null)
          nssa_default_information_originate_metric_type = try(area.nssa_default_information_originate_metric_type, null)
          nssa_no_summary                                = try(area.nssa_no_summary, null)
          nssa_no_redistribution                         = try(area.nssa_no_redistribution, null)
        }]
      } if try(ospf.vrf, null) != null && try(ospf.vrf, "") != ""
    ]
  ])

  ospf_configurations_without_vrf = flatten([
    for device in local.devices : [
      for ospf in try(local.device_config[device.name].routing.ospf_processes, []) : {
        key    = format("%s/%s", device.name, ospf.id)
        device = device.name

        process_id                                     = try(ospf.id, null)
        bfd_all_interfaces                             = try(ospf.bfd_all_interfaces, null)
        default_information_originate                  = try(ospf.default_information_originate, null)
        default_information_originate_always           = try(ospf.default_information_originate_always, null)
        default_information_originate_metric           = try(ospf.default_information_originate_metric, null)
        default_information_originate_metric_type      = try(ospf.default_information_originate_metric_type, null)
        default_information_originate_route_map        = try(ospf.default_information_originate_route_map, null)
        default_metric                                 = try(ospf.default_metric, null)
        distance                                       = try(ospf.distance, null)
        domain_tag                                     = try(ospf.domain_tag, null)
        fast_reroute_per_prefix_enable_prefix_priority = try(ospf.fast_reroute_per_prefix_enable_prefix_priority, null)
        log_adjacency_changes                          = try(ospf.log_adjacency_changes, null)
        log_adjacency_changes_detail                   = try(ospf.log_adjacency_changes_detail, null)
        max_metric_router_lsa                          = try(ospf.max_metric_router_lsa, null)
        max_metric_router_lsa_external_lsa_metric      = try(ospf.max_metric_router_lsa_external_lsa_metric, null)
        max_metric_router_lsa_include_stub             = try(ospf.max_metric_router_lsa_include_stub, null)
        max_metric_router_lsa_on_startup_time          = try(ospf.max_metric_router_lsa_on_startup_time, null)
        max_metric_router_lsa_on_startup_wait_for_bgp  = try(ospf.max_metric_router_lsa_on_startup_wait_for_bgp, null)
        max_metric_router_lsa_summary_lsa_metric       = try(ospf.max_metric_router_lsa_summary_lsa_metric, null)
        mpls_ldp_autoconfig                            = try(ospf.mpls_ldp_autoconfig, null)
        mpls_ldp_sync                                  = try(ospf.mpls_ldp_sync, null)
        nsf_cisco                                      = try(ospf.nsf_cisco, null)
        nsf_cisco_enforce_global                       = try(ospf.nsf_cisco_enforce_global, null)
        nsf_ietf                                       = try(ospf.nsf_ietf, null)
        nsf_ietf_restart_interval                      = try(ospf.nsf_ietf_restart_interval, null)
        priority                                       = try(ospf.priority, null)
        redistribute_connected_subnets                 = try(ospf.redistribute.connected, null)
        redistribute_connected_metric                  = try(ospf.redistribute.connected_metric, null)
        redistribute_connected_metric_type             = try(tostring(ospf.redistribute.connected_metric_type), null)
        redistribute_connected_route_map               = try(ospf.redistribute.connected_route_map, null)
        redistribute_connected_tag                     = try(ospf.redistribute.connected_tag, null)
        redistribute_static_subnets                    = try(ospf.redistribute.static, null)
        redistribute_static_metric                     = try(ospf.redistribute.static_metric, null)
        redistribute_static_metric_type                = try(tostring(ospf.redistribute.static_metric_type), null)
        redistribute_static_route_map                  = try(ospf.redistribute.static_route_map, null)
        redistribute_static_tag                        = try(ospf.redistribute.static_tag, null)
        redistribute_ospf = try(length(ospf.redistribute.ospf) == 0, true) ? null : [for r in ospf.redistribute.ospf : {
          process_id            = try(r.process_id, null)
          match_internal        = try(r.match_internal, null)
          match_external_1      = try(r.match_external_1 == true ? 1 : null, null)
          match_external_2      = try(r.match_external_2 == true ? 2 : null, null)
          match_nssa_external_1 = try(r.match_nssa_external_1 == true ? 1 : null, null)
          match_nssa_external_2 = try(r.match_nssa_external_2 == true ? 2 : null, null)
          metric                = try(r.metric, null)
          metric_type           = try(tostring(r.metric_type), null)
          subnets               = try(r.subnets, null)
          route_map             = try(r.route_map, null)
          tag                   = try(r.tag, null)
          nssa_only             = try(r.nssa_only, null)
          vrf                   = try(r.vrf, null)
        }]
        distribute_list_in_access_lists  = try(ospf.distribute_list_in, null) != null ? [{ in = "in", access_list = ospf.distribute_list_in }] : null
        distribute_list_out_access_lists = try(ospf.distribute_list_out, null) != null ? [{ out = "out", access_list = ospf.distribute_list_out }] : null
        router_id                        = try(ospf.router_id, null)
        shutdown                         = try(ospf.shutdown, null)
        passive_interface_default        = try(ospf.passive_interface_default, null)
        auto_cost_reference_bandwidth    = try(ospf.auto_cost_reference_bandwidth, null)
        passive_interface = try(length(ospf.passive_interfaces) == 0, true) ? null : [for pi in ospf.passive_interfaces :
          format("%s%s", try(pi.interface_type, null), try(pi.interface_id, null))
        if try(pi.interface_type, null) != null && try(pi.interface_id, null) != null]

        passive_interface_disable_gigabit_ethernets              = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "GigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "GigabitEthernet"] : null
        passive_interface_disable_two_gigabit_ethernets          = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TwoGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TwoGigabitEthernet"] : null
        passive_interface_disable_five_gigabit_ethernets         = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "FiveGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "FiveGigabitEthernet"] : null
        passive_interface_disable_ten_gigabit_ethernets          = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TenGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TenGigabitEthernet"] : null
        passive_interface_disable_twenty_five_gigabit_ethernets  = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TwentyFiveGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TwentyFiveGigabitEthernet"] : null
        passive_interface_disable_forty_gigabit_ethernets        = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "FortyGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "FortyGigabitEthernet"] : null
        passive_interface_disable_hundred_gigabit_ethernets      = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "HundredGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "HundredGigabitEthernet"] : null
        passive_interface_disable_two_hundred_gigabit_ethernets  = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "TwoHundredGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "TwoHundredGigabitEthernet"] : null
        passive_interface_disable_four_hundred_gigabit_ethernets = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "FourHundredGigabitEthernet"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "FourHundredGigabitEthernet"] : null
        passive_interface_disable_loopbacks                      = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Loopback"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Loopback"] : null
        passive_interface_disable_vlans                          = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Vlan"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Vlan"] : null
        passive_interface_disable_tunnels                        = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Tunnel"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Tunnel"] : null
        passive_interface_disable_port_channels                  = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Port-channel"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Port-channel"] : null
        passive_interface_disable_port_channel_subinterfaces     = try(length([for npi in ospf.non_passive_interfaces : npi if try(npi.interface_type, "") == "Port-channel-subinterface"]) > 0, false) ? [for npi in ospf.non_passive_interfaces : { name = npi.interface_id } if try(npi.interface_type, "") == "Port-channel-subinterface"] : null

        neighbors = try(length(ospf.neighbors) == 0, true) ? null : [for neighbor in ospf.neighbors : {
          ip       = try(neighbor.ip, null)
          priority = try(neighbor.priority, null)
          cost     = try(neighbor.cost, null)
        }]

        networks = try(length(ospf.networks) == 0, true) ? null : [for network in ospf.networks : {
          ip       = try(network.ip, null)
          wildcard = try(network.wildcard, null)
          area     = try(network.area, null)
        }]

        summary_addresses = try(length(ospf.summary_addresses) == 0, true) ? null : [for summary in ospf.summary_addresses : {
          ip   = try(summary.ip, null)
          mask = try(summary.mask, null)
        }]

        areas = try(length(ospf.areas) == 0, true) ? null : [for area in ospf.areas : {
          area_id                                        = try(area.id, null)
          authentication_message_digest                  = try(area.authentication_message_digest, null)
          nssa                                           = try(area.nssa, null)
          nssa_default_information_originate             = try(area.nssa_default_information_originate, null)
          nssa_default_information_originate_metric      = try(area.nssa_default_information_originate_metric, null)
          nssa_default_information_originate_metric_type = try(area.nssa_default_information_originate_metric_type, null)
          nssa_no_summary                                = try(area.nssa_no_summary, null)
          nssa_no_redistribution                         = try(area.nssa_no_redistribution, null)
        }]
      } if try(ospf.vrf, null) == null || try(ospf.vrf, "") == ""
    ]
  ])
}

resource "iosxe_ospf" "ospf" {
  for_each = { for o in local.ospf_configurations_without_vrf : o.key => o }
  device   = each.value.device

  process_id                                               = each.value.process_id
  router_id                                                = each.value.router_id
  shutdown                                                 = each.value.shutdown
  priority                                                 = each.value.priority
  default_metric                                           = each.value.default_metric
  distance                                                 = each.value.distance
  domain_tag                                               = each.value.domain_tag
  fast_reroute_per_prefix_enable_prefix_priority           = each.value.fast_reroute_per_prefix_enable_prefix_priority
  log_adjacency_changes                                    = each.value.log_adjacency_changes
  log_adjacency_changes_detail                             = each.value.log_adjacency_changes_detail
  max_metric_router_lsa                                    = each.value.max_metric_router_lsa
  max_metric_router_lsa_external_lsa_metric                = each.value.max_metric_router_lsa_external_lsa_metric
  max_metric_router_lsa_include_stub                       = each.value.max_metric_router_lsa_include_stub
  max_metric_router_lsa_on_startup_time                    = each.value.max_metric_router_lsa_on_startup_time
  max_metric_router_lsa_on_startup_wait_for_bgp            = each.value.max_metric_router_lsa_on_startup_wait_for_bgp
  max_metric_router_lsa_summary_lsa_metric                 = each.value.max_metric_router_lsa_summary_lsa_metric
  mpls_ldp_autoconfig                                      = each.value.mpls_ldp_autoconfig
  mpls_ldp_sync                                            = each.value.mpls_ldp_sync
  nsf_cisco                                                = each.value.nsf_cisco
  nsf_cisco_enforce_global                                 = each.value.nsf_cisco_enforce_global
  nsf_ietf                                                 = each.value.nsf_ietf
  nsf_ietf_restart_interval                                = each.value.nsf_ietf_restart_interval
  redistribute_connected_subnets                           = each.value.redistribute_connected_subnets
  redistribute_connected_metric                            = each.value.redistribute_connected_metric
  redistribute_connected_metric_type                       = each.value.redistribute_connected_metric_type
  redistribute_connected_route_map                         = each.value.redistribute_connected_route_map
  redistribute_connected_tag                               = each.value.redistribute_connected_tag
  redistribute_static_subnets                              = each.value.redistribute_static_subnets
  redistribute_static_metric                               = each.value.redistribute_static_metric
  redistribute_static_metric_type                          = each.value.redistribute_static_metric_type
  redistribute_static_route_map                            = each.value.redistribute_static_route_map
  redistribute_static_tag                                  = each.value.redistribute_static_tag
  redistribute_ospf                                        = each.value.redistribute_ospf
  distribute_list_in_access_lists                          = each.value.distribute_list_in_access_lists
  distribute_list_out_access_lists                         = each.value.distribute_list_out_access_lists
  bfd_all_interfaces                                       = each.value.bfd_all_interfaces
  default_information_originate                            = each.value.default_information_originate
  default_information_originate_always                     = each.value.default_information_originate_always
  default_information_originate_metric                     = each.value.default_information_originate_metric
  default_information_originate_metric_type                = each.value.default_information_originate_metric_type
  default_information_originate_route_map                  = each.value.default_information_originate_route_map
  passive_interface_default                                = each.value.passive_interface_default
  auto_cost_reference_bandwidth                            = each.value.auto_cost_reference_bandwidth
  passive_interface                                        = each.value.passive_interface
  passive_interface_disable_gigabit_ethernets              = each.value.passive_interface_disable_gigabit_ethernets
  passive_interface_disable_two_gigabit_ethernets          = each.value.passive_interface_disable_two_gigabit_ethernets
  passive_interface_disable_five_gigabit_ethernets         = each.value.passive_interface_disable_five_gigabit_ethernets
  passive_interface_disable_ten_gigabit_ethernets          = each.value.passive_interface_disable_ten_gigabit_ethernets
  passive_interface_disable_twenty_five_gigabit_ethernets  = each.value.passive_interface_disable_twenty_five_gigabit_ethernets
  passive_interface_disable_forty_gigabit_ethernets        = each.value.passive_interface_disable_forty_gigabit_ethernets
  passive_interface_disable_hundred_gigabit_ethernets      = each.value.passive_interface_disable_hundred_gigabit_ethernets
  passive_interface_disable_two_hundred_gigabit_ethernets  = each.value.passive_interface_disable_two_hundred_gigabit_ethernets
  passive_interface_disable_four_hundred_gigabit_ethernets = each.value.passive_interface_disable_four_hundred_gigabit_ethernets
  passive_interface_disable_loopbacks                      = each.value.passive_interface_disable_loopbacks
  passive_interface_disable_vlans                          = each.value.passive_interface_disable_vlans
  passive_interface_disable_tunnels                        = each.value.passive_interface_disable_tunnels
  passive_interface_disable_port_channels                  = each.value.passive_interface_disable_port_channels
  passive_interface_disable_port_channel_subinterfaces     = each.value.passive_interface_disable_port_channel_subinterfaces
  neighbors                                                = each.value.neighbors
  networks                                                 = each.value.networks
  summary_addresses                                        = each.value.summary_addresses
  areas                                                    = each.value.areas

  depends_on = [iosxe_system.system]
}

resource "iosxe_ospf_vrf" "ospf_vrf" {
  for_each = { for o in local.ospf_configurations_with_vrf : o.key => o }
  device   = each.value.device

  vrf                                                      = each.value.vrf
  process_id                                               = each.value.process_id
  router_id                                                = each.value.router_id
  shutdown                                                 = each.value.shutdown
  priority                                                 = each.value.priority
  default_metric                                           = each.value.default_metric
  distance                                                 = each.value.distance
  domain_tag                                               = each.value.domain_tag
  log_adjacency_changes                                    = each.value.log_adjacency_changes
  log_adjacency_changes_detail                             = each.value.log_adjacency_changes_detail
  max_metric_router_lsa                                    = each.value.max_metric_router_lsa
  max_metric_router_lsa_external_lsa_metric                = each.value.max_metric_router_lsa_external_lsa_metric
  max_metric_router_lsa_include_stub                       = each.value.max_metric_router_lsa_include_stub
  max_metric_router_lsa_on_startup_time                    = each.value.max_metric_router_lsa_on_startup_time
  max_metric_router_lsa_on_startup_wait_for_bgp            = each.value.max_metric_router_lsa_on_startup_wait_for_bgp
  max_metric_router_lsa_summary_lsa_metric                 = each.value.max_metric_router_lsa_summary_lsa_metric
  mpls_ldp_autoconfig                                      = each.value.mpls_ldp_autoconfig
  mpls_ldp_sync                                            = each.value.mpls_ldp_sync
  nsf_cisco                                                = each.value.nsf_cisco
  nsf_cisco_enforce_global                                 = each.value.nsf_cisco_enforce_global
  nsf_ietf                                                 = each.value.nsf_ietf
  nsf_ietf_restart_interval                                = each.value.nsf_ietf_restart_interval
  redistribute_connected_subnets                           = each.value.redistribute_connected_subnets
  redistribute_connected_metric                            = each.value.redistribute_connected_metric
  redistribute_connected_metric_type                       = each.value.redistribute_connected_metric_type
  redistribute_connected_route_map                         = each.value.redistribute_connected_route_map
  redistribute_connected_tag                               = each.value.redistribute_connected_tag
  redistribute_static_subnets                              = each.value.redistribute_static_subnets
  redistribute_static_metric                               = each.value.redistribute_static_metric
  redistribute_static_metric_type                          = each.value.redistribute_static_metric_type
  redistribute_static_route_map                            = each.value.redistribute_static_route_map
  redistribute_static_tag                                  = each.value.redistribute_static_tag
  redistribute_ospf                                        = each.value.redistribute_ospf
  distribute_list_in_access_lists                          = each.value.distribute_list_in_access_lists
  distribute_list_out_access_lists                         = each.value.distribute_list_out_access_lists
  bfd_all_interfaces                                       = each.value.bfd_all_interfaces
  default_information_originate                            = each.value.default_information_originate
  default_information_originate_always                     = each.value.default_information_originate_always
  default_information_originate_metric                     = each.value.default_information_originate_metric
  default_information_originate_metric_type                = each.value.default_information_originate_metric_type
  default_information_originate_route_map                  = each.value.default_information_originate_route_map
  passive_interface_default                                = each.value.passive_interface_default
  auto_cost_reference_bandwidth                            = each.value.auto_cost_reference_bandwidth
  passive_interface                                        = each.value.passive_interface
  passive_interface_disable_gigabit_ethernets              = each.value.passive_interface_disable_gigabit_ethernets
  passive_interface_disable_two_gigabit_ethernets          = each.value.passive_interface_disable_two_gigabit_ethernets
  passive_interface_disable_five_gigabit_ethernets         = each.value.passive_interface_disable_five_gigabit_ethernets
  passive_interface_disable_ten_gigabit_ethernets          = each.value.passive_interface_disable_ten_gigabit_ethernets
  passive_interface_disable_twenty_five_gigabit_ethernets  = each.value.passive_interface_disable_twenty_five_gigabit_ethernets
  passive_interface_disable_forty_gigabit_ethernets        = each.value.passive_interface_disable_forty_gigabit_ethernets
  passive_interface_disable_hundred_gigabit_ethernets      = each.value.passive_interface_disable_hundred_gigabit_ethernets
  passive_interface_disable_two_hundred_gigabit_ethernets  = each.value.passive_interface_disable_two_hundred_gigabit_ethernets
  passive_interface_disable_four_hundred_gigabit_ethernets = each.value.passive_interface_disable_four_hundred_gigabit_ethernets
  passive_interface_disable_loopbacks                      = each.value.passive_interface_disable_loopbacks
  passive_interface_disable_vlans                          = each.value.passive_interface_disable_vlans
  passive_interface_disable_tunnels                        = each.value.passive_interface_disable_tunnels
  passive_interface_disable_port_channels                  = each.value.passive_interface_disable_port_channels
  passive_interface_disable_port_channel_subinterfaces     = each.value.passive_interface_disable_port_channel_subinterfaces
  neighbor                                                 = each.value.neighbor
  network                                                  = each.value.network
  summary_address                                          = each.value.summary_address
  areas                                                    = each.value.areas

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_system.system
  ]
}
