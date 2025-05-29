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

output "ospf_configurations_with_vrf" {
  value = local.ospf_configurations_with_vrf
}

output "ospf_configurations_without_vrf" {
  value = local.ospf_configurations_without_vrf
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

  neighbor        = each.value.neighbor
  network         = each.value.network
  summary_address = each.value.summary_address
  areas           = each.value.areas
}

locals {
  iosxe_interfaces = flatten([
    for device in local.devices : concat(
      [for ethernet in try(local.device_config[device.name].interfaces.ethernets, []) : {
        type   = ethernet.type
        name   = ethernet.name
        ospf   = try(ethernet.ospf, null)
        device = device.name
        key    = format("%s/%s", device.name, ethernet.name)
      }],
      [for loopback in try(local.device_config[device.name].interfaces.loopbacks, []) : {
        type   = "Loopback"
        name   = tostring(loopback.id)
        ospf   = try(loopback.ospf, null)
        device = device.name
        key    = format("%s/Loopback%s", device.name, loopback.id)
      }],
      [for vlan in try(local.device_config[device.name].interfaces.vlans, []) : {
        type   = "Vlan"
        name   = tostring(vlan.id)
        ospf   = try(vlan.ospf, null)
        device = device.name
        key    = format("%s/Vlan%s", device.name, vlan.id)
      }],
      [for pc in try(local.device_config[device.name].interfaces.port_channels, []) :
        concat(
          [{
            type   = "Port-channel"
            name   = tostring(pc.name)
            ospf   = try(pc.ospf, null)
            device = device.name
            key    = format("%s/Port-channel%s", device.name, pc.name)
          }],
          [for subif in try(pc.subinterfaces, []) : {
            type   = "Port-channel"
            name   = "${pc.name}.${subif.name}"
            ospf   = try(subif.ospf, null)
            device = device.name
            key    = format("%s/Port-channel%s.%s", device.name, pc.name, subif.name)
          }]
        )
      ]
    )
  ])

  iosxe_interface_ospf_attributes = {
    for intf in local.iosxe_interfaces : intf.key => {
      type                             = intf.type
      name                             = intf.name
      cost                             = try(intf.ospf.cost, local.defaults.iosxe.configuration.interfaces.ospf.cost, null)
      dead_interval                    = try(intf.ospf.dead_interval, local.defaults.iosxe.configuration.interfaces.ospf.dead_interval, null)
      hello_interval                   = try(intf.ospf.hello_interval, local.defaults.iosxe.configuration.interfaces.ospf.hello_interval, null)
      mtu_ignore                       = try(intf.ospf.mtu_ignore, local.defaults.iosxe.configuration.interfaces.ospf.mtu_ignore, null)
      network_type_broadcast           = try(intf.ospf.network_type_broadcast, local.defaults.iosxe.configuration.interfaces.ospf.network_type_broadcast, null)
      network_type_non_broadcast       = try(intf.ospf.network_type_non_broadcast, local.defaults.iosxe.configuration.interfaces.ospf.network_type_non_broadcast, null)
      network_type_point_to_multipoint = try(intf.ospf.network_type_point_to_multipoint, local.defaults.iosxe.configuration.interfaces.ospf.network_type_point_to_multipoint, null)
      network_type_point_to_point      = try(intf.ospf.network_type_point_to_point, local.defaults.iosxe.configuration.interfaces.ospf.network_type_point_to_point, null)
      priority                         = try(intf.ospf.priority, local.defaults.iosxe.configuration.interfaces.ospf.priority, null)
      ttl_security_hops                = try(intf.ospf.ttl_security_hops, local.defaults.iosxe.configuration.interfaces.ospf.ttl_security_hops, null)

      process_ids = flatten([
        for pid in try(intf.ospf.process_ids, local.defaults.iosxe.configuration.interfaces.ospf.process_ids, []) : [
          {
            id = try(pid.id, null)
            areas = [
              for a in try(pid.areas, []) : {
                area_id = a
              }
            ]
          }
        ]
      ])

      message_digest_keys = flatten([
        for key in try(intf.ospf.message_digest_keys, local.defaults.iosxe.configuration.interfaces.ospf.message_digest_keys, []) : [
          {
            id            = try(key.id, null)
            md5_auth_key  = try(key.md5_auth_key, null)
            md5_auth_type = try(key.md5_auth_type, null)
          }
        ]
      ])
    } if intf.ospf != null || length(try(local.defaults.iosxe.configuration.interfaces.ospf, {})) > 0
  }
}

resource "null_resource" "stub_interface_config" {
  provisioner "local-exec" {
    command = "echo 'Simulating interface configuration'"
  }
}

resource "iosxe_interface_ospf" "interface" {
  for_each = local.iosxe_interface_ospf_attributes

  depends_on = [null_resource.stub_interface_config]

  type                             = each.value.type
  name                             = each.value.name
  cost                             = each.value.cost
  dead_interval                    = each.value.dead_interval
  hello_interval                   = each.value.hello_interval
  mtu_ignore                       = each.value.mtu_ignore
  network_type_broadcast           = each.value.network_type_broadcast
  network_type_non_broadcast       = each.value.network_type_non_broadcast
  network_type_point_to_multipoint = each.value.network_type_point_to_multipoint
  network_type_point_to_point      = each.value.network_type_point_to_point
  priority                         = each.value.priority
  ttl_security_hops                = each.value.ttl_security_hops
  process_ids                      = each.value.process_ids
  message_digest_keys              = each.value.message_digest_keys
}
