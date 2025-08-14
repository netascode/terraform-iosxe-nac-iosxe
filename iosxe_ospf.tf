locals {
  ospf_configurations_with_vrf = flatten([
    for device in local.devices : [
      for ospf in try(local.device_config[device.name].routing.ospf_processes, []) : {
        key    = format("%s/%s", device.name, ospf.id)
        device = device.name
        vrf    = try(ospf.vrf, local.defaults.iosxe.configuration.routing.ospf_processes.vrf, null)

        process_id                           = try(ospf.id, local.defaults.iosxe.configuration.routing.ospf_processes.id, null)
        bfd_all_interfaces                   = try(ospf.bfd_all_interfaces, local.defaults.iosxe.configuration.routing.ospf_processes.bfd_all_interfaces, null)
        default_information_originate        = try(ospf.default_information_originate, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate, null)
        default_information_originate_always = try(ospf.default_information_originate_always, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate_always, null)
        default_metric                       = try(ospf.default_metric, local.defaults.iosxe.configuration.routing.ospf_processes.default_metric, null)
        distance                             = try(ospf.distance, local.defaults.iosxe.configuration.routing.ospf_processes.distance, null)
        domain_tag                           = try(ospf.domain_tag, local.defaults.iosxe.configuration.routing.ospf_processes.domain_tag, null)
        mpls_ldp_autoconfig                  = try(ospf.mpls_ldp_autoconfig, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_autoconfig, null)
        mpls_ldp_sync                        = try(ospf.mpls_ldp_sync, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_sync, null)
        priority                             = try(ospf.priority, local.defaults.iosxe.configuration.routing.ospf_processes.priority, null)
        router_id                            = try(ospf.router_id, local.defaults.iosxe.configuration.routing.ospf_processes.router_id, null)
        shutdown                             = try(ospf.shutdown, local.defaults.iosxe.configuration.routing.ospf_processes.shutdown, null)
        passive_interface_default            = try(ospf.passive_interface_default, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interface_default, null)
        auto_cost_reference_bandwidth        = try(ospf.auto_cost_reference_bandwidth, local.defaults.iosxe.configuration.routing.ospf_processes.auto_cost_reference_bandwidth, null)
        # passive_interface                    = tolist([for p in try(ospf.passive_interface, try(local.defaults.iosxe.configuration.routing.ospf_processes.passive_interface, [])) : tostring(p)])

        neighbor = [for neighbor in try(ospf.neighbors, []) : {
          ip       = try(neighbor.ip, null)
          priority = try(neighbor.priority, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.priority, null)
          cost     = try(neighbor.cost, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.cost, null)
        }]

        network = [for network in try(ospf.networks, []) : {
          ip       = try(network.ip, null)
          wildcard = try(network.wildcard, local.defaults.iosxe.configuration.routing.ospf_processes.networks.wildcard, null)
          area     = try(network.area, local.defaults.iosxe.configuration.routing.ospf_processes.networks.area, null)
        }]

        summary_address = [for summary in try(ospf.summary_addresses, []) : {
          ip   = try(summary.ip, null)
          mask = try(summary.mask, local.defaults.iosxe.configuration.routing.ospf_processes.summary_addresses.mask, null)
        }]

        areas = [for area in try(ospf.areas, []) : {
          area_id                                        = try(area.area, null)
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

        process_id                           = try(ospf.id, local.defaults.iosxe.configuration.routing.ospf_processes.id, null)
        bfd_all_interfaces                   = try(ospf.bfd_all_interfaces, local.defaults.iosxe.configuration.routing.ospf_processes.bfd_all_interfaces, null)
        default_information_originate        = try(ospf.default_information_originate, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate, null)
        default_information_originate_always = try(ospf.default_information_originate_always, local.defaults.iosxe.configuration.routing.ospf_processes.default_information_originate_always, null)
        default_metric                       = try(ospf.default_metric, local.defaults.iosxe.configuration.routing.ospf_processes.default_metric, null)
        distance                             = try(ospf.distance, local.defaults.iosxe.configuration.routing.ospf_processes.distance, null)
        domain_tag                           = try(ospf.domain_tag, local.defaults.iosxe.configuration.routing.ospf_processes.domain_tag, null)
        mpls_ldp_autoconfig                  = try(ospf.mpls_ldp_autoconfig, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_autoconfig, null)
        mpls_ldp_sync                        = try(ospf.mpls_ldp_sync, local.defaults.iosxe.configuration.routing.ospf_processes.mpls_ldp_sync, null)
        priority                             = try(ospf.priority, local.defaults.iosxe.configuration.routing.ospf_processes.priority, null)
        router_id                            = try(ospf.router_id, local.defaults.iosxe.configuration.routing.ospf_processes.router_id, null)
        shutdown                             = try(ospf.shutdown, local.defaults.iosxe.configuration.routing.ospf_processes.shutdown, null)
        passive_interface_default            = try(ospf.passive_interface_default, local.defaults.iosxe.configuration.routing.ospf_processes.passive_interface_default, null)
        auto_cost_reference_bandwidth        = try(ospf.auto_cost_reference_bandwidth, local.defaults.iosxe.configuration.routing.ospf_processes.auto_cost_reference_bandwidth, null)
        # passive_interface                    = tolist([for p in try(ospf.passive_interface, try(local.defaults.iosxe.configuration.routing.ospf_processes.passive_interface, [])) : tostring(p)])

        neighbors = [for neighbor in try(ospf.neighbors, []) : {
          ip       = try(neighbor.ip, null)
          priority = try(neighbor.priority, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.priority, null)
          cost     = try(neighbor.cost, local.defaults.iosxe.configuration.routing.ospf_processes.neighbors.cost, null)
        }]

        networks = [for network in try(ospf.networks, []) : {
          ip       = try(network.ip, null)
          wildcard = try(network.wildcard, local.defaults.iosxe.configuration.routing.ospf_processes.networks.wildcard, null)
          area     = try(network.area, local.defaults.iosxe.configuration.routing.ospf_processes.networks.area, null)
        }]

        summary_addresses = [for summary in try(ospf.summary_addresses, []) : {
          ip   = try(summary.ip, null)
          mask = try(summary.mask, local.defaults.iosxe.configuration.routing.ospf_processes.summary_addresses.mask, null)
        }]

        areas = [for area in try(ospf.areas, []) : {
          area_id                                        = try(area.area, null)
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


  device                               = each.value.device
  process_id                           = each.value.process_id
  router_id                            = each.value.router_id
  shutdown                             = each.value.shutdown
  priority                             = each.value.priority
  default_metric                       = each.value.default_metric
  distance                             = each.value.distance
  domain_tag                           = each.value.domain_tag
  mpls_ldp_autoconfig                  = each.value.mpls_ldp_autoconfig
  mpls_ldp_sync                        = each.value.mpls_ldp_sync
  bfd_all_interfaces                   = each.value.bfd_all_interfaces
  default_information_originate        = each.value.default_information_originate
  default_information_originate_always = each.value.default_information_originate_always
  passive_interface_default            = each.value.passive_interface_default
  auto_cost_reference_bandwidth        = each.value.auto_cost_reference_bandwidth
  # passive_interface                    = each.value.passive_interface

  neighbors         = each.value.neighbors
  networks          = each.value.networks
  summary_addresses = each.value.summary_addresses
  areas             = each.value.areas
}

resource "iosxe_ospf_vrf" "ospf" {
  for_each = { for o in local.ospf_configurations_with_vrf : o.key => o }

  depends_on = [iosxe_vrf.vrfs]

  device                               = each.value.device
  vrf                                  = each.value.vrf
  process_id                           = each.value.process_id
  router_id                            = each.value.router_id
  shutdown                             = each.value.shutdown
  priority                             = each.value.priority
  default_metric                       = each.value.default_metric
  distance                             = each.value.distance
  domain_tag                           = each.value.domain_tag
  mpls_ldp_autoconfig                  = each.value.mpls_ldp_autoconfig
  mpls_ldp_sync                        = each.value.mpls_ldp_sync
  bfd_all_interfaces                   = each.value.bfd_all_interfaces
  default_information_originate        = each.value.default_information_originate
  default_information_originate_always = each.value.default_information_originate_always
  passive_interface_default            = each.value.passive_interface_default
  auto_cost_reference_bandwidth        = each.value.auto_cost_reference_bandwidth
  # passive_interface                    = each.value.passive_interface

  neighbor        = each.value.neighbor
  network         = each.value.network
  summary_address = each.value.summary_address
  areas           = each.value.areas
}
