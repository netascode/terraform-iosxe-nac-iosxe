resource "iosxe_evpn" "evpn" {
  for_each                  = { for device in local.devices : device.name => device if try(local.device_config[device.name].evpn, null) != null || try(local.defaults.iosxe.configuration.evpn, null) != null }
  device                    = each.value.name
  replication_type_ingress  = try(local.device_config[each.value.name].evpn.replication_type == "ingress", local.defaults.iosxe.configuration.evpn.replication_type == "ingress", null)
  replication_type_static   = try(local.device_config[each.value.name].evpn.replication_type == "static", local.defaults.iosxe.configuration.evpn.replication_type == "static", null)
  replication_type_p2mp     = try(local.device_config[each.value.name].evpn.replication_type == "p2mp", local.defaults.iosxe.configuration.evpn.replication_type == "p2mp", null)
  replication_type_mp2mp    = try(local.device_config[each.value.name].evpn.replication_type == "mp2mp", local.defaults.iosxe.configuration.evpn.replication_type == "mp2mp", null)
  mac_duplication_limit     = try(local.device_config[each.value.name].evpn.mac_duplication_limit, local.defaults.iosxe.configuration.evpn.mac_duplication_limit, null)
  mac_duplication_time      = try(local.device_config[each.value.name].evpn.mac_duplication_time, local.defaults.iosxe.configuration.evpn.mac_duplication_time, null)
  ip_duplication_limit      = try(local.device_config[each.value.name].evpn.ip_duplication_limit, local.defaults.iosxe.configuration.evpn.ip_duplication_limit, null)
  ip_duplication_time       = try(local.device_config[each.value.name].evpn.ip_duplication_time, local.defaults.iosxe.configuration.evpn.ip_duplication_time, null)
  router_id_loopback        = try(local.device_config[each.value.name].evpn.router_id_interface_type, local.defaults.iosxe.configuration.evpn.router_id_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].evpn.router_id_interface_id, local.defaults.iosxe.configuration.evpn.router_id_interface_id, null) : null
  default_gateway_advertise = try(local.device_config[each.value.name].evpn.default_gateway_advertise, local.defaults.iosxe.configuration.evpn.default_gateway_advertise, null)
  logging_peer_state        = try(local.device_config[each.value.name].evpn.logging_peer_state, local.defaults.iosxe.configuration.evpn.logging_peer_state, null)
  route_target_auto_vni     = try(local.device_config[each.value.name].evpn.route_target_auto_vni, local.defaults.iosxe.configuration.evpn.route_target_auto_vni, null)
  anycast_gateway_mac_auto  = try(local.device_config[each.value.name].evpn.anycast_gateway_mac_auto, local.defaults.iosxe.configuration.evpn.anycast_gateway_mac_auto, null)
  multicast_advertise       = try(local.device_config[each.value.name].evpn.multicast_advertise, local.defaults.iosxe.configuration.evpn.multicast_advertise, null)

  depends_on = [
    iosxe_interface_loopback.loopback
  ]
}


locals {
  evpn_instances = flatten([
    for device in local.devices : [
      for instance in try(local.device_config[device.name].evpn.instances, []) : {
        key    = format("%s/%s", device.name, instance.number)
        device = device.name

        evpn_instance_num                    = try(instance.number, local.defaults.iosxe.configuration.evpn.instances.number, null)
        vlan_based_replication_type_ingress  = try(instance.vlan_based.replication_type == "ingress", local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type == "ingress", null)
        vlan_based_replication_type_static   = try(instance.vlan_based.replication_type == "static", local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type == "static", null)
        vlan_based_replication_type_p2mp     = try(instance.vlan_based.replication_type == "p2mp", local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type == "p2mp", null)
        vlan_based_replication_type_mp2mp    = try(instance.vlan_based.replication_type == "mp2mp", local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type == "mp2mp", null)
        vlan_based_encapsulation             = try(instance.vlan_based.encapsulation, local.defaults.iosxe.configuration.evpn.instances.vlan_based.encapsulation, null)
        vlan_based_auto_route_target         = try(instance.vlan_based.auto_route_target, local.defaults.iosxe.configuration.evpn.instances.vlan_based.auto_route_target, null)
        vlan_based_rd                        = try(instance.vlan_based.rd, local.defaults.iosxe.configuration.evpn.instances.vlan_based.rd, null)
        vlan_based_ip_local_learning_disable = try(instance.vlan_based.ip_local_learning_disable, local.defaults.iosxe.configuration.evpn.instances.vlan_based.ip_local_learning_disable, null)
        vlan_based_ip_local_learning_enable  = try(instance.vlan_based.ip_local_learning_enable, local.defaults.iosxe.configuration.evpn.instances.vlan_based.ip_local_learning_enable, null)
        vlan_based_default_gateway_advertise = try(instance.vlan_based.default_gateway_advertise == true ? "enable" : "disable", local.defaults.iosxe.configuration.evpn.instances.vlan_based.default_gateway_advertise == true ? "enable" : "disable", null)
        vlan_based_re_originate_route_type5  = try(instance.vlan_based.re_originate_route_type5, local.defaults.iosxe.configuration.evpn.instances.vlan_based.re_originate_route_type5, null)
        vlan_based_multicast_advertise       = try(instance.vlan_based.multicast_advertise, local.defaults.iosxe.configuration.evpn.instances.vlan_based.multicast_advertise, null)
        vlan_based_route_target_imports = try(length(instance.vlan_based.route_target_imports) == 0, true) ? null : [for rt in instance.vlan_based.route_target_imports : {
          route_target = try(rt, local.defaults.iosxe.configuration.evpn.instances.vlan_based.route_target_imports, null)
        }]
        vlan_based_route_target_exports = try(length(instance.vlan_based.route_target_exports) == 0, true) ? null : [for rt in instance.vlan_based.route_target_exports : {
          route_target = try(rt, local.defaults.iosxe.configuration.evpn.instances.vlan_based.route_target_exports, null)
        }]
    }]
  ])
}

