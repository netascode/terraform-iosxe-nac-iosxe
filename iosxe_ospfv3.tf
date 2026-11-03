locals {
  ospfv3_configurations = flatten([
    for device in local.devices : [
      for ospfv3 in try(local.device_config[device.name].routing.ospfv3_processes, []) : {
        key    = format("%s/%s", device.name, ospfv3.id)
        device = device.name

        process_id                    = try(ospfv3.id, null)
        router_id                     = try(ospfv3.router_id, null)
        bfd_all_interfaces            = try(ospfv3.bfd_all_interfaces, null)
        auto_cost_reference_bandwidth = try(ospfv3.auto_cost_reference_bandwidth, null)
        shutdown                      = try(ospfv3.shutdown, null)
        log_adjacency_changes         = try(ospfv3.log_adjacency_changes, null)
        log_adjacency_changes_detail  = try(ospfv3.log_adjacency_changes_detail, null)
      }
    ]
  ])

  ospfv3_af_ipv4_vrf_configurations = flatten([
    for device in local.devices : [
      for ospfv3 in try(local.device_config[device.name].routing.ospfv3_processes, []) : [
        for af in try(ospfv3.address_family_ipv4_vrfs, []) : {
          key    = format("%s/%s/%s", device.name, ospfv3.id, try(af.vrf, "default"))
          device = device.name

          process_id                                           = try(ospfv3.id, null)
          vrf                                                  = try(af.vrf, null)
          unicast                                              = try(af.unicast, null)
          capability_vrf                                       = try(af.capability_vrf, null)
          bfd_all_interfaces                                   = try(af.bfd_all_interfaces, null)
          default_information_originate                        = try(af.default_information_originate, null)
          default_information_originate_always                 = try(af.default_information_originate_always, null)
          default_information_originate_metric                 = try(af.default_information_originate_metric, null)
          default_information_originate_metric_type            = try(af.default_information_originate_metric_type, null)
          default_metric                                       = try(af.default_metric, null)
          distance                                             = try(af.distance, null)
          log_adjacency_changes                                = try(af.log_adjacency_changes, null)
          log_adjacency_changes_detail                         = try(af.log_adjacency_changes_detail, null)
          router_id                                            = try(af.router_id, null)
          shutdown                                             = try(af.shutdown, null)
          auto_cost_reference_bandwidth                        = try(af.auto_cost_reference_bandwidth, null)
          timers_lsa_arrival                                   = try(af.timers_lsa_arrival, null)
          timers_pacing_lsa_group                              = try(af.timers_pacing_lsa_group, null)
          timers_throttle_lsa_all_delay                        = try(af.timers_throttle_lsa_all_delay, null)
          timers_throttle_lsa_all_min_delay                    = try(af.timers_throttle_lsa_all_min_delay, null)
          timers_throttle_lsa_all_max_delay                    = try(af.timers_throttle_lsa_all_max_delay, null)
          timers_throttle_spf_delay                            = try(af.timers_throttle_spf_delay, null)
          timers_throttle_spf_min_delay                        = try(af.timers_throttle_spf_min_delay, null)
          timers_throttle_spf_max_delay                        = try(af.timers_throttle_spf_max_delay, null)
          max_metric_router_lsa_config                         = try(af.max_metric_router_lsa_config, null)
          max_metric_router_lsa_config_stub_prefix_lsa         = try(af.max_metric_router_lsa_config_stub_prefix_lsa, null)
          max_metric_router_lsa_config_inter_area_lsas_metric  = try(af.max_metric_router_lsa_config_inter_area_lsas_metric, null)
          max_metric_router_lsa_config_external_lsa_metric     = try(af.max_metric_router_lsa_config_external_lsa_metric, null)
          max_metric_router_config_lsa_on_startup_time         = try(af.max_metric_router_lsa_on_startup_time, null)
          max_metric_router_config_lsa_on_startup_wait_for_bgp = try(af.max_metric_router_lsa_on_startup_wait_for_bgp, null)
          redistribute_static                                  = try(af.redistribute_static, null)
          redistribute_connected                               = try(af.redistribute_connected, null)
          passive_interface_default                            = try(af.passive_interface_default, null)
          passive_interface                                    = try(af.passive_interface, null)
          summary_prefix = try(length(af.summary_prefixes) == 0, true) ? null : [for sp in af.summary_prefixes : {
            prefix = try(sp.prefix, null)
          }]
          areas = try(length(af.areas) == 0, true) ? null : [for area in af.areas : {
            area_id                                        = try(tostring(area.id), null)
            nssa                                           = try(area.nssa, null)
            nssa_default_information_originate             = try(area.nssa_default_information_originate, null)
            nssa_default_information_originate_metric      = try(area.nssa_default_information_originate_metric, null)
            nssa_default_information_originate_metric_type = try(area.nssa_default_information_originate_metric_type, null)
            nssa_no_summary                                = try(area.nssa_no_summary, null)
            nssa_no_redistribution                         = try(area.nssa_no_redistribution, null)
          }]
        }
      ]
    ]
  ])

  ospfv3_af_ipv6_vrf_configurations = flatten([
    for device in local.devices : [
      for ospfv3 in try(local.device_config[device.name].routing.ospfv3_processes, []) : [
        for af in try(ospfv3.address_family_ipv6_vrfs, []) : {
          key    = format("%s/%s/%s", device.name, ospfv3.id, try(af.vrf, "default"))
          device = device.name

          process_id                                           = try(ospfv3.id, null)
          vrf                                                  = try(af.vrf, null)
          unicast                                              = try(af.unicast, null)
          capability_vrf                                       = try(af.capability_vrf, null)
          bfd_all_interfaces                                   = try(af.bfd_all_interfaces, null)
          default_information_originate                        = try(af.default_information_originate, null)
          default_information_originate_always                 = try(af.default_information_originate_always, null)
          default_information_originate_metric                 = try(af.default_information_originate_metric, null)
          default_information_originate_metric_type            = try(af.default_information_originate_metric_type, null)
          default_metric                                       = try(af.default_metric, null)
          distance                                             = try(af.distance, null)
          log_adjacency_changes                                = try(af.log_adjacency_changes, null)
          log_adjacency_changes_detail                         = try(af.log_adjacency_changes_detail, null)
          router_id                                            = try(af.router_id, null)
          shutdown                                             = try(af.shutdown, null)
          auto_cost_reference_bandwidth                        = try(af.auto_cost_reference_bandwidth, null)
          timers_lsa_arrival                                   = try(af.timers_lsa_arrival, null)
          timers_pacing_lsa_group                              = try(af.timers_pacing_lsa_group, null)
          timers_throttle_lsa_all_delay                        = try(af.timers_throttle_lsa_all_delay, null)
          timers_throttle_lsa_all_min_delay                    = try(af.timers_throttle_lsa_all_min_delay, null)
          timers_throttle_lsa_all_max_delay                    = try(af.timers_throttle_lsa_all_max_delay, null)
          timers_throttle_spf_delay                            = try(af.timers_throttle_spf_delay, null)
          timers_throttle_spf_min_delay                        = try(af.timers_throttle_spf_min_delay, null)
          timers_throttle_spf_max_delay                        = try(af.timers_throttle_spf_max_delay, null)
          max_metric_router_lsa_config                         = try(af.max_metric_router_lsa_config, null)
          max_metric_router_lsa_config_stub_prefix_lsa         = try(af.max_metric_router_lsa_config_stub_prefix_lsa, null)
          max_metric_router_lsa_config_inter_area_lsas_metric  = try(af.max_metric_router_lsa_config_inter_area_lsas_metric, null)
          max_metric_router_lsa_config_external_lsa_metric     = try(af.max_metric_router_lsa_config_external_lsa_metric, null)
          max_metric_router_config_lsa_on_startup_time         = try(af.max_metric_router_lsa_on_startup_time, null)
          max_metric_router_config_lsa_on_startup_wait_for_bgp = try(af.max_metric_router_lsa_on_startup_wait_for_bgp, null)
          redistribute_static                                  = try(af.redistribute_static, null)
          redistribute_connected                               = try(af.redistribute_connected, null)
          passive_interface_default                            = try(af.passive_interface_default, null)
          passive_interface                                    = try(af.passive_interface, null)
          summary_prefix = try(length(af.summary_prefixes) == 0, true) ? null : [for sp in af.summary_prefixes : {
            prefix = try(sp.prefix, null)
          }]
          areas = try(length(af.areas) == 0, true) ? null : [for area in af.areas : {
            area_id                                        = try(tostring(area.id), null)
            nssa                                           = try(area.nssa, null)
            nssa_default_information_originate             = try(area.nssa_default_information_originate, null)
            nssa_default_information_originate_metric      = try(area.nssa_default_information_originate_metric, null)
            nssa_default_information_originate_metric_type = try(area.nssa_default_information_originate_metric_type, null)
            nssa_no_summary                                = try(area.nssa_no_summary, null)
            nssa_no_redistribution                         = try(area.nssa_no_redistribution, null)
          }]
        }
      ]
    ]
  ])
}

