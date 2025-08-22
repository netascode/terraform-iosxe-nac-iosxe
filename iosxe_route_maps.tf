locals {
  route_maps = flatten([
    for device in local.devices : [
      for route_map in try(local.device_config[device.name].route_maps, []) : {
        key    = format("%s/%s", device.name, route_map.name)
        device = device.name

        name = route_map.name
        entries = try(length(route_map.entries) == 0, true) ? null : [for e in route_map.entries : {
          seq                              = try(e.seq, local.defaults.iosxe.configuration.route_maps.entries.seq, null)
          operation                        = try(e.operation, local.defaults.iosxe.configuration.route_maps.entries.operation, null)
          description                      = try(e.description, local.defaults.iosxe.configuration.route_maps.entries.description, null)
          continue                         = try(e.continue, local.defaults.iosxe.configuration.route_maps.entries.continue, null)
          continue_sequence_number         = try(e.continue_sequence_number, local.defaults.iosxe.configuration.route_maps.entries.continue_sequence_number, null)
          match_as_paths                   = try(e.match.as_paths, local.defaults.iosxe.configuration.route_maps.entries.match.as_paths, null)
          match_community_list_exact_match = try(e.match.community_list_exact_match, local.defaults.iosxe.configuration.route_maps.entries.match.community_list_exact_match, null)
          match_community_lists            = try(e.match.community_lists, local.defaults.iosxe.configuration.route_maps.entries.match.community_lists, null)
          match_extcommunity_lists         = try(e.match.extcommunity_lists, local.defaults.iosxe.configuration.route_maps.entries.match.extcommunity_lists, null)
          match_interfaces                 = try(e.match.interfaces, local.defaults.iosxe.configuration.route_maps.entries.match.interfaces, null)
          match_ip_address_access_lists    = try(e.match.ipv4_address_access_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv4_address_access_lists, null)
          match_ip_address_prefix_lists    = try(e.match.ipv4_address_prefix_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv4_address_prefix_lists, null)
          match_ip_next_hop_access_lists   = try(e.match.ipv4_next_hop_access_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv4_next_hop_access_lists, null)
          match_ip_next_hop_prefix_lists   = try(e.match.ipv4_next_hop_prefix_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv4_next_hop_prefix_lists, null)
          match_ipv6_address_access_lists  = try(e.match.ipv6_address_access_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv6_address_access_lists, null)
          match_ipv6_address_prefix_lists  = try(e.match.ipv6_address_prefix_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv6_address_prefix_lists, null)
          match_ipv6_next_hop_access_lists = try(e.match.ipv6_next_hop_access_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv6_next_hop_access_lists, null)
          match_ipv6_next_hop_prefix_lists = try(e.match.ipv6_next_hop_prefix_lists, local.defaults.iosxe.configuration.route_maps.entries.match.ipv6_next_hop_prefix_lists, null)
          match_local_preferences          = try(e.match.local_preferences, local.defaults.iosxe.configuration.route_maps.entries.match.local_preferences, null)
          match_route_type_external        = try(e.match.route_type.external, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.external, null)
          match_route_type_external_type_1 = try(e.match.route_type.external_type_1, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.external_type_1, null)
          match_route_type_external_type_2 = try(e.match.route_type.external_type_2, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.external_type_2, null)
          match_route_type_internal        = try(e.match.route_type.internal, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.internal, null)
          match_route_type_level_1         = try(e.match.route_type.level_1, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.level_1, null)
          match_route_type_level_2         = try(e.match.route_type.level_2, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.level_2, null)
          match_route_type_local           = try(e.match.route_type.local, local.defaults.iosxe.configuration.route_maps.entries.match.route_type.local, null)
          match_source_protocol_bgp        = try(e.match.source_protocol.bgp, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.bgp, null)
          match_source_protocol_connected  = try(e.match.source_protocol.connected, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.connected, null)
          match_source_protocol_eigrp      = try(e.match.source_protocol.eigrp, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.eigrp, null)
          match_source_protocol_isis       = try(e.match.source_protocol.isis, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.isis, null)
          match_source_protocol_lisp       = try(e.match.source_protocol.lisp, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.lisp, null)
          match_source_protocol_ospf       = try(e.match.source_protocol.ospf, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.ospf, null)
          match_source_protocol_ospfv3     = try(e.match.source_protocol.ospfv3, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.ospfv3, null)
          match_source_protocol_rip        = try(e.match.source_protocol.rip, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.rip, null)
          match_source_protocol_static     = try(e.match.source_protocol.static, local.defaults.iosxe.configuration.route_maps.entries.match.source_protocol.static, null)
          match_tags                       = try(e.match.tags, local.defaults.iosxe.configuration.route_maps.entries.match.tags, null)
          match_track                      = try(e.match.track, local.defaults.iosxe.configuration.route_maps.entries.match.track, null)
          set_as_path_prepend_as           = try(e.set.as_path_prepend_as, local.defaults.iosxe.configuration.route_maps.entries.set.as_path_prepend_as, null)
          set_as_path_prepend_last_as      = try(e.set.as_path_prepend_last_as, local.defaults.iosxe.configuration.route_maps.entries.set.as_path_prepend_last_as, null)
          set_as_path_replace_any          = try(e.set.as_path_replace_any, local.defaults.iosxe.configuration.route_maps.entries.set.as_path_replace_any, null)
          set_as_path_replace_as = try(length(e.set.as_path_replace_as) == 0, true) ? null : [for as in e.set.as_path_replace_as : {
            as_number = as
          }]
          set_as_path_tag                            = try(e.set.as_path_tag, local.defaults.iosxe.configuration.route_maps.entries.set.as_path_tag, null)
          set_communities                            = try(e.set.communities, local.defaults.iosxe.configuration.route_maps.entries.set.communities, null)
          set_communities_additive                   = try(e.set.communities_additive, local.defaults.iosxe.configuration.route_maps.entries.set.communities_additive, null)
          set_community_list_delete                  = try(e.set.community_list_delete, local.defaults.iosxe.configuration.route_maps.entries.set.community_list_delete, null)
          set_community_list_expanded                = try(e.set.community_list_expanded, local.defaults.iosxe.configuration.route_maps.entries.set.community_list_expanded, null)
          set_community_list_name                    = try(e.set.community_list_name, local.defaults.iosxe.configuration.route_maps.entries.set.community_list_name, null)
          set_community_list_standard                = try(e.set.community_list_standard, local.defaults.iosxe.configuration.route_maps.entries.set.community_list_standard, null)
          set_community_none                         = try(e.set.community_none, local.defaults.iosxe.configuration.route_maps.entries.set.community_none, null)
          set_default_interfaces                     = try(e.set.default_interfaces, local.defaults.iosxe.configuration.route_maps.entries.set.default_interfaces, null)
          set_extcomunity_rt                         = try(e.set.extcomunity_rt, local.defaults.iosxe.configuration.route_maps.entries.set.extcomunity_rt, null)
          set_extcomunity_soo                        = try(e.set.extcomunity_soo, local.defaults.iosxe.configuration.route_maps.entries.set.extcomunity_soo, null)
          set_extcomunity_vpn_distinguisher          = try(e.set.extcomunity_vpn_distinguisher, local.defaults.iosxe.configuration.route_maps.entries.set.extcomunity_vpn_distinguisher, null)
          set_extcomunity_vpn_distinguisher_additive = try(e.set.extcomunity_vpn_distinguisher_additive, local.defaults.iosxe.configuration.route_maps.entries.set.extcomunity_vpn_distinguisher_additive, null)
          set_global                                 = try(e.set.global, local.defaults.iosxe.configuration.route_maps.entries.set.global, null)
          set_interfaces                             = try(e.set.interfaces, local.defaults.iosxe.configuration.route_maps.entries.set.interfaces, null)
          set_ip_address                             = try(e.set.ipv4_address, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_address, null)
          set_ip_default_global_next_hop_address     = try(e.set.ipv4_default_global_next_hop_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_default_global_next_hop_addresses, null)
          set_ip_default_next_hop_address            = try(e.set.ipv4_default_next_hop_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_default_next_hop_addresses, null)
          set_ip_global_next_hop_address             = try(e.set.ipv4_global_next_hop_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_global_next_hop_addresses, null)
          set_ip_next_hop_address                    = try(e.set.ipv4_next_hop_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_next_hop_addresses, null)
          set_ip_next_hop_self                       = try(e.set.ipv4_next_hop_self, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_next_hop_self, null)
          set_ip_qos_group                           = try(e.set.ipv4_qos_group, local.defaults.iosxe.configuration.route_maps.entries.set.ipv4_qos_group, null)
          set_ipv6_address                           = try(e.set.ipv6_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv6_addresses, null)
          set_ipv6_default_global_next_hop           = try(e.set.ipv6_default_global_next_hop, local.defaults.iosxe.configuration.route_maps.entries.set.ipv6_default_global_next_hop, null)
          set_ipv6_default_next_hop                  = try(e.set.ipv6_default_next_hop_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv6_default_next_hop_addresses, null)
          set_ipv6_next_hop                          = try(e.set.ipv6_next_hop_addresses, local.defaults.iosxe.configuration.route_maps.entries.set.ipv6_next_hop_addresses, null)
          set_level_1                                = try(e.set.level_1, local.defaults.iosxe.configuration.route_maps.entries.set.level_1, null)
          set_level_1_2                              = try(e.set.level_1_2, local.defaults.iosxe.configuration.route_maps.entries.set.level_1_2, null)
          set_level_2                                = try(e.set.level_2, local.defaults.iosxe.configuration.route_maps.entries.set.level_2, null)
          set_local_preference                       = try(e.set.local_preference, local.defaults.iosxe.configuration.route_maps.entries.set.local_preference, null)
          set_metric_change                          = try(e.set.metric_change, local.defaults.iosxe.configuration.route_maps.entries.set.metric_change, null)
          set_metric_delay                           = try(e.set.metric_delay, local.defaults.iosxe.configuration.route_maps.entries.set.metric_delay, null)
          set_metric_loading                         = try(e.set.metric_loading, local.defaults.iosxe.configuration.route_maps.entries.set.metric_loading, null)
          set_metric_mtu                             = try(e.set.metric_mtu, local.defaults.iosxe.configuration.route_maps.entries.set.metric_mtu, null)
          set_metric_reliability                     = try(e.set.metric_reliability, local.defaults.iosxe.configuration.route_maps.entries.set.metric_reliability, null)
          set_metric_type                            = try(e.set.metric_type, local.defaults.iosxe.configuration.route_maps.entries.set.metric_type, null)
          set_metric_value                           = try(e.set.metric_value, local.defaults.iosxe.configuration.route_maps.entries.set.metric_value, null)
          set_tag                                    = try(e.set.tag, local.defaults.iosxe.configuration.route_maps.entries.set.tag, null)
          set_vrf                                    = try(e.set.vrf, local.defaults.iosxe.configuration.route_maps.entries.set.vrf, null)
          set_weight                                 = try(e.set.weight, local.defaults.iosxe.configuration.route_maps.entries.set.weight, null)
        }]
  }]])
}

resource "iosxe_route_map" "route_map" {
  for_each = { for e in local.route_maps : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_prefix_list.prefix_list,
    iosxe_community_list_standard.community_list_standard,
    iosxe_community_list_expanded.community_list_expanded
  ]
}