resource "iosxe_evpn_instance" "evpn_instance" {
  for_each = { for e in local.evpn_instances : e.key => e }
  device   = each.value.device

  evpn_instance_num                    = each.value.evpn_instance_num
  vlan_based_replication_type_ingress  = each.value.vlan_based_replication_type_ingress
  vlan_based_replication_type_static   = each.value.vlan_based_replication_type_static
  vlan_based_replication_type_p2mp     = each.value.vlan_based_replication_type_p2mp
  vlan_based_replication_type_mp2mp    = each.value.vlan_based_replication_type_mp2mp
  vlan_based_encapsulation             = each.value.vlan_based_encapsulation
  vlan_based_auto_route_target         = each.value.vlan_based_auto_route_target
  vlan_based_rd                        = each.value.vlan_based_rd
  vlan_based_ip_local_learning_disable = each.value.vlan_based_ip_local_learning_disable
  vlan_based_ip_local_learning_enable  = each.value.vlan_based_ip_local_learning_enable
  vlan_based_default_gateway_advertise = each.value.vlan_based_default_gateway_advertise
  vlan_based_re_originate_route_type5  = each.value.vlan_based_re_originate_route_type5
  vlan_based_route_target_imports      = each.value.vlan_based_route_target_imports
  vlan_based_route_target_exports      = each.value.vlan_based_route_target_exports
  vlan_based_multicast_advertise       = each.value.vlan_based_multicast_advertise
}


locals {
  evpn_ethernet_segments = flatten([
    for device in local.devices : [
      for segment in try(local.device_config[device.name].evpn.ethernet_segments, []) : {
        key    = format("%s/%s", device.name, segment.es_value)
        device = device.name

        es_value              = try(segment.es_value, local.defaults.iosxe.configuration.evpn.ethernet_segments.es_value, null)
        df_election_wait_time = try(segment.df_election_wait_time, local.defaults.iosxe.configuration.evpn.ethernet_segments.df_election_wait_time, null)
        # Derive redundancy booleans from the redundancy enum value
        redundancy_all_active    = try(segment.redundancy, local.defaults.iosxe.configuration.evpn.ethernet_segments.redundancy, null) == "all-active" ? true : null
        redundancy_single_active = try(segment.redundancy, local.defaults.iosxe.configuration.evpn.ethernet_segments.redundancy, null) == "single-active" ? true : null
        # Derive identifier_type from the identifier format:
        # - ESI hex string (9 dot-separated groups) -> type 0, use hex_string
        # - MAC address (any other format) -> type 3, use system_mac
        identifier_types = try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, null) != null ? [
          {
            # ESI hex string has 9 dot-separated groups (e.g., "0.0.0.0.0.0.1.1.1")
            # MAC addresses have fewer groups when split by "."
            type = length(split(".", try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""))) == 9 ? 0 : 3
            # hex_string is used for type 0 (ESI hex string format)
            hex_string = length(split(".", try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""))) == 9 ? try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, null) : null
            # system_mac is used for type 3 (MAC address format)
            # Normalize MAC address to Cisco dotted notation (xxxx.xxxx.xxxx)
            # Accepts: xx:xx:xx:xx:xx:xx, xx-xx-xx-xx-xx-xx, or xxxx.xxxx.xxxx
            system_mac = length(split(".", try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""))) != 9 ? (
              length(regexall(":", try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""))) > 0 ||
              length(regexall("-", try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""))) > 0 ?
              format("%s.%s.%s",
                substr(replace(replace(try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""), ":", ""), "-", ""), 0, 4),
                substr(replace(replace(try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""), ":", ""), "-", ""), 4, 4),
                substr(replace(replace(try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, ""), ":", ""), "-", ""), 8, 4)
              ) :
              try(segment.identifier, local.defaults.iosxe.configuration.evpn.ethernet_segments.identifier, null)
            ) : null
          }
        ] : null
      }
    ]
  ])
}

resource "iosxe_evpn_ethernet_segment" "evpn_ethernet_segment" {
  for_each = { for e in local.evpn_ethernet_segments : e.key => e }
  device   = each.value.device

  es_value                 = each.value.es_value
  df_election_wait_time    = each.value.df_election_wait_time
  redundancy_all_active    = each.value.redundancy_all_active
  redundancy_single_active = each.value.redundancy_single_active
  identifier_types         = each.value.identifier_types

  depends_on = [
    iosxe_evpn.evpn
  ]
}