resource "iosxe_ospfv3" "ospfv3" {
  for_each = { for o in local.ospfv3_configurations : o.key => o }
  device   = each.value.device

  process_id                    = each.value.process_id
  router_id                     = each.value.router_id
  bfd_all_interfaces            = each.value.bfd_all_interfaces
  auto_cost_reference_bandwidth = each.value.auto_cost_reference_bandwidth
  shutdown                      = each.value.shutdown
  log_adjacency_changes         = each.value.log_adjacency_changes
  log_adjacency_changes_detail  = each.value.log_adjacency_changes_detail

  depends_on = [iosxe_system.system]
}

resource "iosxe_ospfv3_address_family_ipv4_vrf" "ospfv3_af_ipv4_vrf" {
  for_each = { for o in local.ospfv3_af_ipv4_vrf_configurations : o.key => o }
  device   = each.value.device

  process_id                                           = each.value.process_id
  vrf                                                  = each.value.vrf
  unicast                                              = each.value.unicast
  capability_vrf                                       = each.value.capability_vrf
  bfd_all_interfaces                                   = each.value.bfd_all_interfaces
  default_information_originate                        = each.value.default_information_originate
  default_information_originate_always                 = each.value.default_information_originate_always
  default_information_originate_metric                 = each.value.default_information_originate_metric
  default_information_originate_metric_type            = each.value.default_information_originate_metric_type
  default_metric                                       = each.value.default_metric
  distance                                             = each.value.distance
  log_adjacency_changes                                = each.value.log_adjacency_changes
  log_adjacency_changes_detail                         = each.value.log_adjacency_changes_detail
  router_id                                            = each.value.router_id
  shutdown                                             = each.value.shutdown
  auto_cost_reference_bandwidth                        = each.value.auto_cost_reference_bandwidth
  timers_lsa_arrival                                   = each.value.timers_lsa_arrival
  timers_pacing_lsa_group                              = each.value.timers_pacing_lsa_group
  timers_throttle_lsa_all_delay                        = each.value.timers_throttle_lsa_all_delay
  timers_throttle_lsa_all_min_delay                    = each.value.timers_throttle_lsa_all_min_delay
  timers_throttle_lsa_all_max_delay                    = each.value.timers_throttle_lsa_all_max_delay
  timers_throttle_spf_delay                            = each.value.timers_throttle_spf_delay
  timers_throttle_spf_min_delay                        = each.value.timers_throttle_spf_min_delay
  timers_throttle_spf_max_delay                        = each.value.timers_throttle_spf_max_delay
  max_metric_router_lsa_config                         = each.value.max_metric_router_lsa_config
  max_metric_router_lsa_config_stub_prefix_lsa         = each.value.max_metric_router_lsa_config_stub_prefix_lsa
  max_metric_router_lsa_config_inter_area_lsas_metric  = each.value.max_metric_router_lsa_config_inter_area_lsas_metric
  max_metric_router_lsa_config_external_lsa_metric     = each.value.max_metric_router_lsa_config_external_lsa_metric
  max_metric_router_config_lsa_on_startup_time         = each.value.max_metric_router_config_lsa_on_startup_time
  max_metric_router_config_lsa_on_startup_wait_for_bgp = each.value.max_metric_router_config_lsa_on_startup_wait_for_bgp
  redistribute_static                                  = each.value.redistribute_static
  redistribute_connected                               = each.value.redistribute_connected
  passive_interface_default                            = each.value.passive_interface_default
  passive_interface                                    = each.value.passive_interface
  summary_prefix                                       = each.value.summary_prefix
  areas                                                = each.value.areas

  depends_on = [
    iosxe_ospfv3.ospfv3,
    iosxe_vrf.vrf,
    iosxe_system.system
  ]
}

resource "iosxe_ospfv3_address_family_ipv6_vrf" "ospfv3_af_ipv6_vrf" {
  for_each = { for o in local.ospfv3_af_ipv6_vrf_configurations : o.key => o }
  device   = each.value.device

  process_id                                           = each.value.process_id
  vrf                                                  = each.value.vrf
  unicast                                              = each.value.unicast
  capability_vrf                                       = each.value.capability_vrf
  bfd_all_interfaces                                   = each.value.bfd_all_interfaces
  default_information_originate                        = each.value.default_information_originate
  default_information_originate_always                 = each.value.default_information_originate_always
  default_information_originate_metric                 = each.value.default_information_originate_metric
  default_information_originate_metric_type            = each.value.default_information_originate_metric_type
  default_metric                                       = each.value.default_metric
  distance                                             = each.value.distance
  log_adjacency_changes                                = each.value.log_adjacency_changes
  log_adjacency_changes_detail                         = each.value.log_adjacency_changes_detail
  router_id                                            = each.value.router_id
  shutdown                                             = each.value.shutdown
  auto_cost_reference_bandwidth                        = each.value.auto_cost_reference_bandwidth
  timers_lsa_arrival                                   = each.value.timers_lsa_arrival
  timers_pacing_lsa_group                              = each.value.timers_pacing_lsa_group
  timers_throttle_lsa_all_delay                        = each.value.timers_throttle_lsa_all_delay
  timers_throttle_lsa_all_min_delay                    = each.value.timers_throttle_lsa_all_min_delay
  timers_throttle_lsa_all_max_delay                    = each.value.timers_throttle_lsa_all_max_delay
  timers_throttle_spf_delay                            = each.value.timers_throttle_spf_delay
  timers_throttle_spf_min_delay                        = each.value.timers_throttle_spf_min_delay
  timers_throttle_spf_max_delay                        = each.value.timers_throttle_spf_max_delay
  max_metric_router_lsa_config                         = each.value.max_metric_router_lsa_config
  max_metric_router_lsa_config_stub_prefix_lsa         = each.value.max_metric_router_lsa_config_stub_prefix_lsa
  max_metric_router_lsa_config_inter_area_lsas_metric  = each.value.max_metric_router_lsa_config_inter_area_lsas_metric
  max_metric_router_lsa_config_external_lsa_metric     = each.value.max_metric_router_lsa_config_external_lsa_metric
  max_metric_router_config_lsa_on_startup_time         = each.value.max_metric_router_config_lsa_on_startup_time
  max_metric_router_config_lsa_on_startup_wait_for_bgp = each.value.max_metric_router_config_lsa_on_startup_wait_for_bgp
  redistribute_static                                  = each.value.redistribute_static
  redistribute_connected                               = each.value.redistribute_connected
  passive_interface_default                            = each.value.passive_interface_default
  passive_interface                                    = each.value.passive_interface
  summary_prefix                                       = each.value.summary_prefix
  areas                                                = each.value.areas

  depends_on = [
    iosxe_ospfv3.ospfv3,
    iosxe_vrf.vrf,
    iosxe_system.system
  ]
}
