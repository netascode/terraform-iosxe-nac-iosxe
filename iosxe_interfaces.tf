##### BDIS #####

locals {
  interfaces_bdis = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.bdis, []) : {
        key         = format("%s/BDI%s", device.name, int.id)
        device      = device.name
        id          = int.id
        mac_address = try(int.mac_address, null)
        ip_mtu      = try(int.ip_mtu, null)
      }
    ]
  ])
}

resource "iosxe_interface_bdi" "bdi" {
  for_each = { for v in local.interfaces_bdis : v.key => v }
  device   = each.value.device

  name        = each.value.id
  mac_address = each.value.mac_address
  ip_mtu      = each.value.ip_mtu

}

##### ETHERNETS #####

locals {
  interfaces_ethernets = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.ethernets, []) : {
        key                                     = format("%s/%s%s", device.name, try(int.type, null), trimprefix(int.id, "$string "))
        device                                  = device.name
        id                                      = trimprefix(int.id, "$string ")
        managed                                 = try(int.managed, true)
        type                                    = try(int.type, null)
        media_type                              = try(int.media_type, null)
        bandwidth                               = try(int.bandwidth, null)
        mtu                                     = try(int.mtu, null)
        description                             = try(int.description, null)
        shutdown                                = try(int.shutdown, null)
        vrf_forwarding                          = try(int.vrf_forwarding, null)
        ipv4_address                            = try(int.ipv4.address, null)
        ipv4_address_mask                       = try(int.ipv4.address_mask, null)
        ipv4_address_dhcp                       = try(int.ipv4.address_dhcp, null)
        ip_proxy_arp                            = try(int.ipv4.proxy_arp, null)
        ip_arp_inspection_trust                 = try(int.ipv4.arp_inspection_trust, null)
        ip_arp_inspection_limit_rate            = try(int.ipv4.arp_inspection_limit_rate, null)
        ip_dhcp_snooping_trust                  = try(int.ipv4.dhcp_snooping_trust, null)
        ip_dhcp_relay_source_interface          = try("${try(int.ipv4.dhcp_relay_source_interface_type, null)}${try(int.ipv4.dhcp_relay_source_interface_id, null)}", null)
        ip_dhcp_relay_information_option_vpn_id = try(int.ipv4.dhcp_relay_information_option_vpn_id, null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for ha in int.ipv4.helper_addresses : {
          address = try(ha.address, null)
          global  = try(ha.global, null)
          vrf     = try(ha.vrf, null)
        }]
        ip_access_group_in         = try(int.ipv4.access_group_in, null)
        ip_access_group_in_enable  = try(int.ipv4.access_group_in, null) != null ? true : null
        ip_access_group_out        = try(int.ipv4.access_group_out, null)
        ip_access_group_out_enable = try(int.ipv4.access_group_out, null) != null ? true : null
        ip_flow_monitors = try(length(int.ipv4.flow_monitors) == 0, true) ? null : [for fm in int.ipv4.flow_monitors : {
          name      = try(fm.name, null)
          direction = try(fm.direction, null)
        }]
        ip_nbar_protocol_discovery               = try(int.nbar_protocol_discovery, null)
        ip_redirects                             = try(int.ipv4.redirects, null)
        ip_unreachables                          = try(int.ipv4.unreachables, null)
        unnumbered                               = try("${try(int.ipv4.unnumbered_interface_type, null)}${try(int.ipv4.unnumbered_interface_id, null)}", null)
        source_template                          = try(int.source_template, [])
        ipv6_enable                              = try(int.ipv6.enable, null)
        ip_verify_unicast_source_reachable_via   = try(int.ipv4.verify_unicast_source_reachable_via, null)
        ip_verify_unicast_source_allow_self_ping = try(int.ipv4.verify_unicast_source_allow_self_ping, null)
        ip_verify_unicast_source_allow_default   = try(int.ipv4.verify_unicast_source_allow_default, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = try(addr.prefix, null)
          eui_64 = try(addr.eui_64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp               = try(int.ipv6.address_dhcp, null)
        ipv6_mtu                        = try(int.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all         = try(int.ipv6.nd_ra_suppress_all, null)
        ipv6_flow_monitors = try(length(int.ipv6.flow_monitors) == 0, true) ? null : [for fm in int.ipv6.flow_monitors : {
          name      = try(fm.name, null)
          direction = try(fm.direction, null)
        }]
        bfd_enable                     = try(int.bfd.enable, null)
        bfd_template                   = try(int.bfd.template, null)
        bfd_local_address              = try(int.bfd.local_address, null)
        bfd_interval                   = try(int.bfd.interval, null)
        bfd_interval_min_rx            = try(int.bfd.interval_min_rx, null)
        bfd_interval_multiplier        = try(int.bfd.interval_multiplier, null)
        bfd_echo                       = try(int.bfd.echo, null)
        spanning_tree_guard            = try(int.spanning_tree.guard, null)
        spanning_tree_link_type        = try(int.spanning_tree.link_type, null)
        spanning_tree_portfast_trunk   = try(int.spanning_tree.portfast_trunk, null)
        spanning_tree_portfast         = try(int.spanning_tree.portfast, null)
        spanning_tree_portfast_disable = try(int.spanning_tree.portfast_disable, null)
        spanning_tree_portfast_edge    = try(int.spanning_tree.portfast_edge, null)
        bpduguard_enable               = try(int.spanning_tree.bpduguard, null)
        bpduguard_disable              = try(int.spanning_tree.bpduguard_disable, null)
        speed_100                      = try(int.speed, null) == 100 ? true : null
        speed_1000                     = try(int.speed, null) == 1000 ? true : null
        speed_2500                     = try(int.speed, null) == 2500 ? true : null
        speed_5000                     = try(int.speed, null) == 5000 ? true : null
        speed_10000                    = try(int.speed, null) == 10000 ? true : null
        speed_25000                    = try(int.speed, null) == 25000 ? true : null
        speed_40000                    = try(int.speed, null) == 40000 ? true : null
        speed_100000                   = try(int.speed, null) == 100000 ? true : null
        speed_nonegotiate              = try(int.speed_nonegotiate, null)
        channel_group_number           = try(int.port_channel_id, null)
        channel_group_mode             = try(int.port_channel_mode, null)
        source_templates = try(length(int.source_templates) == 0, true) ? null : [for st in int.source_templates : {
          template_name = try(st.name, null)
          merge         = try(st.merge, null)
        }]
        arp_timeout                      = try(int.arp_timeout, null)
        negotiation_auto                 = try(int.negotiation_auto, null)
        service_policy_input             = try(int.service_policy_input, null)
        service_policy_output            = try(int.service_policy_output, null)
        load_interval                    = try(int.load_interval, null)
        snmp_trap_link_status            = try(int.snmp_trap_link_status, null)
        logging_event_link_status_enable = try(int.logging_event_link_status, null)
        device_tracking                  = try(int.device_tracking, null)
        device_tracking_attached_policies = try(length(int.device_tracking_attached_policies) == 0, true) ? null : [for policy in int.device_tracking_attached_policies : {
          name = policy
        }]
        encapsulation_dot1q_vlan_id              = try(int.encapsulation_dot1q_vlan_id, null)
        switchport                               = try(int.switchport.enable, null)
        switchport_mode                          = try(int.switchport.mode, null)
        switchport_access_vlan                   = try(int.switchport.access_vlan, null)
        switchport_voice_vlan                    = try(tostring(int.switchport.voice_vlan), null)
        switchport_mode_access                   = try(int.switchport.mode, null) == "access" ? true : null
        switchport_mode_trunk                    = try(int.switchport.mode, null) == "trunk" ? true : null
        switchport_mode_dot1q_tunnel             = try(int.switchport.mode, null) == "dot1q-tunnel" ? true : null
        switchport_mode_private_vlan_trunk       = try(int.switchport.mode, null) == "private-vlan-trunk" ? true : null
        switchport_mode_private_vlan_host        = try(int.switchport.mode, null) == "private-vlan-host" ? true : null
        switchport_mode_private_vlan_promiscuous = try(int.switchport.mode, null) == "private-vlan-promiscuous" ? true : null
        switchport_nonegotiate                   = try(int.switchport.nonegotiate, null)
        # NEW v2 trunk allowed VLANs - supports all/none/vlans/add/except/remove
        switchport_trunk_allowed_vlans = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.vlans, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_none = try(int.switchport.trunk_allowed_vlans.none, null)
        # Default to all VLANs allowed if trunk mode and no trunk_allowed_vlans specified (native IOS-XE behavior)
        switchport_trunk_allowed_vlans_all = try(int.switchport.trunk_allowed_vlans.all, # Default to true for trunk mode if trunk_allowed_vlans is not specified at all
          (try(int.switchport.trunk_allowed_vlans, null) == null &&
        contains(["trunk", "private-vlan-trunk"], try(int.switchport.mode, ""))) ? true : null)
        switchport_trunk_allowed_vlans_add = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.add, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_except = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.except, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_remove = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.remove, null),
            "string"
          ),
          null
        )
        # LEGACY trunk allowed VLANs (deprecated) - for backward compatibility
        switchport_trunk_allowed_vlans_legacy = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans_legacy, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_none_legacy = length(try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans_legacy, null),
            "list"
          ),
          []
        )) == 0 && try(int.switchport.trunk_allowed_vlans_legacy, null) != null ? true : null
        switchport_trunk_native_vlan_tag      = try(int.switchport.trunk_native_vlan_tag, null)
        switchport_trunk_native_vlan          = try(int.switchport.trunk_native_vlan_id, null)
        switchport_host                       = try(int.switchport.host, null)
        auto_qos_classify                     = try(int.auto_qos.classify, null)
        auto_qos_classify_police              = try(int.auto_qos.classify_police, null)
        auto_qos_trust                        = try(int.auto_qos.trust, null)
        auto_qos_trust_cos                    = try(int.auto_qos.trust_cos, null)
        auto_qos_trust_dscp                   = try(int.auto_qos.trust_dscp, null)
        auto_qos_video_cts                    = try(int.auto_qos.video_cts, null)
        auto_qos_video_ip_camera              = try(int.auto_qos.video_ip_camera, null)
        auto_qos_video_media_player           = try(int.auto_qos.video_media_player, null)
        auto_qos_voip_cisco_phone             = try(int.auto_qos.voip_cisco_phone, null)
        auto_qos_voip_cisco_softphone         = try(int.auto_qos.voip_cisco_softphone, null)
        auto_qos_voip_trust                   = try(int.auto_qos.voip_trust, null)
        trust_device                          = try(int.auto_qos.trust_device, null)
        mpls_ip                               = try(int.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, null)
        ospf_authentication_key_chain         = try(int.ospf.authentication_key_chain, null)
        ospf_authentication_message_digest    = try(int.ospf.authentication_message_digest, null)
        ospf_authentication_null              = try(int.ospf.authentication_null, null)
        ospf_cost                             = try(int.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, null)
          md5_auth_key  = try(key.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, null)
        }]
        ospf_multi_area_ids = try(length(int.ospf.multi_area_ids) == 0, true) ? null : [for area in int.ospf.multi_area_ids : {
          area_id = area
        }]
        ospfv3                                  = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                             = try(int.ospfv3.cost, null)
        ospfv3_bfd                              = try(int.ospfv3.bfd, null)
        ospfv3_dead_interval                    = try(int.ospfv3.dead_interval, null)
        ospfv3_hello_interval                   = try(int.ospfv3.hello_interval, null)
        ospfv3_mtu_ignore                       = try(int.ospfv3.mtu_ignore, null)
        ospfv3_priority                         = try(int.ospfv3.priority, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, null)
        pim_border                              = try(int.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, null)
        ipv6_pim                                = try(int.ipv6.pim, null) != null ? true : false
        ipv6_pim_pim                            = try(int.ipv6.pim.pim, null)
        ipv6_pim_bfd                            = try(int.ipv6.pim.bfd, null)
        ipv6_pim_bsr_border                     = try(int.ipv6.pim.bsr_border, null)
        ipv6_pim_dr_priority                    = try(int.ipv6.pim.dr_priority, null)
        ip_igmp_version                         = try(int.igmp.version, null)
        isis_area_tag                           = try(int.isis.area_tag, null)
        isis                                    = try(int.isis, null) != null ? true : false
        isis_network_point_to_point             = try(int.isis.network_point_to_point, null)
        isis_ipv4_metric_levels = try(length(int.isis.ipv4_metric_levels) == 0, true) ? null : [for level in int.isis.ipv4_metric_levels : {
          level = try(level.level, null)
          value = try(level.value, null)
        }]
        authentication_periodic                    = try(int.network_access_control.authentication_periodic, null)
        authentication_timer_reauthenticate        = try(int.network_access_control.authentication_timer_reauthenticate, null)
        authentication_timer_reauthenticate_server = try(int.network_access_control.authentication_timer_reauthenticate_server, null)
        mab                                        = try(int.network_access_control.mab, null)
        mab_eap                                    = try(int.network_access_control.mab_eap, null)
        dot1x_pae                                  = try(int.network_access_control.dot1x_pae, null)
        dot1x_timeout_auth_period                  = try(int.network_access_control.dot1x_timeout_auth_period, null)
        dot1x_timeout_held_period                  = try(int.network_access_control.dot1x_timeout_held_period, null)
        dot1x_timeout_quiet_period                 = try(int.network_access_control.dot1x_timeout_quiet_period, null)
        dot1x_timeout_ratelimit_period             = try(int.network_access_control.dot1x_timeout_ratelimit_period, null)
        dot1x_timeout_server_timeout               = try(int.network_access_control.dot1x_timeout_server_timeout, null)
        dot1x_timeout_start_period                 = try(int.network_access_control.dot1x_timeout_start_period, null)
        dot1x_timeout_supp_timeout                 = try(int.network_access_control.dot1x_timeout_supp_timeout, null)
        dot1x_timeout_tx_period                    = try(int.network_access_control.dot1x_timeout_tx_period, null)
        dot1x_max_reauth_req                       = try(int.network_access_control.dot1x_max_reauth_req, null)
        dot1x_max_req                              = try(int.network_access_control.dot1x_max_req, null)
        cdp_enable                                 = try(int.cdp, null)
        cdp_tlv_app                                = try(int.cdp_tlv_app, null)
        cdp_tlv_location                           = try(int.cdp_tlv_location, null)
        cdp_tlv_server_location                    = try(int.cdp_tlv_server_location, null)
        evpn_ethernet_segments = try(length(int.evpn_ethernet_segments) == 0, true) ? null : [for es in int.evpn_ethernet_segments : {
          es_value = try(es.es_value, null)
        }]
        ip_nat_inside        = try(int.ipv4.nat_inside, null)
        ip_nat_outside       = try(int.ipv4.nat_outside, null)
        zone_member_security = try(int.zone_member_security, null)
        carrier_delay_msec   = try(int.carrier_delay_msec, null)
        hold_queues = (contains(keys(int), "hold_queue_in") || contains(keys(int), "hold_queue_out")) ? flatten([
          (contains(keys(int), "hold_queue_in")) ? [{
            direction    = "in"
            queue_length = try(int.hold_queue_in, null)
          }] : [],
          (contains(keys(int), "hold_queue_out")) ? [{
            direction    = "out"
            queue_length = try(int.hold_queue_out, null)
          }] : []
        ]) : null
        service_instances = try(length(int.service_instances) == 0, true) ? null : [for si in int.service_instances : {
          id                     = try(si.id, null)
          ethernet               = try(si.type, null) == "ethernet" ? true : null
          encapsulation_untagged = try(si.encapsulation, null) == "untagged" ? true : null
        }]
      }
    ]
  ])
}

resource "iosxe_interface_ethernet" "ethernet" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && !strcontains(v.id, ".") }
  device   = each.value.device

  type                                       = each.value.type
  name                                       = each.value.id
  media_type                                 = each.value.media_type
  bandwidth                                  = each.value.bandwidth
  mtu                                        = each.value.mtu
  description                                = each.value.description
  shutdown                                   = each.value.shutdown
  vrf_forwarding                             = each.value.vrf_forwarding
  ipv4_address                               = each.value.ipv4_address
  ipv4_address_mask                          = each.value.ipv4_address_mask
  ipv4_address_dhcp                          = each.value.ipv4_address_dhcp
  ip_proxy_arp                               = each.value.ip_proxy_arp
  ip_arp_inspection_trust                    = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate               = each.value.ip_arp_inspection_limit_rate
  ip_dhcp_snooping_trust                     = each.value.ip_dhcp_snooping_trust
  ip_dhcp_relay_source_interface             = each.value.ip_dhcp_relay_source_interface
  ip_dhcp_relay_information_option_vpn_id    = each.value.ip_dhcp_relay_information_option_vpn_id
  helper_addresses                           = each.value.helper_addresses
  ip_access_group_in                         = each.value.ip_access_group_in
  ip_access_group_in_enable                  = each.value.ip_access_group_in_enable
  ip_access_group_out                        = each.value.ip_access_group_out
  ip_access_group_out_enable                 = each.value.ip_access_group_out_enable
  ip_flow_monitors                           = each.value.ip_flow_monitors
  ip_nbar_protocol_discovery                 = each.value.ip_nbar_protocol_discovery
  ip_redirects                               = each.value.ip_redirects
  ip_unreachables                            = each.value.ip_unreachables
  ip_verify_unicast_source_reachable_via     = each.value.ip_verify_unicast_source_reachable_via
  ip_verify_unicast_source_allow_self_ping   = each.value.ip_verify_unicast_source_allow_self_ping
  ip_verify_unicast_source_allow_default     = each.value.ip_verify_unicast_source_allow_default
  ip_igmp_version                            = each.value.ip_igmp_version
  unnumbered                                 = each.value.unnumbered
  ipv6_address_autoconfig_default            = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                          = each.value.ipv6_address_dhcp
  ipv6_addresses                             = each.value.ipv6_addresses
  ipv6_enable                                = each.value.ipv6_enable
  ipv6_link_local_addresses                  = each.value.ipv6_link_local_addresses
  ipv6_mtu                                   = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all                    = each.value.ipv6_nd_ra_suppress_all
  ipv6_flow_monitors                         = each.value.ipv6_flow_monitors
  bfd_enable                                 = each.value.bfd_enable
  bfd_template                               = each.value.bfd_template
  bfd_local_address                          = each.value.bfd_local_address
  bfd_interval                               = each.value.bfd_interval
  bfd_interval_min_rx                        = each.value.bfd_interval_min_rx
  bfd_interval_multiplier                    = each.value.bfd_interval_multiplier
  bfd_echo                                   = each.value.bfd_echo
  spanning_tree_guard                        = each.value.spanning_tree_guard
  spanning_tree_link_type                    = each.value.spanning_tree_link_type
  spanning_tree_portfast_trunk               = each.value.spanning_tree_portfast_trunk
  spanning_tree_portfast                     = each.value.spanning_tree_portfast
  spanning_tree_portfast_disable             = each.value.spanning_tree_portfast_disable
  spanning_tree_portfast_edge                = each.value.spanning_tree_portfast_edge
  bpduguard_enable                           = each.value.bpduguard_enable
  bpduguard_disable                          = each.value.bpduguard_disable
  speed_100                                  = each.value.speed_100
  speed_1000                                 = each.value.speed_1000
  speed_2500                                 = each.value.speed_2500
  speed_5000                                 = each.value.speed_5000
  speed_10000                                = each.value.speed_10000
  speed_25000                                = each.value.speed_25000
  speed_40000                                = each.value.speed_40000
  speed_100000                               = each.value.speed_100000
  speed_nonegotiate                          = each.value.speed_nonegotiate
  channel_group_number                       = each.value.channel_group_number
  channel_group_mode                         = each.value.channel_group_mode
  source_template                            = each.value.source_templates
  arp_timeout                                = each.value.arp_timeout
  negotiation_auto                           = each.value.negotiation_auto
  service_policy_input                       = each.value.service_policy_input
  service_policy_output                      = each.value.service_policy_output
  load_interval                              = each.value.load_interval
  snmp_trap_link_status                      = each.value.snmp_trap_link_status
  logging_event_link_status_enable           = each.value.logging_event_link_status_enable
  device_tracking                            = each.value.device_tracking
  device_tracking_attached_policies          = each.value.device_tracking_attached_policies
  encapsulation_dot1q_vlan_id                = each.value.encapsulation_dot1q_vlan_id
  switchport                                 = each.value.switchport
  auto_qos_classify                          = each.value.auto_qos_classify
  auto_qos_classify_police                   = each.value.auto_qos_classify_police
  auto_qos_trust                             = each.value.auto_qos_trust
  auto_qos_trust_cos                         = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp                        = each.value.auto_qos_trust_dscp
  auto_qos_video_cts                         = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera                   = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player                = each.value.auto_qos_video_media_player
  auto_qos_voip_cisco_phone                  = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone              = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust                        = each.value.auto_qos_voip_trust
  trust_device                               = each.value.trust_device
  authentication_periodic                    = each.value.authentication_periodic
  authentication_timer_reauthenticate        = each.value.authentication_timer_reauthenticate
  authentication_timer_reauthenticate_server = each.value.authentication_timer_reauthenticate_server
  mab                                        = each.value.mab
  mab_eap                                    = each.value.mab_eap
  dot1x_pae                                  = each.value.dot1x_pae
  dot1x_timeout_auth_period                  = each.value.dot1x_timeout_auth_period
  dot1x_timeout_held_period                  = each.value.dot1x_timeout_held_period
  dot1x_timeout_quiet_period                 = each.value.dot1x_timeout_quiet_period
  dot1x_timeout_ratelimit_period             = each.value.dot1x_timeout_ratelimit_period
  dot1x_timeout_server_timeout               = each.value.dot1x_timeout_server_timeout
  dot1x_timeout_start_period                 = each.value.dot1x_timeout_start_period
  dot1x_timeout_supp_timeout                 = each.value.dot1x_timeout_supp_timeout
  dot1x_timeout_tx_period                    = each.value.dot1x_timeout_tx_period
  dot1x_max_reauth_req                       = each.value.dot1x_max_reauth_req
  dot1x_max_req                              = each.value.dot1x_max_req
  cdp_enable                                 = each.value.cdp_enable
  cdp_tlv_app                                = each.value.cdp_tlv_app
  cdp_tlv_location                           = each.value.cdp_tlv_location
  cdp_tlv_server_location                    = each.value.cdp_tlv_server_location
  evpn_ethernet_segments                     = each.value.evpn_ethernet_segments
  ip_nat_inside                              = each.value.ip_nat_inside
  ip_nat_outside                             = each.value.ip_nat_outside
  zone_member_security                       = each.value.zone_member_security
  carrier_delay_msec                         = each.value.carrier_delay_msec
  hold_queues                                = each.value.hold_queues
  service_instances                          = each.value.service_instances
  ip_router_isis                             = each.value.isis_area_tag

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map,
    iosxe_evpn_ethernet_segment.evpn_ethernet_segment,
    iosxe_flow_monitor.flow_monitor,
    iosxe_dot1x.dot1x,
    iosxe_aaa_authentication.aaa_authentication,
    iosxe_isis.isis,
    iosxe_interface_switchport.ethernet_switchport,
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_ethernet" "ethernet_sub" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && strcontains(v.id, ".") }
  device   = each.value.device

  type                                       = each.value.type
  name                                       = each.value.id
  media_type                                 = each.value.media_type
  bandwidth                                  = each.value.bandwidth
  mtu                                        = each.value.mtu
  description                                = each.value.description
  shutdown                                   = each.value.shutdown
  vrf_forwarding                             = each.value.vrf_forwarding
  ipv4_address                               = each.value.ipv4_address
  ipv4_address_mask                          = each.value.ipv4_address_mask
  ip_proxy_arp                               = each.value.ip_proxy_arp
  ip_arp_inspection_trust                    = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate               = each.value.ip_arp_inspection_limit_rate
  ip_dhcp_snooping_trust                     = each.value.ip_dhcp_snooping_trust
  ip_dhcp_relay_source_interface             = each.value.ip_dhcp_relay_source_interface
  ip_dhcp_relay_information_option_vpn_id    = each.value.ip_dhcp_relay_information_option_vpn_id
  helper_addresses                           = each.value.helper_addresses
  ip_access_group_in                         = each.value.ip_access_group_in
  ip_access_group_in_enable                  = each.value.ip_access_group_in_enable
  ip_access_group_out                        = each.value.ip_access_group_out
  ip_access_group_out_enable                 = each.value.ip_access_group_out_enable
  ip_flow_monitors                           = each.value.ip_flow_monitors
  ip_nbar_protocol_discovery                 = each.value.ip_nbar_protocol_discovery
  ip_redirects                               = each.value.ip_redirects
  ip_unreachables                            = each.value.ip_unreachables
  ip_verify_unicast_source_reachable_via     = each.value.ip_verify_unicast_source_reachable_via
  ip_verify_unicast_source_allow_self_ping   = each.value.ip_verify_unicast_source_allow_self_ping
  ip_verify_unicast_source_allow_default     = each.value.ip_verify_unicast_source_allow_default
  ip_igmp_version                            = each.value.ip_igmp_version
  unnumbered                                 = each.value.unnumbered
  ipv6_address_autoconfig_default            = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                          = each.value.ipv6_address_dhcp
  ipv6_addresses                             = each.value.ipv6_addresses
  ipv6_enable                                = each.value.ipv6_enable
  ipv6_link_local_addresses                  = each.value.ipv6_link_local_addresses
  ipv6_mtu                                   = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all                    = each.value.ipv6_nd_ra_suppress_all
  ipv6_flow_monitors                         = each.value.ipv6_flow_monitors
  bfd_enable                                 = each.value.bfd_enable
  bfd_template                               = each.value.bfd_template
  bfd_local_address                          = each.value.bfd_local_address
  bfd_interval                               = each.value.bfd_interval
  bfd_interval_min_rx                        = each.value.bfd_interval_min_rx
  bfd_interval_multiplier                    = each.value.bfd_interval_multiplier
  bfd_echo                                   = each.value.bfd_echo
  spanning_tree_guard                        = each.value.spanning_tree_guard
  spanning_tree_link_type                    = each.value.spanning_tree_link_type
  spanning_tree_portfast_trunk               = each.value.spanning_tree_portfast_trunk
  spanning_tree_portfast                     = each.value.spanning_tree_portfast
  spanning_tree_portfast_disable             = each.value.spanning_tree_portfast_disable
  spanning_tree_portfast_edge                = each.value.spanning_tree_portfast_edge
  bpduguard_enable                           = each.value.bpduguard_enable
  bpduguard_disable                          = each.value.bpduguard_disable
  speed_100                                  = each.value.speed_100
  speed_1000                                 = each.value.speed_1000
  speed_2500                                 = each.value.speed_2500
  speed_5000                                 = each.value.speed_5000
  speed_10000                                = each.value.speed_10000
  speed_25000                                = each.value.speed_25000
  speed_40000                                = each.value.speed_40000
  speed_100000                               = each.value.speed_100000
  speed_nonegotiate                          = each.value.speed_nonegotiate
  channel_group_number                       = each.value.channel_group_number
  channel_group_mode                         = each.value.channel_group_mode
  source_template                            = each.value.source_templates
  arp_timeout                                = each.value.arp_timeout
  negotiation_auto                           = each.value.negotiation_auto
  service_policy_input                       = each.value.service_policy_input
  service_policy_output                      = each.value.service_policy_output
  load_interval                              = each.value.load_interval
  snmp_trap_link_status                      = each.value.snmp_trap_link_status
  logging_event_link_status_enable           = each.value.logging_event_link_status_enable
  device_tracking                            = each.value.device_tracking
  device_tracking_attached_policies          = each.value.device_tracking_attached_policies
  encapsulation_dot1q_vlan_id                = each.value.encapsulation_dot1q_vlan_id
  switchport                                 = each.value.switchport
  auto_qos_classify                          = each.value.auto_qos_classify
  auto_qos_classify_police                   = each.value.auto_qos_classify_police
  auto_qos_trust                             = each.value.auto_qos_trust
  auto_qos_trust_cos                         = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp                        = each.value.auto_qos_trust_dscp
  auto_qos_video_cts                         = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera                   = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player                = each.value.auto_qos_video_media_player
  auto_qos_voip_cisco_phone                  = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone              = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust                        = each.value.auto_qos_voip_trust
  trust_device                               = each.value.trust_device
  authentication_periodic                    = each.value.authentication_periodic
  authentication_timer_reauthenticate        = each.value.authentication_timer_reauthenticate
  authentication_timer_reauthenticate_server = each.value.authentication_timer_reauthenticate_server
  mab                                        = each.value.mab
  mab_eap                                    = each.value.mab_eap
  dot1x_pae                                  = each.value.dot1x_pae
  dot1x_timeout_auth_period                  = each.value.dot1x_timeout_auth_period
  dot1x_timeout_held_period                  = each.value.dot1x_timeout_held_period
  dot1x_timeout_quiet_period                 = each.value.dot1x_timeout_quiet_period
  dot1x_timeout_ratelimit_period             = each.value.dot1x_timeout_ratelimit_period
  dot1x_timeout_server_timeout               = each.value.dot1x_timeout_server_timeout
  dot1x_timeout_start_period                 = each.value.dot1x_timeout_start_period
  dot1x_timeout_supp_timeout                 = each.value.dot1x_timeout_supp_timeout
  dot1x_timeout_tx_period                    = each.value.dot1x_timeout_tx_period
  dot1x_max_reauth_req                       = each.value.dot1x_max_reauth_req
  dot1x_max_req                              = each.value.dot1x_max_req
  cdp_enable                                 = each.value.cdp_enable
  cdp_tlv_app                                = each.value.cdp_tlv_app
  cdp_tlv_location                           = each.value.cdp_tlv_location
  cdp_tlv_server_location                    = each.value.cdp_tlv_server_location
  evpn_ethernet_segments                     = each.value.evpn_ethernet_segments
  ip_nat_inside                              = each.value.ip_nat_inside
  ip_nat_outside                             = each.value.ip_nat_outside
  zone_member_security                       = each.value.zone_member_security
  carrier_delay_msec                         = each.value.carrier_delay_msec
  hold_queues                                = each.value.hold_queues
  service_instances                          = each.value.service_instances
  ip_router_isis                             = each.value.isis_area_tag

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map,
    iosxe_evpn_ethernet_segment.evpn_ethernet_segment,
    iosxe_flow_monitor.flow_monitor,
    iosxe_dot1x.dot1x,
    iosxe_aaa_authentication.aaa_authentication,
    iosxe_isis.isis,
    iosxe_interface_switchport.ethernet_switchport,
    iosxe_interface_ethernet.ethernet
  ]
}

resource "iosxe_interface_ethernet" "ethernet_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if !v.managed }
  device   = each.value.device

  type                                       = each.value.type
  name                                       = each.value.id
  media_type                                 = each.value.media_type
  bandwidth                                  = each.value.bandwidth
  mtu                                        = each.value.mtu
  description                                = each.value.description
  shutdown                                   = each.value.shutdown
  vrf_forwarding                             = each.value.vrf_forwarding
  ipv4_address                               = each.value.ipv4_address
  ipv4_address_mask                          = each.value.ipv4_address_mask
  ipv4_address_dhcp                          = each.value.ipv4_address_dhcp
  ip_proxy_arp                               = each.value.ip_proxy_arp
  ip_arp_inspection_trust                    = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate               = each.value.ip_arp_inspection_limit_rate
  ip_dhcp_snooping_trust                     = each.value.ip_dhcp_snooping_trust
  ip_dhcp_relay_source_interface             = each.value.ip_dhcp_relay_source_interface
  ip_dhcp_relay_information_option_vpn_id    = each.value.ip_dhcp_relay_information_option_vpn_id
  helper_addresses                           = each.value.helper_addresses
  ip_access_group_in                         = each.value.ip_access_group_in
  ip_access_group_in_enable                  = each.value.ip_access_group_in_enable
  ip_access_group_out                        = each.value.ip_access_group_out
  ip_access_group_out_enable                 = each.value.ip_access_group_out_enable
  ip_flow_monitors                           = each.value.ip_flow_monitors
  ip_nbar_protocol_discovery                 = each.value.ip_nbar_protocol_discovery
  ip_redirects                               = each.value.ip_redirects
  ip_unreachables                            = each.value.ip_unreachables
  ip_verify_unicast_source_reachable_via     = each.value.ip_verify_unicast_source_reachable_via
  ip_verify_unicast_source_allow_self_ping   = each.value.ip_verify_unicast_source_allow_self_ping
  ip_verify_unicast_source_allow_default     = each.value.ip_verify_unicast_source_allow_default
  ip_igmp_version                            = each.value.ip_igmp_version
  unnumbered                                 = each.value.unnumbered
  ipv6_address_autoconfig_default            = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                          = each.value.ipv6_address_dhcp
  ipv6_addresses                             = each.value.ipv6_addresses
  ipv6_enable                                = each.value.ipv6_enable
  ipv6_link_local_addresses                  = each.value.ipv6_link_local_addresses
  ipv6_mtu                                   = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all                    = each.value.ipv6_nd_ra_suppress_all
  ipv6_flow_monitors                         = each.value.ipv6_flow_monitors
  bfd_enable                                 = each.value.bfd_enable
  bfd_template                               = each.value.bfd_template
  bfd_local_address                          = each.value.bfd_local_address
  bfd_interval                               = each.value.bfd_interval
  bfd_interval_min_rx                        = each.value.bfd_interval_min_rx
  bfd_interval_multiplier                    = each.value.bfd_interval_multiplier
  bfd_echo                                   = each.value.bfd_echo
  spanning_tree_guard                        = each.value.spanning_tree_guard
  spanning_tree_link_type                    = each.value.spanning_tree_link_type
  spanning_tree_portfast_trunk               = each.value.spanning_tree_portfast_trunk
  spanning_tree_portfast                     = each.value.spanning_tree_portfast
  spanning_tree_portfast_disable             = each.value.spanning_tree_portfast_disable
  spanning_tree_portfast_edge                = each.value.spanning_tree_portfast_edge
  bpduguard_enable                           = each.value.bpduguard_enable
  bpduguard_disable                          = each.value.bpduguard_disable
  speed_100                                  = each.value.speed_100
  speed_1000                                 = each.value.speed_1000
  speed_2500                                 = each.value.speed_2500
  speed_5000                                 = each.value.speed_5000
  speed_10000                                = each.value.speed_10000
  speed_25000                                = each.value.speed_25000
  speed_40000                                = each.value.speed_40000
  speed_100000                               = each.value.speed_100000
  speed_nonegotiate                          = each.value.speed_nonegotiate
  channel_group_number                       = each.value.channel_group_number
  channel_group_mode                         = each.value.channel_group_mode
  source_template                            = each.value.source_templates
  arp_timeout                                = each.value.arp_timeout
  negotiation_auto                           = each.value.negotiation_auto
  service_policy_input                       = each.value.service_policy_input
  service_policy_output                      = each.value.service_policy_output
  load_interval                              = each.value.load_interval
  snmp_trap_link_status                      = each.value.snmp_trap_link_status
  logging_event_link_status_enable           = each.value.logging_event_link_status_enable
  device_tracking                            = each.value.device_tracking
  device_tracking_attached_policies          = each.value.device_tracking_attached_policies
  encapsulation_dot1q_vlan_id                = each.value.encapsulation_dot1q_vlan_id
  switchport                                 = each.value.switchport
  auto_qos_classify                          = each.value.auto_qos_classify
  auto_qos_classify_police                   = each.value.auto_qos_classify_police
  auto_qos_trust                             = each.value.auto_qos_trust
  auto_qos_trust_cos                         = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp                        = each.value.auto_qos_trust_dscp
  auto_qos_video_cts                         = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera                   = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player                = each.value.auto_qos_video_media_player
  auto_qos_voip_cisco_phone                  = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone              = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust                        = each.value.auto_qos_voip_trust
  trust_device                               = each.value.trust_device
  authentication_periodic                    = each.value.authentication_periodic
  authentication_timer_reauthenticate        = each.value.authentication_timer_reauthenticate
  authentication_timer_reauthenticate_server = each.value.authentication_timer_reauthenticate_server
  mab                                        = each.value.mab
  mab_eap                                    = each.value.mab_eap
  dot1x_pae                                  = each.value.dot1x_pae
  dot1x_timeout_auth_period                  = each.value.dot1x_timeout_auth_period
  dot1x_timeout_held_period                  = each.value.dot1x_timeout_held_period
  dot1x_timeout_quiet_period                 = each.value.dot1x_timeout_quiet_period
  dot1x_timeout_ratelimit_period             = each.value.dot1x_timeout_ratelimit_period
  dot1x_timeout_server_timeout               = each.value.dot1x_timeout_server_timeout
  dot1x_timeout_start_period                 = each.value.dot1x_timeout_start_period
  dot1x_timeout_supp_timeout                 = each.value.dot1x_timeout_supp_timeout
  dot1x_timeout_tx_period                    = each.value.dot1x_timeout_tx_period
  dot1x_max_reauth_req                       = each.value.dot1x_max_reauth_req
  dot1x_max_req                              = each.value.dot1x_max_req
  cdp_enable                                 = each.value.cdp_enable
  cdp_tlv_app                                = each.value.cdp_tlv_app
  cdp_tlv_location                           = each.value.cdp_tlv_location
  cdp_tlv_server_location                    = each.value.cdp_tlv_server_location
  evpn_ethernet_segments                     = each.value.evpn_ethernet_segments
  ip_nat_inside                              = each.value.ip_nat_inside
  ip_nat_outside                             = each.value.ip_nat_outside
  zone_member_security                       = each.value.zone_member_security
  carrier_delay_msec                         = each.value.carrier_delay_msec
  hold_queues                                = each.value.hold_queues
  service_instances                          = each.value.service_instances

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map,
    iosxe_evpn_ethernet_segment.evpn_ethernet_segment,
    iosxe_flow_monitor.flow_monitor,
    iosxe_dot1x.dot1x,
    iosxe_aaa_authentication.aaa_authentication,
    iosxe_interface_switchport.ethernet_switchport_unmanaged,
    iosxe_interface_port_channel.port_channel
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "iosxe_interface_switchport" "ethernet_switchport" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && (v.switchport == true || v.switchport_mode != null) }

  device                        = each.value.device
  type                          = each.value.type
  name                          = each.value.id
  mode_access                   = each.value.switchport_mode_access
  mode_trunk                    = each.value.switchport_mode_trunk
  mode_dot1q_tunnel             = each.value.switchport_mode_dot1q_tunnel
  mode_private_vlan_trunk       = each.value.switchport_mode_private_vlan_trunk
  mode_private_vlan_host        = each.value.switchport_mode_private_vlan_host
  mode_private_vlan_promiscuous = each.value.switchport_mode_private_vlan_promiscuous
  nonegotiate                   = each.value.switchport_nonegotiate
  access_vlan                   = each.value.switchport_access_vlan
  voice_vlan                    = each.value.switchport_voice_vlan
  # NEW v2 trunk allowed VLANs
  trunk_allowed_vlans        = each.value.switchport_trunk_allowed_vlans
  trunk_allowed_vlans_none   = each.value.switchport_trunk_allowed_vlans_none
  trunk_allowed_vlans_all    = each.value.switchport_trunk_allowed_vlans_all
  trunk_allowed_vlans_except = each.value.switchport_trunk_allowed_vlans_except
  trunk_allowed_vlans_remove = each.value.switchport_trunk_allowed_vlans_remove
  trunk_allowed_vlans_add    = each.value.switchport_trunk_allowed_vlans_add != null ? [{ vlans = each.value.switchport_trunk_allowed_vlans_add }] : null
  # LEGACY trunk allowed VLANs (deprecated)
  trunk_allowed_vlans_legacy      = each.value.switchport_trunk_allowed_vlans_legacy
  trunk_allowed_vlans_none_legacy = each.value.switchport_trunk_allowed_vlans_none_legacy
  trunk_native_vlan_tag           = each.value.switchport_trunk_native_vlan_tag
  trunk_native_vlan               = each.value.switchport_trunk_native_vlan
  host                            = each.value.switchport_host

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_dot1x.dot1x,
    iosxe_aaa_authentication.aaa_authentication
  ]
}

resource "iosxe_interface_switchport" "ethernet_switchport_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if !v.managed && (v.switchport == true || v.switchport_mode != null) }

  device                        = each.value.device
  type                          = each.value.type
  name                          = each.value.id
  mode_access                   = each.value.switchport_mode_access
  mode_trunk                    = each.value.switchport_mode_trunk
  mode_dot1q_tunnel             = each.value.switchport_mode_dot1q_tunnel
  mode_private_vlan_trunk       = each.value.switchport_mode_private_vlan_trunk
  mode_private_vlan_host        = each.value.switchport_mode_private_vlan_host
  mode_private_vlan_promiscuous = each.value.switchport_mode_private_vlan_promiscuous
  nonegotiate                   = each.value.switchport_nonegotiate
  access_vlan                   = each.value.switchport_access_vlan
  voice_vlan                    = each.value.switchport_voice_vlan
  # NEW v2 trunk allowed VLANs
  trunk_allowed_vlans        = each.value.switchport_trunk_allowed_vlans
  trunk_allowed_vlans_none   = each.value.switchport_trunk_allowed_vlans_none
  trunk_allowed_vlans_all    = each.value.switchport_trunk_allowed_vlans_all
  trunk_allowed_vlans_except = each.value.switchport_trunk_allowed_vlans_except
  trunk_allowed_vlans_remove = each.value.switchport_trunk_allowed_vlans_remove
  trunk_allowed_vlans_add    = each.value.switchport_trunk_allowed_vlans_add != null ? [{ vlans = each.value.switchport_trunk_allowed_vlans_add }] : null
  # LEGACY trunk allowed VLANs (deprecated)
  trunk_allowed_vlans_legacy      = each.value.switchport_trunk_allowed_vlans_legacy
  trunk_allowed_vlans_none_legacy = each.value.switchport_trunk_allowed_vlans_none_legacy
  trunk_native_vlan_tag           = each.value.switchport_trunk_native_vlan_tag
  trunk_native_vlan               = each.value.switchport_trunk_native_vlan
  host                            = each.value.switchport_host

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_dot1x.dot1x,
    iosxe_aaa_authentication.aaa_authentication
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "iosxe_interface_mpls" "ethernet_mpls" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && (v.mpls_ip == true || v.mpls_mtu != null) }

  device = each.value.device
  type   = each.value.type
  name   = each.value.id
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub
  ]
}

resource "iosxe_interface_mpls" "ethernet_mpls_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if !v.managed && (v.mpls_ip == true || v.mpls_mtu != null) }

  device = each.value.device
  type   = each.value.type
  name   = each.value.id
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_ethernet.ethernet_unmanaged
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "iosxe_interface_ospf" "ethernet_ospf" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && v.ospf }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  message_digest_keys              = each.value.ospf_message_digest_keys
  mtu_ignore                       = each.value.ospf_mtu_ignore
  multi_area_ids                   = each.value.ospf_multi_area_ids
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  process_ids                      = each.value.ospf_process_ids
  ttl_security_hops                = each.value.ospf_ttl_security_hops

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospf" "ethernet_ospf_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if !v.managed && v.ospf }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  message_digest_keys              = each.value.ospf_message_digest_keys
  mtu_ignore                       = each.value.ospf_mtu_ignore
  multi_area_ids                   = each.value.ospf_multi_area_ids
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  process_ids                      = each.value.ospf_process_ids
  ttl_security_hops                = each.value.ospf_ttl_security_hops

  depends_on = [
    iosxe_interface_ethernet.ethernet_unmanaged,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "iosxe_interface_ospfv3" "ethernet_ospfv3" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.ospfv3 && v.managed }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "ethernet_ospfv3_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.ospfv3 && !v.managed }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_ethernet.ethernet_unmanaged,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "iosxe_interface_pim" "ethernet_pim" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && v.pim }

  device            = each.value.device
  type              = each.value.type
  name              = each.value.id
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub
  ]
}

resource "iosxe_interface_pim" "ethernet_pim_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if !v.managed && v.pim }

  device            = each.value.device
  type              = each.value.type
  name              = each.value.id
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_ethernet.ethernet_unmanaged
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "iosxe_interface_pim_ipv6" "ethernet_pim_ipv6" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && v.ipv6_pim }

  device      = each.value.device
  type        = each.value.type
  name        = each.value.id
  pim         = each.value.ipv6_pim_pim
  bfd         = each.value.ipv6_pim_bfd
  bsr_border  = each.value.ipv6_pim_bsr_border
  dr_priority = each.value.ipv6_pim_dr_priority

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub
  ]
}

resource "iosxe_interface_pim_ipv6" "ethernet_pim_ipv6_unmanaged" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if !v.managed && v.ipv6_pim }

  device      = each.value.device
  type        = each.value.type
  name        = each.value.id
  pim         = each.value.ipv6_pim_pim
  bfd         = each.value.ipv6_pim_bfd
  bsr_border  = each.value.ipv6_pim_bsr_border
  dr_priority = each.value.ipv6_pim_dr_priority

  depends_on = [
    iosxe_interface_ethernet.ethernet_unmanaged
  ]

  lifecycle {
    ignore_changes = all
  }
}

##### LOOPBACKS #####

locals {
  interfaces_loopbacks = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.loopbacks, []) : {
        key                                      = format("%s/Loopback%s", device.name, int.id)
        device                                   = device.name
        id                                       = int.id
        description                              = try(int.description, null)
        shutdown                                 = try(int.shutdown, null)
        ip_mtu                                   = try(int.ip_mtu, null)
        vrf_forwarding                           = try(int.vrf_forwarding, null)
        ipv4_address                             = try(int.ipv4.address, null)
        ipv4_address_mask                        = try(int.ipv4.address_mask, null)
        ipv4_address_dhcp                        = try(int.ipv4.address_dhcp, null)
        ip_proxy_arp                             = try(int.ipv4.proxy_arp, null)
        ip_access_group_in                       = try(int.ipv4.access_group_in, null)
        ip_access_group_in_enable                = try(int.ipv4.access_group_in, null) != null ? true : null
        ip_access_group_out                      = try(int.ipv4.access_group_out, null)
        ip_access_group_out_enable               = try(int.ipv4.access_group_out, null) != null ? true : null
        ip_redirects                             = try(int.ipv4.redirects, null)
        ip_unreachables                          = try(int.ipv4.unreachables, null)
        ip_nat_inside                            = try(int.ipv4.nat_inside, null)
        ip_nat_outside                           = try(int.ipv4.nat_outside, null)
        zone_member_security                     = try(int.zone_member_security, null)
        source_template                          = try(int.source_template, [])
        ipv6_enable                              = try(int.ipv6.enable, null)
        ip_verify_unicast_source_reachable_via   = try(int.ipv4.verify_unicast_source_reachable_via, null)
        ip_verify_unicast_source_allow_self_ping = try(int.ipv4.verify_unicast_source_allow_self_ping, null)
        ip_verify_unicast_source_allow_default   = try(int.ipv4.verify_unicast_source_allow_default, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = try(addr.prefix, null)
          eui_64 = try(addr.eui_64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp               = try(int.ipv6.address_dhcp, null)
        ipv6_mtu                        = try(int.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all         = try(int.ipv6.nd_ra_suppress_all, null)
        source_templates = try(length(int.source_templates) == 0, true) ? null : [for st in int.source_templates : {
          template_name = try(st.name, null)
          merge         = try(st.merge, null)
        }]
        arp_timeout                           = try(int.arp_timeout, null)
        load_interval                         = try(int.load_interval, null)
        mpls_ip                               = try(int.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, null)
        ospf_authentication_key_chain         = try(int.ospf.authentication_key_chain, null)
        ospf_authentication_message_digest    = try(int.ospf.authentication_message_digest, null)
        ospf_authentication_null              = try(int.ospf.authentication_null, null)
        ospf_cost                             = try(int.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, null)
          md5_auth_key  = try(key.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, null)
        }]
        ospf_multi_area_ids = try(length(int.ospf.multi_area_ids) == 0, true) ? null : [for area in int.ospf.multi_area_ids : {
          area_id = area
        }]
        ospfv3                                  = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                             = try(int.ospfv3.cost, null)
        ospfv3_bfd                              = try(int.ospfv3.bfd, null)
        ospfv3_dead_interval                    = try(int.ospfv3.dead_interval, null)
        ospfv3_hello_interval                   = try(int.ospfv3.hello_interval, null)
        ospfv3_mtu_ignore                       = try(int.ospfv3.mtu_ignore, null)
        ospfv3_priority                         = try(int.ospfv3.priority, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, null)
        pim_border                              = try(int.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, null)
        ipv6_pim                                = try(int.ipv6.pim, null) != null ? true : false
        ipv6_pim_pim                            = try(int.ipv6.pim.pim, null)
        ipv6_pim_bfd                            = try(int.ipv6.pim.bfd, null)
        ipv6_pim_bsr_border                     = try(int.ipv6.pim.bsr_border, null)
        ipv6_pim_dr_priority                    = try(int.ipv6.pim.dr_priority, null)
        isis                                    = try(int.isis, null) != null ? true : false
        isis_area_tag                           = try(int.isis.area_tag, null)
        isis_ipv4_metric_levels = try(length(int.isis.ipv4_metric_levels) == 0, true) ? null : [for level in int.isis.ipv4_metric_levels : {
          level = try(level.level, null)
          value = try(level.value, null)
        }]
        ip_igmp_version = try(int.igmp.version, null)
      }
    ]
  ])
}

resource "iosxe_interface_loopback" "loopback" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v }
  device   = each.value.device

  name                                     = each.value.id
  description                              = each.value.description
  shutdown                                 = each.value.shutdown
  ip_mtu                                   = each.value.ip_mtu
  vrf_forwarding                           = each.value.vrf_forwarding
  ipv4_address                             = each.value.ipv4_address
  ipv4_address_mask                        = each.value.ipv4_address_mask
  ipv4_address_dhcp                        = each.value.ipv4_address_dhcp
  ip_proxy_arp                             = each.value.ip_proxy_arp
  ip_access_group_in                       = each.value.ip_access_group_in
  ip_access_group_in_enable                = each.value.ip_access_group_in_enable
  ip_access_group_out                      = each.value.ip_access_group_out
  ip_access_group_out_enable               = each.value.ip_access_group_out_enable
  ip_redirects                             = each.value.ip_redirects
  ip_unreachables                          = each.value.ip_unreachables
  ip_verify_unicast_source_reachable_via   = each.value.ip_verify_unicast_source_reachable_via
  ip_verify_unicast_source_allow_self_ping = each.value.ip_verify_unicast_source_allow_self_ping
  ip_verify_unicast_source_allow_default   = each.value.ip_verify_unicast_source_allow_default
  ip_nat_inside                            = each.value.ip_nat_inside
  ip_nat_outside                           = each.value.ip_nat_outside
  zone_member_security                     = each.value.zone_member_security
  ip_igmp_version                          = each.value.ip_igmp_version
  ipv6_enable                              = each.value.ipv6_enable
  ipv6_addresses                           = each.value.ipv6_addresses
  ipv6_link_local_addresses                = each.value.ipv6_link_local_addresses
  ipv6_address_autoconfig_default          = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                        = each.value.ipv6_address_dhcp
  ipv6_mtu                                 = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all                  = each.value.ipv6_nd_ra_suppress_all
  arp_timeout                              = each.value.arp_timeout
  ip_router_isis                           = each.value.isis_area_tag

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map,
    iosxe_isis.isis
  ]
}

resource "iosxe_interface_mpls" "loopback_mpls" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v if v.mpls_ip == true || v.mpls_mtu != null }

  device = each.value.device
  type   = "Loopback"
  name   = each.value.id
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_loopback.loopback
  ]
}

resource "iosxe_interface_ospf" "loopback_ospf" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = "Loopback"
  name                             = each.value.id
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  mtu_ignore                       = each.value.ospf_mtu_ignore
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  ttl_security_hops                = each.value.ospf_ttl_security_hops
  process_ids                      = each.value.ospf_process_ids
  message_digest_keys              = each.value.ospf_message_digest_keys
  multi_area_ids                   = each.value.ospf_multi_area_ids

  depends_on = [
    iosxe_interface_loopback.loopback,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "loopback_ospfv3" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = "Loopback"
  name                             = each.value.id
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_loopback.loopback,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_pim" "loopback_pim" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v if v.pim }

  device            = each.value.device
  type              = "Loopback"
  name              = each.value.id
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_loopback.loopback
  ]
}

resource "iosxe_interface_pim_ipv6" "loopback_pim_ipv6" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v if v.ipv6_pim }

  device      = each.value.device
  type        = "Loopback"
  name        = each.value.id
  pim         = each.value.ipv6_pim_pim
  bfd         = each.value.ipv6_pim_bfd
  bsr_border  = each.value.ipv6_pim_bsr_border
  dr_priority = each.value.ipv6_pim_dr_priority

  depends_on = [
    iosxe_interface_loopback.loopback
  ]
}

resource "iosxe_interface_isis" "loopback_isis" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v if v.isis }

  device             = each.value.device
  type               = "Loopback"
  name               = each.value.id
  ipv4_metric_levels = each.value.isis_ipv4_metric_levels

  depends_on = [
    iosxe_interface_loopback.loopback,
    iosxe_isis.isis
  ]
}

resource "iosxe_interface_isis" "ethernet_isis" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.managed && v.isis }

  device                 = each.value.device
  type                   = each.value.type
  name                   = each.value.id
  network_point_to_point = each.value.isis_network_point_to_point
  ipv4_metric_levels     = each.value.isis_ipv4_metric_levels

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_isis.isis
  ]
}

####### VLANS #######

locals {
  interfaces_vlans = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.vlans, []) : {
        key                                     = format("%s/Vlan%s", device.name, int.id)
        device                                  = device.name
        id                                      = int.id
        type                                    = try(int.type, null)
        description                             = try(int.description, null)
        shutdown                                = try(int.shutdown, null)
        ip_mtu                                  = try(int.ip_mtu, null)
        autostate                               = try(int.autostate, null)
        vrf_forwarding                          = try(int.vrf_forwarding, null)
        ipv4_address                            = try(int.ipv4.address, null)
        ipv4_address_mask                       = try(int.ipv4.address_mask, null)
        ipv4_address_dhcp                       = try(int.ipv4.address_dhcp, null)
        ip_proxy_arp                            = try(int.ipv4.proxy_arp, null)
        ip_local_proxy_arp                      = try(int.ipv4.local_proxy_arp, null)
        mac_address                             = try(int.mac_address, null)
        ip_dhcp_relay_source_interface          = try("${try(int.ipv4.dhcp_relay_source_interface_type, null)}${try(int.ipv4.dhcp_relay_source_interface_id, null)}", null)
        ip_dhcp_relay_information_option_vpn_id = try(int.ipv4.dhcp_relay_information_option_vpn_id, null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for ha in int.ipv4.helper_addresses : {
          address = try(ha.address, null)
          global  = try(ha.global, null)
          vrf     = try(ha.vrf, null)
        }]
        ip_access_group_in                       = try(int.ipv4.access_group_in, null)
        ip_access_group_in_enable                = try(int.ipv4.access_group_in, null) != null ? true : null
        ip_access_group_out                      = try(int.ipv4.access_group_out, null)
        ip_access_group_out_enable               = try(int.ipv4.access_group_out, null) != null ? true : null
        ip_redirects                             = try(int.ipv4.redirects, null)
        ip_unreachables                          = try(int.ipv4.unreachables, null)
        ip_nat_inside                            = try(int.ipv4.nat_inside, null)
        ip_nat_outside                           = try(int.ipv4.nat_outside, null)
        zone_member_security                     = try(int.zone_member_security, null)
        unnumbered                               = try("${try(int.ipv4.unnumbered_interface_type, null)}${try(int.ipv4.unnumbered_interface_id, null)}", null)
        ipv6_enable                              = try(int.ipv6.enable, null)
        ip_verify_unicast_source_reachable_via   = try(int.ipv4.verify_unicast_source_reachable_via, null)
        ip_verify_unicast_source_allow_self_ping = try(int.ipv4.verify_unicast_source_allow_self_ping, null)
        ip_verify_unicast_source_allow_default   = try(int.ipv4.verify_unicast_source_allow_default, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = try(addr.prefix, null)
          eui_64 = try(addr.eui_64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default       = try(int.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp                     = try(int.ipv6.address_dhcp, null)
        ipv6_mtu                              = try(int.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all               = try(int.ipv6.nd_ra_suppress_all, null)
        bfd_enable                            = try(int.bfd.enable, null)
        bfd_template                          = try(int.bfd.template, null)
        bfd_local_address                     = try(int.bfd.local_address, null)
        bfd_interval                          = try(int.bfd.interval, null)
        bfd_interval_min_rx                   = try(int.bfd.interval_min_rx, null)
        bfd_interval_multiplier               = try(int.bfd.interval_multiplier, null)
        bfd_echo                              = try(int.bfd.echo, null)
        load_interval                         = try(int.load_interval, null)
        snmp_trap_link_status                 = try(int.snmp_trap_link_status, null)
        logging_event_link_status_enable      = try(int.logging_event_link_status, null)
        mpls_ip                               = try(int.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, null)
        ospf_authentication_key_chain         = try(int.ospf.authentication_key_chain, null)
        ospf_authentication_message_digest    = try(int.ospf.authentication_message_digest, null)
        ospf_authentication_null              = try(int.ospf.authentication_null, null)
        ospf_cost                             = try(int.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, null)
          md5_auth_key  = try(key.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, null)
        }]
        ospf_multi_area_ids = try(length(int.ospf.multi_area_ids) == 0, true) ? null : [for area in int.ospf.multi_area_ids : {
          area_id = area
        }]
        ospfv3                                  = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                             = try(int.ospfv3.cost, null)
        ospfv3_bfd                              = try(int.ospfv3.bfd, null)
        ospfv3_dead_interval                    = try(int.ospfv3.dead_interval, null)
        ospfv3_hello_interval                   = try(int.ospfv3.hello_interval, null)
        ospfv3_mtu_ignore                       = try(int.ospfv3.mtu_ignore, null)
        ospfv3_priority                         = try(int.ospfv3.priority, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, null)
        pim_border                              = try(int.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, null)
        ipv6_pim                                = try(int.ipv6.pim, null) != null ? true : false
        ipv6_pim_pim                            = try(int.ipv6.pim.pim, null)
        ipv6_pim_bfd                            = try(int.ipv6.pim.bfd, null)
        ipv6_pim_bsr_border                     = try(int.ipv6.pim.bsr_border, null)
        ipv6_pim_dr_priority                    = try(int.ipv6.pim.dr_priority, null)
        ip_igmp_version                         = try(int.igmp.version, null)
        isis_area_tag                           = try(int.isis.area_tag, null)
        isis                                    = try(int.isis, null) != null ? true : false
        isis_network_point_to_point             = try(int.isis.network_point_to_point, null)
        isis_ipv4_metric_levels = try(length(int.isis.ipv4_metric_levels) == 0, true) ? null : [for level in int.isis.ipv4_metric_levels : {
          level = try(level.level, null)
          value = try(level.value, null)
        }]
      }
    ]
  ])
}

resource "iosxe_interface_vlan" "vlan" {
  for_each = { for v in local.interfaces_vlans : v.key => v }
  device   = each.value.device

  name                                     = each.value.id
  description                              = each.value.description
  shutdown                                 = each.value.shutdown
  ip_mtu                                   = each.value.ip_mtu
  autostate                                = each.value.autostate
  vrf_forwarding                           = each.value.vrf_forwarding
  ipv4_address                             = each.value.ipv4_address
  ipv4_address_mask                        = each.value.ipv4_address_mask
  ipv4_address_dhcp                        = each.value.ipv4_address_dhcp
  ip_proxy_arp                             = each.value.ip_proxy_arp
  ip_local_proxy_arp                       = each.value.ip_local_proxy_arp
  mac_address                              = each.value.mac_address
  ip_dhcp_relay_source_interface           = each.value.ip_dhcp_relay_source_interface
  ip_dhcp_relay_information_option_vpn_id  = each.value.ip_dhcp_relay_information_option_vpn_id
  helper_addresses                         = each.value.helper_addresses
  ip_access_group_in                       = each.value.ip_access_group_in
  ip_access_group_in_enable                = each.value.ip_access_group_in_enable
  ip_access_group_out                      = each.value.ip_access_group_out
  ip_access_group_out_enable               = each.value.ip_access_group_out_enable
  ip_redirects                             = each.value.ip_redirects
  ip_unreachables                          = each.value.ip_unreachables
  ip_verify_unicast_source_reachable_via   = each.value.ip_verify_unicast_source_reachable_via
  ip_verify_unicast_source_allow_self_ping = each.value.ip_verify_unicast_source_allow_self_ping
  ip_verify_unicast_source_allow_default   = each.value.ip_verify_unicast_source_allow_default
  ip_nat_inside                            = each.value.ip_nat_inside
  ip_nat_outside                           = each.value.ip_nat_outside
  zone_member_security                     = each.value.zone_member_security
  ip_igmp_version                          = each.value.ip_igmp_version
  unnumbered                               = each.value.unnumbered
  ipv6_address_autoconfig_default          = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                        = each.value.ipv6_address_dhcp
  ipv6_addresses                           = each.value.ipv6_addresses
  ipv6_enable                              = each.value.ipv6_enable
  ipv6_link_local_addresses                = each.value.ipv6_link_local_addresses
  ipv6_mtu                                 = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all                  = each.value.ipv6_nd_ra_suppress_all
  bfd_enable                               = each.value.bfd_enable
  bfd_template                             = each.value.bfd_template
  bfd_local_address                        = each.value.bfd_local_address
  bfd_interval                             = each.value.bfd_interval
  bfd_interval_min_rx                      = each.value.bfd_interval_min_rx
  bfd_interval_multiplier                  = each.value.bfd_interval_multiplier
  bfd_echo                                 = each.value.bfd_echo
  load_interval                            = each.value.load_interval
  ip_router_isis                           = each.value.isis_area_tag

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map,
    iosxe_isis.isis
  ]
}

resource "iosxe_interface_mpls" "vlan_mpls" {
  for_each = { for v in local.interfaces_vlans : v.key => v if v.mpls_ip == true || v.mpls_mtu != null }

  device = each.value.device
  type   = "Vlan"
  name   = each.value.id
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_vlan.vlan
  ]
}

resource "iosxe_interface_ospf" "vlan_ospf" {
  for_each = { for v in local.interfaces_vlans : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = "Vlan"
  name                             = each.value.id
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  mtu_ignore                       = each.value.ospf_mtu_ignore
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  ttl_security_hops                = each.value.ospf_ttl_security_hops
  process_ids                      = each.value.ospf_process_ids
  message_digest_keys              = each.value.ospf_message_digest_keys
  multi_area_ids                   = each.value.ospf_multi_area_ids

  depends_on = [
    iosxe_interface_vlan.vlan,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "vlan_ospfv3" {
  for_each = { for v in local.interfaces_vlans : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = "Vlan"
  name                             = each.value.id
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_vlan.vlan,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_pim" "vlan_pim" {
  for_each = { for v in local.interfaces_vlans : v.key => v if v.pim }

  device            = each.value.device
  type              = "Vlan"
  name              = each.value.id
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_vlan.vlan
  ]
}

resource "iosxe_interface_pim_ipv6" "vlan_pim_ipv6" {
  for_each = { for v in local.interfaces_vlans : v.key => v if v.ipv6_pim }

  device      = each.value.device
  type        = "Vlan"
  name        = each.value.id
  pim         = each.value.ipv6_pim_pim
  bfd         = each.value.ipv6_pim_bfd
  bsr_border  = each.value.ipv6_pim_bsr_border
  dr_priority = each.value.ipv6_pim_dr_priority

  depends_on = [
    iosxe_interface_vlan.vlan
  ]
}

resource "iosxe_interface_isis" "vlan_isis" {
  for_each = { for v in local.interfaces_vlans : v.key => v if v.isis }

  device                 = each.value.device
  type                   = "Vlan"
  name                   = each.value.id
  network_point_to_point = each.value.isis_network_point_to_point
  ipv4_metric_levels     = each.value.isis_ipv4_metric_levels

  depends_on = [
    iosxe_interface_vlan.vlan,
    iosxe_isis.isis
  ]
}

##### PORT-CHANNELS #####

locals {
  interfaces_port_channels = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.port_channels, []) : {
        key                            = format("%s/Port-channel%s", device.name, trimprefix(int.id, "$string "))
        device                         = device.name
        name                           = trimprefix(int.id, "$string ")
        description                    = try(int.description, null)
        shutdown                       = try(int.shutdown, null)
        mtu                            = try(int.mtu, null)
        vrf_forwarding                 = try(int.vrf_forwarding, null)
        ipv4_address                   = try(int.ipv4.address, null)
        ipv4_address_mask              = try(int.ipv4.address_mask, null)
        ipv4_address_dhcp              = try(int.ipv4.address_dhcp, null)
        ip_proxy_arp                   = try(int.ipv4.proxy_arp, null)
        ip_dhcp_relay_source_interface = try(int.ipv4.dhcp_relay_source_interface_type, int.ipv4.dhcp_relay_source_interface_id, null) != null ? format("%s%s", try(int.ipv4.dhcp_relay_source_interface_type, null), try(int.ipv4.dhcp_relay_source_interface_id, null)) : null
        ip_access_group_in             = try(int.ipv4.access_group_in, null)
        ip_access_group_in_enable      = try(int.ipv4.access_group_in, null) != null ? true : null
        ip_access_group_out            = try(int.ipv4.access_group_out, null)
        ip_access_group_out_enable     = try(int.ipv4.access_group_out, null) != null ? true : null
        ip_flow_monitors = try(length(int.ipv4.flow_monitors) == 0, true) ? null : [for fm in int.ipv4.flow_monitors : {
          name      = try(fm.name, null)
          direction = try(fm.direction, null)
        }]
        ip_redirects                             = try(int.ipv4.redirects, null)
        ip_unreachables                          = try(int.ipv4.unreachables, null)
        ip_nat_inside                            = try(int.ipv4.nat_inside, null)
        ip_nat_outside                           = try(int.ipv4.nat_outside, null)
        zone_member_security                     = try(int.zone_member_security, null)
        ip_arp_inspection_trust                  = try(int.ipv4.arp_inspection_trust, null)
        ip_arp_inspection_limit_rate             = try(int.ipv4.arp_inspection_limit_rate, null)
        ip_dhcp_snooping_trust                   = try(int.ipv4.dhcp_snooping_trust, null)
        ip_verify_unicast_source_reachable_via   = try(int.ipv4.verify_unicast_source_reachable_via, null)
        ip_verify_unicast_source_allow_self_ping = try(int.ipv4.verify_unicast_source_allow_self_ping, null)
        ip_verify_unicast_source_allow_default   = try(int.ipv4.verify_unicast_source_allow_default, null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for addr in int.ipv4.helper_addresses : {
          address = try(addr.address, null)
          global  = try(addr.global, false)
          vrf     = try(addr.vrf, null)
        }]
        ipv6_enable             = try(int.ipv6.enable, null)
        ipv6_mtu                = try(int.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all = try(int.ipv6.nd_ra_suppress_all, null)
        ipv6_address_dhcp       = try(int.ipv6.address_dhcp, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = try(addr.prefix, null)
          eui_64 = try(addr.eui_64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, null)
        ipv6_flow_monitors = try(length(int.ipv6.flow_monitors) == 0, true) ? null : [for fm in int.ipv6.flow_monitors : {
          name      = try(fm.name, null)
          direction = try(fm.direction, null)
        }]
        bfd_template                     = try(int.bfd.template, null)
        bfd_enable                       = try(int.bfd.enable, null)
        bfd_local_address                = try(int.bfd.local_address, null)
        bfd_interval                     = try(int.bfd.interval, null)
        bfd_interval_min_rx              = try(int.bfd.interval_min_rx, null)
        bfd_interval_multiplier          = try(int.bfd.interval_multiplier, null)
        bfd_echo                         = try(int.bfd.echo, null)
        spanning_tree_guard              = try(int.spanning_tree.guard, null)
        spanning_tree_link_type          = try(int.spanning_tree.link_type, null)
        spanning_tree_portfast_trunk     = try(int.spanning_tree.portfast_trunk, null)
        spanning_tree_portfast           = try(int.spanning_tree.portfast, null)
        spanning_tree_portfast_disable   = try(int.spanning_tree.portfast_disable, null)
        spanning_tree_portfast_edge      = try(int.spanning_tree.portfast_edge, null)
        bpduguard_enable                 = try(int.spanning_tree.bpduguard, null)
        bpduguard_disable                = try(int.spanning_tree.bpduguard_disable, null)
        arp_timeout                      = try(int.arp_timeout, null)
        load_interval                    = try(int.load_interval, null)
        snmp_trap_link_status            = try(int.snmp_trap_link_status, null)
        logging_event_link_status_enable = try(int.logging_event_link_status, null)
        device_tracking                  = try(int.device_tracking, null)
        device_tracking_attached_policies = try(length(int.device_tracking_attached_policies) == 0, true) ? null : [for policy in int.device_tracking_attached_policies : {
          name = policy
        }]
        switchport                               = try(int.switchport.enable, null)
        switchport_mode                          = try(int.switchport.mode, null)
        switchport_access_vlan                   = try(int.switchport.access_vlan, null)
        switchport_voice_vlan                    = try(tostring(int.switchport.voice_vlan), null)
        switchport_mode_access                   = try(int.switchport.mode, null) == "access" ? true : null
        switchport_mode_trunk                    = try(int.switchport.mode, null) == "trunk" ? true : null
        switchport_mode_dot1q_tunnel             = try(int.switchport.mode, null) == "dot1q-tunnel" ? true : null
        switchport_mode_private_vlan_trunk       = try(int.switchport.mode, null) == "private-vlan-trunk" ? true : null
        switchport_mode_private_vlan_host        = try(int.switchport.mode, null) == "private-vlan-host" ? true : null
        switchport_mode_private_vlan_promiscuous = try(int.switchport.mode, null) == "private-vlan-promiscuous" ? true : null
        switchport_nonegotiate                   = try(int.switchport.nonegotiate, null)
        # NEW v2 trunk allowed VLANs - supports all/none/vlans/add/except/remove
        switchport_trunk_allowed_vlans = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.vlans, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_none = try(int.switchport.trunk_allowed_vlans.none, null)
        # Default to all VLANs allowed if trunk mode and no trunk_allowed_vlans specified (native IOS-XE behavior)
        switchport_trunk_allowed_vlans_all = try(int.switchport.trunk_allowed_vlans.all, # Default to true for trunk mode if trunk_allowed_vlans is not specified at all
          (try(int.switchport.trunk_allowed_vlans, null) == null &&
        contains(["trunk", "private-vlan-trunk"], try(int.switchport.mode, ""))) ? true : null)
        switchport_trunk_allowed_vlans_add = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.add, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_except = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.except, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_remove = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans.remove, null),
            "string"
          ),
          null
        )
        # LEGACY trunk allowed VLANs (deprecated) - for backward compatibility
        switchport_trunk_allowed_vlans_legacy = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans_legacy, null),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_none_legacy = length(try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans_legacy, null),
            "list"
          ),
          []
        )) == 0 && try(int.switchport.trunk_allowed_vlans_legacy, null) != null ? true : null
        switchport_trunk_native_vlan_tag      = try(int.switchport.trunk_native_vlan_tag, null)
        switchport_trunk_native_vlan          = try(int.switchport.trunk_native_vlan_id, null)
        switchport_host                       = try(int.switchport.host, null)
        mpls                                  = try(int.mpls.ip, int.mpls.mtu, null) != null ? true : false
        mpls_ip                               = try(int.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_authentication_key_chain         = try(int.ospf.authentication_key_chain, null)
        ospf_authentication_message_digest    = try(int.ospf.authentication_message_digest, null)
        ospf_authentication_null              = try(int.ospf.authentication_null, null)
        ospf_cost                             = try(int.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, null)
        ospf_network_type                     = try(int.ospf.network_type, null)
        ospf_network_type_broadcast           = try(int.ospf.network_type, null) == "broadcast" ? true : false
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, null) == "non-broadcast" ? true : false
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, null) == "point-to-multipoint" ? true : false
        ospf_network_type_point_to_point      = try(int.ospf.network_type, null) == "point-to-point" ? true : false
        ospf_priority                         = try(int.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, null)
          md5_auth_key  = try(key.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, null)
        }]
        ospf_multi_area_ids = try(length(int.ospf.multi_area_ids) == 0, true) ? null : [for area in int.ospf.multi_area_ids : {
          area_id = area
        }]
        ospfv3                                  = try(int.ospfv3.network_type, int.ospfv3.cost, null) != null ? true : false
        ospfv3_network_type                     = try(int.ospfv3.network_type, null)
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, null) == "broadcast" ? true : false
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, null) == "non-broadcast" ? true : false
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, null) == "point-to-multipoint" ? true : false
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, null) == "point-to-point" ? true : false
        ospfv3_cost                             = try(int.ospfv3.cost, null)
        ospfv3_bfd                              = try(int.ospfv3.bfd, null)
        ospfv3_dead_interval                    = try(int.ospfv3.dead_interval, null)
        ospfv3_hello_interval                   = try(int.ospfv3.hello_interval, null)
        ospfv3_mtu_ignore                       = try(int.ospfv3.mtu_ignore, null)
        ospfv3_priority                         = try(int.ospfv3.priority, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, null)
        pim_border                              = try(int.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, null)
        ipv6_pim                                = try(int.ipv6.pim, null) != null ? true : false
        ipv6_pim_pim                            = try(int.ipv6.pim.pim, null)
        ipv6_pim_bfd                            = try(int.ipv6.pim.bfd, null)
        ipv6_pim_bsr_border                     = try(int.ipv6.pim.bsr_border, null)
        ipv6_pim_dr_priority                    = try(int.ipv6.pim.dr_priority, null)
        ip_igmp_version                         = try(int.igmp.version, null)
        isis_area_tag                           = try(int.isis.area_tag, null)
        isis                                    = try(int.isis, null) != null ? true : false
        isis_network_point_to_point             = try(int.isis.network_point_to_point, null)
        isis_ipv4_metric_levels = try(length(int.isis.ipv4_metric_levels) == 0, true) ? null : [for level in int.isis.ipv4_metric_levels : {
          level = try(level.level, null)
          value = try(level.value, null)
        }]
        auto_qos_classify             = try(int.auto_qos.classify, null)
        auto_qos_classify_police      = try(int.auto_qos.classify_police, null)
        auto_qos_trust                = try(int.auto_qos.trust, null)
        auto_qos_trust_cos            = try(int.auto_qos.trust_cos, null)
        auto_qos_trust_dscp           = try(int.auto_qos.trust_dscp, null)
        auto_qos_video_cts            = try(int.auto_qos.video_cts, null)
        auto_qos_video_ip_camera      = try(int.auto_qos.video_ip_camera, null)
        auto_qos_video_media_player   = try(int.auto_qos.video_media_player, null)
        auto_qos_voip_cisco_phone     = try(int.auto_qos.voip_cisco_phone, null)
        auto_qos_voip_cisco_softphone = try(int.auto_qos.voip_cisco_softphone, null)
        auto_qos_voip_trust           = try(int.auto_qos.voip_trust, null)
        trust_device                  = try(int.auto_qos.trust_device, null)
        negotiation_auto              = try(int.negotiation_auto, null)
        evpn_ethernet_segments = try(length(int.evpn_ethernet_segments) == 0, true) ? null : [for es in int.evpn_ethernet_segments : {
          es_value = try(es.es_value, null)
        }]
        evpn_ethernet_segments_legacy = try(length(int.evpn_ethernet_segments_legacy) == 0, true) ? null : [for es in int.evpn_ethernet_segments_legacy : {
          es_value = try(es.es_value, null)
        }]
      }
    ]
  ])
}

resource "iosxe_interface_port_channel" "port_channel" {
  for_each = { for v in local.interfaces_port_channels : v.key => v }

  device                                   = each.value.device
  name                                     = each.value.name
  description                              = each.value.description
  shutdown                                 = each.value.shutdown
  mtu                                      = each.value.mtu
  vrf_forwarding                           = each.value.vrf_forwarding
  ipv4_address                             = each.value.ipv4_address
  ipv4_address_mask                        = each.value.ipv4_address_mask
  ipv4_address_dhcp                        = each.value.ipv4_address_dhcp
  ip_proxy_arp                             = each.value.ip_proxy_arp
  ip_dhcp_relay_source_interface           = each.value.ip_dhcp_relay_source_interface
  ip_access_group_in_enable                = each.value.ip_access_group_in_enable
  ip_access_group_in                       = each.value.ip_access_group_in
  ip_access_group_out_enable               = each.value.ip_access_group_out_enable
  ip_access_group_out                      = each.value.ip_access_group_out
  ip_flow_monitors                         = each.value.ip_flow_monitors
  ip_redirects                             = each.value.ip_redirects
  ip_unreachables                          = each.value.ip_unreachables
  ip_nat_inside                            = each.value.ip_nat_inside
  ip_nat_outside                           = each.value.ip_nat_outside
  zone_member_security                     = each.value.zone_member_security
  ip_igmp_version                          = each.value.ip_igmp_version
  ip_arp_inspection_trust                  = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate             = each.value.ip_arp_inspection_limit_rate
  ip_dhcp_snooping_trust                   = each.value.ip_dhcp_snooping_trust
  helper_addresses                         = each.value.helper_addresses
  ipv6_enable                              = each.value.ipv6_enable
  ipv6_mtu                                 = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all                  = each.value.ipv6_nd_ra_suppress_all
  ipv6_address_dhcp                        = each.value.ipv6_address_dhcp
  ipv6_addresses                           = each.value.ipv6_addresses
  ipv6_link_local_addresses                = each.value.ipv6_link_local_addresses
  ipv6_address_autoconfig_default          = each.value.ipv6_address_autoconfig_default
  ipv6_flow_monitors                       = each.value.ipv6_flow_monitors
  bfd_template                             = each.value.bfd_template
  bfd_enable                               = each.value.bfd_enable
  bfd_local_address                        = each.value.bfd_local_address
  bfd_interval                             = each.value.bfd_interval
  bfd_interval_min_rx                      = each.value.bfd_interval_min_rx
  bfd_interval_multiplier                  = each.value.bfd_interval_multiplier
  bfd_echo                                 = each.value.bfd_echo
  spanning_tree_guard                      = each.value.spanning_tree_guard
  spanning_tree_link_type                  = each.value.spanning_tree_link_type
  spanning_tree_portfast                   = each.value.spanning_tree_portfast
  spanning_tree_portfast_disable           = each.value.spanning_tree_portfast_disable
  spanning_tree_portfast_trunk             = each.value.spanning_tree_portfast_trunk
  spanning_tree_portfast_edge              = each.value.spanning_tree_portfast_edge
  bpduguard_enable                         = each.value.bpduguard_enable
  bpduguard_disable                        = each.value.bpduguard_disable
  arp_timeout                              = each.value.arp_timeout
  load_interval                            = each.value.load_interval
  snmp_trap_link_status                    = each.value.snmp_trap_link_status
  logging_event_link_status_enable         = each.value.logging_event_link_status_enable
  switchport                               = each.value.switchport
  auto_qos_classify                        = each.value.auto_qos_classify
  auto_qos_classify_police                 = each.value.auto_qos_classify_police
  auto_qos_trust                           = each.value.auto_qos_trust
  auto_qos_trust_cos                       = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp                      = each.value.auto_qos_trust_dscp
  auto_qos_video_cts                       = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera                 = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player              = each.value.auto_qos_video_media_player
  auto_qos_voip_cisco_phone                = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone            = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust                      = each.value.auto_qos_voip_trust
  trust_device                             = each.value.trust_device
  negotiation_auto                         = each.value.negotiation_auto
  evpn_ethernet_segments                   = each.value.evpn_ethernet_segments
  evpn_ethernet_segments_legacy            = each.value.evpn_ethernet_segments_legacy
  ip_router_isis                           = each.value.isis_area_tag
  ip_verify_unicast_source_reachable_via   = each.value.ip_verify_unicast_source_reachable_via
  ip_verify_unicast_source_allow_self_ping = each.value.ip_verify_unicast_source_allow_self_ping
  ip_verify_unicast_source_allow_default   = each.value.ip_verify_unicast_source_allow_default

  depends_on = [
    iosxe_zone_security.zone_security,
    iosxe_evpn_ethernet_segment.evpn_ethernet_segment,
    iosxe_flow_monitor.flow_monitor,
    iosxe_isis.isis
  ]
}

resource "iosxe_interface_switchport" "port_channel_switchport" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.switchport == true || v.switchport_mode != null }

  device                        = each.value.device
  type                          = "Port-channel"
  name                          = each.value.name
  mode_access                   = each.value.switchport_mode_access
  mode_trunk                    = each.value.switchport_mode_trunk
  mode_dot1q_tunnel             = each.value.switchport_mode_dot1q_tunnel
  mode_private_vlan_trunk       = each.value.switchport_mode_private_vlan_trunk
  mode_private_vlan_host        = each.value.switchport_mode_private_vlan_host
  mode_private_vlan_promiscuous = each.value.switchport_mode_private_vlan_promiscuous
  nonegotiate                   = each.value.switchport_nonegotiate
  access_vlan                   = each.value.switchport_access_vlan
  voice_vlan                    = each.value.switchport_voice_vlan
  # NEW v2 trunk allowed VLANs
  trunk_allowed_vlans        = each.value.switchport_trunk_allowed_vlans
  trunk_allowed_vlans_none   = each.value.switchport_trunk_allowed_vlans_none
  trunk_allowed_vlans_all    = each.value.switchport_trunk_allowed_vlans_all
  trunk_allowed_vlans_except = each.value.switchport_trunk_allowed_vlans_except
  trunk_allowed_vlans_remove = each.value.switchport_trunk_allowed_vlans_remove
  trunk_allowed_vlans_add    = each.value.switchport_trunk_allowed_vlans_add != null ? [{ vlans = each.value.switchport_trunk_allowed_vlans_add }] : null
  # LEGACY trunk allowed VLANs (deprecated)
  trunk_allowed_vlans_legacy      = each.value.switchport_trunk_allowed_vlans_legacy
  trunk_allowed_vlans_none_legacy = each.value.switchport_trunk_allowed_vlans_none_legacy
  trunk_native_vlan_tag           = each.value.switchport_trunk_native_vlan_tag
  trunk_native_vlan               = each.value.switchport_trunk_native_vlan
  host                            = each.value.switchport_host

  depends_on = [
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_mpls" "port_channel_mpls" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.mpls }

  device = each.value.device
  type   = "Port-channel"
  name   = each.value.name
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_ospf" "port_channel_ospf" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = "Port-channel"
  name                             = each.value.name
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  mtu_ignore                       = each.value.ospf_mtu_ignore
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  ttl_security_hops                = each.value.ospf_ttl_security_hops
  process_ids                      = each.value.ospf_process_ids
  message_digest_keys              = each.value.ospf_message_digest_keys
  multi_area_ids                   = each.value.ospf_multi_area_ids

  depends_on = [
    iosxe_interface_port_channel.port_channel,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "port_channel_ospfv3" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = "Port-channel"
  name                             = each.value.name
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_pim" "port_channel_pim" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.pim }

  device            = each.value.device
  type              = "Port-channel"
  name              = each.value.name
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_pim_ipv6" "port_channel_pim_ipv6" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.ipv6_pim }

  device      = each.value.device
  type        = "Port-channel"
  name        = each.value.name
  pim         = each.value.ipv6_pim_pim
  bfd         = each.value.ipv6_pim_bfd
  bsr_border  = each.value.ipv6_pim_bsr_border
  dr_priority = each.value.ipv6_pim_dr_priority

  depends_on = [
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_isis" "port_channel_isis" {
  for_each = { for v in local.interfaces_port_channels : v.key => v if v.isis }

  device                 = each.value.device
  type                   = "Port-channel"
  name                   = each.value.name
  network_point_to_point = each.value.isis_network_point_to_point
  ipv4_metric_levels     = each.value.isis_ipv4_metric_levels

  depends_on = [
    iosxe_interface_port_channel.port_channel,
    iosxe_isis.isis
  ]
}

##### PORT-CHANNEL SUBINTERFACES #####

locals {
  interfaces_port_channel_subinterfaces = flatten([
    for device in local.devices : [
      for pc in try(local.device_config[device.name].interfaces.port_channels, []) : [
        for sub in try(pc.subinterfaces, []) : {
          key                          = format("%s/Port-channel%s", device.name, trimprefix(sub.id, "$string "))
          device                       = device.name
          name                         = trimprefix(sub.id, "$string ")
          description                  = try(sub.description, null)
          shutdown                     = try(sub.shutdown, null)
          vrf_forwarding               = try(sub.vrf_forwarding, null)
          ipv4_address                 = try(sub.ipv4.address, null)
          ipv4_address_mask            = try(sub.ipv4.address_mask, null)
          ipv4_address_dhcp            = try(sub.ipv4.address_dhcp, null)
          ip_proxy_arp                 = try(sub.ipv4.proxy_arp, null)
          ip_arp_inspection_trust      = try(sub.ipv4.arp_inspection_trust, null)
          ip_arp_inspection_limit_rate = try(sub.ipv4.arp_inspection_limit_rate, null)
          helper_addresses = try(length(sub.ipv4.helper_addresses) == 0, true) ? null : [for ha in sub.ipv4.helper_addresses : {
            address = try(ha.address, null)
            global  = try(ha.global, null)
            vrf     = try(ha.vrf, null)
          }]
          ip_mtu                     = try(sub.ip_mtu, null)
          ip_access_group_in         = try(sub.ipv4.access_group_in, null)
          ip_access_group_in_enable  = try(sub.ipv4.access_group_in, null) != null ? true : null
          ip_access_group_out        = try(sub.ipv4.access_group_out, null)
          ip_access_group_out_enable = try(sub.ipv4.access_group_out, null) != null ? true : null
          ip_flow_monitors = try(length(sub.ipv4.flow_monitors) == 0, true) ? null : [for fm in sub.ipv4.flow_monitors : {
            name      = try(fm.name, null)
            direction = try(fm.direction, null)
          }]
          ip_redirects         = try(sub.ipv4.redirects, null)
          ip_unreachables      = try(sub.ipv4.unreachables, null)
          ip_nat_inside        = try(sub.ipv4.nat_inside, null)
          ip_nat_outside       = try(sub.ipv4.nat_outside, null)
          zone_member_security = try(sub.zone_member_security, null)
          ipv6_enable          = try(sub.ipv6.enable, null)
          ipv6_addresses = try(length(sub.ipv6.addresses) == 0, true) ? null : [for addr in sub.ipv6.addresses : {
            prefix = try(addr.prefix, null)
            eui_64 = try(addr.eui_64, null)
          }]
          ipv6_link_local_addresses = try(length(sub.ipv6.link_local_addresses) == 0, true) ? null : [for addr in sub.ipv6.link_local_addresses : {
            address    = addr
            link_local = true
          }]
          ipv6_address_autoconfig_default = try(sub.ipv6.address_autoconfig_default, null)
          ipv6_address_dhcp               = try(sub.ipv6.address_dhcp, null)
          ipv6_mtu                        = try(sub.ipv6.mtu, null)
          ipv6_nd_ra_suppress_all         = try(sub.ipv6.nd_ra_suppress_all, null)
          ipv6_flow_monitors = try(length(sub.ipv6.flow_monitors) == 0, true) ? null : [for fm in sub.ipv6.flow_monitors : {
            name      = try(fm.name, null)
            direction = try(fm.direction, null)
          }]
          bfd_enable                            = try(sub.bfd.enable, null)
          bfd_template                          = try(sub.bfd.template, null)
          bfd_local_address                     = try(sub.bfd.local_address, null)
          bfd_interval                          = try(sub.bfd.interval, null)
          bfd_interval_min_rx                   = try(sub.bfd.interval_min_rx, null)
          bfd_interval_multiplier               = try(sub.bfd.interval_multiplier, null)
          bfd_echo                              = try(sub.bfd.echo, null)
          encapsulation_dot1q_vlan_id           = try(sub.encapsulation_dot1q_vlan_id, null)
          arp_timeout                           = try(sub.arp_timeout, null)
          auto_qos_classify                     = try(sub.auto_qos.classify, null)
          auto_qos_classify_police              = try(sub.auto_qos.classify_police, null)
          auto_qos_trust                        = try(sub.auto_qos.trust, null)
          auto_qos_trust_cos                    = try(sub.auto_qos.trust_cos, null)
          auto_qos_trust_dscp                   = try(sub.auto_qos.trust_dscp, null)
          auto_qos_video_cts                    = try(sub.auto_qos.video_cts, null)
          auto_qos_video_ip_camera              = try(sub.auto_qos.video_ip_camera, null)
          auto_qos_video_media_player           = try(sub.auto_qos.video_media_player, null)
          auto_qos_voip_cisco_phone             = try(sub.auto_qos.voip_cisco_phone, null)
          auto_qos_voip_cisco_softphone         = try(sub.auto_qos.voip_cisco_softphone, null)
          auto_qos_voip_trust                   = try(sub.auto_qos.voip_trust, null)
          trust_device                          = try(sub.auto_qos.trust_device, null)
          mpls_ip                               = try(sub.mpls.ip, null)
          mpls_mtu                              = try(sub.mpls.mtu, null)
          ospf_authentication_key_chain         = try(sub.ospf.authentication_key_chain, null)
          ospf_authentication_message_digest    = try(sub.ospf.authentication_message_digest, null)
          ospf_authentication_null              = try(sub.ospf.authentication_null, null)
          ospf_cost                             = try(sub.ospf.cost, null)
          ospf_dead_interval                    = try(sub.ospf.dead_interval, null)
          ospf_hello_interval                   = try(sub.ospf.hello_interval, null)
          ospf_mtu_ignore                       = try(sub.ospf.mtu_ignore, null)
          ospf                                  = try(sub.ospf, null) != null ? true : false
          ospf_network_type_broadcast           = try(sub.ospf.network_type, null) == "broadcast" ? true : null
          ospf_network_type_non_broadcast       = try(sub.ospf.network_type, null) == "non-broadcast" ? true : null
          ospf_network_type_point_to_multipoint = try(sub.ospf.network_type, null) == "point-to-multipoint" ? true : null
          ospf_network_type_point_to_point      = try(sub.ospf.network_type, null) == "point-to-point" ? true : null
          ospf_priority                         = try(sub.ospf.priority, null)
          ospf_ttl_security_hops                = try(sub.ospf.ttl_security_hops, null)
          ospf_process_ids = try(length(sub.ospf.process_ids) == 0, true) ? null : [for pid in sub.ospf.process_ids : {
            id = try(pid.id, null)
            areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
              area_id = area
            }]
          }]
          ospf_message_digest_keys = try(length(sub.ospf.message_digest_keys) == 0, true) ? null : [for key in sub.ospf.message_digest_keys : {
            id            = try(key.id, null)
            md5_auth_key  = try(key.md5_auth_key, null)
            md5_auth_type = try(key.md5_auth_type, null)
          }]
          ospf_multi_area_ids = try(length(sub.ospf.multi_area_ids) == 0, true) ? null : [for area in sub.ospf.multi_area_ids : {
            area_id = area
          }]
          ospfv3                                  = try(sub.ospfv3, null) != null ? true : false
          ospfv3_network_type_broadcast           = try(sub.ospfv3.network_type, null) == "broadcast" ? true : null
          ospfv3_network_type_non_broadcast       = try(sub.ospfv3.network_type, null) == "non-broadcast" ? true : null
          ospfv3_network_type_point_to_multipoint = try(sub.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
          ospfv3_network_type_point_to_point      = try(sub.ospfv3.network_type, null) == "point-to-point" ? true : null
          ospfv3_cost                             = try(sub.ospfv3.cost, null)
          ospfv3_bfd                              = try(sub.ospfv3.bfd, null)
          ospfv3_dead_interval                    = try(sub.ospfv3.dead_interval, null)
          ospfv3_hello_interval                   = try(sub.ospfv3.hello_interval, null)
          ospfv3_mtu_ignore                       = try(sub.ospfv3.mtu_ignore, null)
          ospfv3_priority                         = try(sub.ospfv3.priority, null)
          pim                                     = try(sub.pim.passive, sub.pim.dense_mode, sub.pim.sparse_mode, sub.pim.sparse_dense_mode, null) != null ? true : false
          pim_passive                             = try(sub.pim.passive, null)
          pim_dense_mode                          = try(sub.pim.dense_mode, null)
          pim_sparse_mode                         = try(sub.pim.sparse_mode, null)
          pim_sparse_dense_mode                   = try(sub.pim.sparse_dense_mode, null)
          pim_bfd                                 = try(sub.pim.bfd, null)
          pim_border                              = try(sub.pim.border, null)
          pim_bsr_border                          = try(sub.pim.bsr_border, null)
          pim_dr_priority                         = try(sub.pim.dr_priority, null)
          ip_igmp_version                         = try(sub.igmp.version, null)
          isis_area_tag                           = try(sub.isis.area_tag, null)
          isis                                    = try(sub.isis, null) != null ? true : false
          isis_network_point_to_point             = try(sub.isis.network_point_to_point, null)
          isis_ipv4_metric_levels = try(length(sub.isis.ipv4_metric_levels) == 0, true) ? null : [for level in sub.isis.ipv4_metric_levels : {
            level = try(level.level, null)
            value = try(level.value, null)
          }]
        }
      ]
    ]
  ])
}

resource "iosxe_interface_port_channel_subinterface" "port_channel_subinterface" {
  for_each = { for v in local.interfaces_port_channel_subinterfaces : v.key => v }
  device   = each.value.device

  name                            = each.value.name
  encapsulation_dot1q_vlan_id     = each.value.encapsulation_dot1q_vlan_id
  description                     = each.value.description
  shutdown                        = each.value.shutdown
  ip_proxy_arp                    = each.value.ip_proxy_arp
  ip_redirects                    = each.value.ip_redirects
  ip_unreachables                 = each.value.ip_unreachables
  ip_mtu                          = each.value.ip_mtu
  ip_nat_inside                   = each.value.ip_nat_inside
  ip_nat_outside                  = each.value.ip_nat_outside
  zone_member_security            = each.value.zone_member_security
  vrf_forwarding                  = each.value.vrf_forwarding
  ipv4_address                    = each.value.ipv4_address
  ipv4_address_mask               = each.value.ipv4_address_mask
  ipv4_address_dhcp               = each.value.ipv4_address_dhcp
  ip_access_group_in_enable       = each.value.ip_access_group_in_enable
  ip_access_group_in              = each.value.ip_access_group_in
  ip_access_group_out_enable      = each.value.ip_access_group_out_enable
  ip_access_group_out             = each.value.ip_access_group_out
  ip_flow_monitors                = each.value.ip_flow_monitors
  ip_igmp_version                 = each.value.ip_igmp_version
  helper_addresses                = each.value.helper_addresses
  bfd_template                    = each.value.bfd_template
  bfd_enable                      = each.value.bfd_enable
  bfd_local_address               = each.value.bfd_local_address
  bfd_interval                    = each.value.bfd_interval
  bfd_interval_min_rx             = each.value.bfd_interval_min_rx
  bfd_interval_multiplier         = each.value.bfd_interval_multiplier
  bfd_echo                        = each.value.bfd_echo
  ipv6_enable                     = each.value.ipv6_enable
  ipv6_mtu                        = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all         = each.value.ipv6_nd_ra_suppress_all
  ipv6_address_dhcp               = each.value.ipv6_address_dhcp
  ipv6_link_local_addresses       = each.value.ipv6_link_local_addresses
  ipv6_addresses                  = each.value.ipv6_addresses
  ipv6_address_autoconfig_default = each.value.ipv6_address_autoconfig_default
  ipv6_flow_monitors              = each.value.ipv6_flow_monitors
  arp_timeout                     = each.value.arp_timeout
  auto_qos_classify               = each.value.auto_qos_classify
  auto_qos_classify_police        = each.value.auto_qos_classify_police
  auto_qos_trust                  = each.value.auto_qos_trust
  auto_qos_trust_cos              = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp             = each.value.auto_qos_trust_dscp
  auto_qos_video_cts              = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera        = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player     = each.value.auto_qos_video_media_player
  auto_qos_voip_cisco_phone       = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone   = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust             = each.value.auto_qos_voip_trust
  trust_device                    = each.value.trust_device
  ip_arp_inspection_trust         = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate    = each.value.ip_arp_inspection_limit_rate
  ip_router_isis                  = each.value.isis_area_tag

  depends_on = [
    iosxe_interface_port_channel.port_channel,
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_flow_monitor.flow_monitor,
    iosxe_policy_map.policy_map,
    iosxe_isis.isis
  ]
}

resource "iosxe_interface_mpls" "port_channel_subinterface_mpls" {
  for_each = { for v in local.interfaces_port_channel_subinterfaces : v.key => v if v.mpls_ip == true || v.mpls_mtu != null }

  device = each.value.device
  type   = "Port-channel-subinterface/Port-channel"
  name   = each.value.name
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}

resource "iosxe_interface_ospf" "port_channel_subinterface_ospf" {
  for_each = { for v in local.interfaces_port_channel_subinterfaces : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = "Port-channel-subinterface/Port-channel"
  name                             = each.value.name
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  mtu_ignore                       = each.value.ospf_mtu_ignore
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  ttl_security_hops                = each.value.ospf_ttl_security_hops
  process_ids                      = each.value.ospf_process_ids
  message_digest_keys              = each.value.ospf_message_digest_keys
  multi_area_ids                   = each.value.ospf_multi_area_ids

  depends_on = [
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "port_channel_subinterface_ospfv3" {
  for_each = { for v in local.interfaces_port_channel_subinterfaces : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = "Port-channel-subinterface/Port-channel"
  name                             = each.value.name
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_pim" "port_channel_subinterface_pim" {
  for_each = { for v in local.interfaces_port_channel_subinterfaces : v.key => v if v.pim }

  device            = each.value.device
  type              = "Port-channel-subinterface/Port-channel"
  name              = each.value.name
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}

resource "iosxe_interface_isis" "port_channel_subinterface_isis" {
  for_each = { for v in local.interfaces_port_channel_subinterfaces : v.key => v if v.isis }

  device                 = each.value.device
  type                   = "Port-channel-subinterface/Port-channel"
  name                   = each.value.name
  network_point_to_point = each.value.isis_network_point_to_point
  ipv4_metric_levels     = each.value.isis_ipv4_metric_levels

  depends_on = [
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_isis.isis
  ]
}

##### ETHERNET SUBINTERFACES #####

locals {
  interfaces_ethernet_subinterfaces = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.ethernets, []) : [
        for sub in try(int.subinterfaces, []) : {
          key                          = format("%s/%s%s", device.name, try(int.type, null), trimprefix(sub.id, "$string "))
          device                       = device.name
          type                         = try(int.type, null)
          name                         = trimprefix(sub.id, "$string ")
          description                  = try(sub.description, null)
          shutdown                     = try(sub.shutdown, null)
          vrf_forwarding               = try(sub.vrf_forwarding, null)
          ipv4_address                 = try(sub.ipv4.address, null)
          ipv4_address_mask            = try(sub.ipv4.address_mask, null)
          ipv4_address_dhcp            = try(sub.ipv4.address_dhcp, null)
          ip_proxy_arp                 = try(sub.ipv4.proxy_arp, null)
          ip_arp_inspection_trust      = try(sub.ipv4.arp_inspection_trust, null)
          ip_arp_inspection_limit_rate = try(sub.ipv4.arp_inspection_limit_rate, null)
          helper_addresses = try(length(sub.ipv4.helper_addresses) == 0, true) ? null : [for ha in sub.ipv4.helper_addresses : {
            address = try(ha.address, null)
            global  = try(ha.global, null)
            vrf     = try(ha.vrf, null)
          }]
          ip_access_group_in         = try(sub.ipv4.access_group_in, null)
          ip_access_group_in_enable  = try(sub.ipv4.access_group_in, null) != null ? true : null
          ip_access_group_out        = try(sub.ipv4.access_group_out, null)
          ip_access_group_out_enable = try(sub.ipv4.access_group_out, null) != null ? true : null
          ip_flow_monitors = try(length(sub.ipv4.flow_monitors) == 0, true) ? null : [for fm in sub.ipv4.flow_monitors : {
            name      = try(fm.name, null)
            direction = try(fm.direction, null)
          }]
          ip_redirects         = try(sub.ipv4.redirects, null)
          ip_unreachables      = try(sub.ipv4.unreachables, null)
          ip_nat_inside        = try(sub.ipv4.nat_inside, null)
          ip_nat_outside       = try(sub.ipv4.nat_outside, null)
          zone_member_security = try(sub.zone_member_security, null)
          ipv6_enable          = try(sub.ipv6.enable, null)
          ipv6_addresses = try(length(sub.ipv6.addresses) == 0, true) ? null : [for addr in sub.ipv6.addresses : {
            prefix = try(addr.prefix, null)
            eui_64 = try(addr.eui_64, null)
          }]
          ipv6_link_local_addresses = try(length(sub.ipv6.link_local_addresses) == 0, true) ? null : [for addr in sub.ipv6.link_local_addresses : {
            address    = addr
            link_local = true
          }]
          ipv6_address_autoconfig_default = try(sub.ipv6.address_autoconfig_default, null)
          ipv6_address_dhcp               = try(sub.ipv6.address_dhcp, null)
          ipv6_mtu                        = try(sub.ipv6.mtu, null)
          ipv6_nd_ra_suppress_all         = try(sub.ipv6.nd_ra_suppress_all, null)
          ipv6_flow_monitors = try(length(sub.ipv6.flow_monitors) == 0, true) ? null : [for fm in sub.ipv6.flow_monitors : {
            name      = try(fm.name, null)
            direction = try(fm.direction, null)
          }]
          bfd_enable                            = try(sub.bfd.enable, null)
          bfd_template                          = try(sub.bfd.template, null)
          bfd_local_address                     = try(sub.bfd.local_address, null)
          bfd_interval                          = try(sub.bfd.interval, null)
          bfd_interval_min_rx                   = try(sub.bfd.interval_min_rx, null)
          bfd_interval_multiplier               = try(sub.bfd.interval_multiplier, null)
          bfd_echo                              = try(sub.bfd.echo, null)
          encapsulation_dot1q_vlan_id           = try(sub.encapsulation_dot1q_vlan_id, null)
          arp_timeout                           = try(sub.arp_timeout, null)
          auto_qos_classify                     = try(sub.auto_qos.classify, null)
          auto_qos_classify_police              = try(sub.auto_qos.classify_police, null)
          auto_qos_trust                        = try(sub.auto_qos.trust, null)
          auto_qos_trust_cos                    = try(sub.auto_qos.trust_cos, null)
          auto_qos_trust_dscp                   = try(sub.auto_qos.trust_dscp, null)
          auto_qos_video_cts                    = try(sub.auto_qos.video_cts, null)
          auto_qos_video_ip_camera              = try(sub.auto_qos.video_ip_camera, null)
          auto_qos_video_media_player           = try(sub.auto_qos.video_media_player, null)
          auto_qos_voip_cisco_phone             = try(sub.auto_qos.voip_cisco_phone, null)
          auto_qos_voip_cisco_softphone         = try(sub.auto_qos.voip_cisco_softphone, null)
          auto_qos_voip_trust                   = try(sub.auto_qos.voip_trust, null)
          trust_device                          = try(sub.auto_qos.trust_device, null)
          mpls_ip                               = try(sub.mpls.ip, null)
          mpls_mtu                              = try(sub.mpls.mtu, null)
          ospf_cost                             = try(sub.ospf.cost, null)
          ospf_dead_interval                    = try(sub.ospf.dead_interval, null)
          ospf_hello_interval                   = try(sub.ospf.hello_interval, null)
          ospf_mtu_ignore                       = try(sub.ospf.mtu_ignore, null)
          ospf                                  = try(sub.ospf, null) != null ? true : false
          ospf_network_type_broadcast           = try(sub.ospf.network_type, null) == "broadcast" ? true : null
          ospf_network_type_non_broadcast       = try(sub.ospf.network_type, null) == "non-broadcast" ? true : null
          ospf_network_type_point_to_multipoint = try(sub.ospf.network_type, null) == "point-to-multipoint" ? true : null
          ospf_network_type_point_to_point      = try(sub.ospf.network_type, null) == "point-to-point" ? true : null
          ospf_priority                         = try(sub.ospf.priority, null)
          ospf_ttl_security_hops                = try(sub.ospf.ttl_security_hops, null)
          ospf_process_ids = try(length(sub.ospf.process_ids) == 0, true) ? null : [for pid in sub.ospf.process_ids : {
            id = try(pid.id, null)
            areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
              area_id = area
            }]
          }]
          ospf_message_digest_keys = try(length(sub.ospf.message_digest_keys) == 0, true) ? null : [for key in sub.ospf.message_digest_keys : {
            id            = try(key.id, null)
            md5_auth_key  = try(key.md5_auth_key, null)
            md5_auth_type = try(key.md5_auth_type, null)
          }]
          ospf_multi_area_ids = try(length(sub.ospf.multi_area_ids) == 0, true) ? null : [for area in sub.ospf.multi_area_ids : {
            area_id = area
          }]
          ospfv3                                  = try(sub.ospfv3, null) != null ? true : false
          ospfv3_network_type_broadcast           = try(sub.ospfv3.network_type, null) == "broadcast" ? true : null
          ospfv3_network_type_non_broadcast       = try(sub.ospfv3.network_type, null) == "non-broadcast" ? true : null
          ospfv3_network_type_point_to_multipoint = try(sub.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
          ospfv3_network_type_point_to_point      = try(sub.ospfv3.network_type, null) == "point-to-point" ? true : null
          ospfv3_cost                             = try(sub.ospfv3.cost, null)
          ospfv3_bfd                              = try(sub.ospfv3.bfd, null)
          ospfv3_dead_interval                    = try(sub.ospfv3.dead_interval, null)
          ospfv3_hello_interval                   = try(sub.ospfv3.hello_interval, null)
          ospfv3_mtu_ignore                       = try(sub.ospfv3.mtu_ignore, null)
          ospfv3_priority                         = try(sub.ospfv3.priority, null)
          pim                                     = try(sub.pim.passive, sub.pim.dense_mode, sub.pim.sparse_mode, sub.pim.sparse_dense_mode, null) != null ? true : false
          pim_passive                             = try(sub.pim.passive, null)
          pim_dense_mode                          = try(sub.pim.dense_mode, null)
          pim_sparse_mode                         = try(sub.pim.sparse_mode, null)
          pim_sparse_dense_mode                   = try(sub.pim.sparse_dense_mode, null)
          pim_bfd                                 = try(sub.pim.bfd, null)
          pim_border                              = try(sub.pim.border, null)
          pim_bsr_border                          = try(sub.pim.bsr_border, null)
          pim_dr_priority                         = try(sub.pim.dr_priority, null)
          ip_igmp_version                         = try(sub.igmp.version, null)
          isis_area_tag                           = try(sub.isis.area_tag, null)
          isis                                    = try(sub.isis, null) != null ? true : false
          isis_network_point_to_point             = try(sub.isis.network_point_to_point, null)
          isis_ipv4_metric_levels = try(length(sub.isis.ipv4_metric_levels) == 0, true) ? null : [for level in sub.isis.ipv4_metric_levels : {
            level = try(level.level, null)
            value = try(level.value, null)
          }]
        }
      ]
    ]
  ])
}

resource "iosxe_interface_ethernet" "ethernet_subinterface" {
  for_each = { for v in local.interfaces_ethernet_subinterfaces : v.key => v }
  device   = each.value.device

  type                            = each.value.type
  name                            = each.value.name
  encapsulation_dot1q_vlan_id     = each.value.encapsulation_dot1q_vlan_id
  description                     = each.value.description
  shutdown                        = each.value.shutdown
  ip_proxy_arp                    = each.value.ip_proxy_arp
  ip_redirects                    = each.value.ip_redirects
  ip_unreachables                 = each.value.ip_unreachables
  ip_nat_inside                   = each.value.ip_nat_inside
  ip_nat_outside                  = each.value.ip_nat_outside
  zone_member_security            = each.value.zone_member_security
  vrf_forwarding                  = each.value.vrf_forwarding
  ipv4_address                    = each.value.ipv4_address
  ipv4_address_mask               = each.value.ipv4_address_mask
  ipv4_address_dhcp               = each.value.ipv4_address_dhcp
  ip_access_group_in_enable       = each.value.ip_access_group_in_enable
  ip_access_group_in              = each.value.ip_access_group_in
  ip_access_group_out_enable      = each.value.ip_access_group_out_enable
  ip_access_group_out             = each.value.ip_access_group_out
  ip_flow_monitors                = each.value.ip_flow_monitors
  ip_igmp_version                 = each.value.ip_igmp_version
  helper_addresses                = each.value.helper_addresses
  bfd_template                    = each.value.bfd_template
  bfd_enable                      = each.value.bfd_enable
  bfd_local_address               = each.value.bfd_local_address
  bfd_interval                    = each.value.bfd_interval
  bfd_interval_min_rx             = each.value.bfd_interval_min_rx
  bfd_interval_multiplier         = each.value.bfd_interval_multiplier
  bfd_echo                        = each.value.bfd_echo
  ipv6_enable                     = each.value.ipv6_enable
  ipv6_mtu                        = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all         = each.value.ipv6_nd_ra_suppress_all
  ipv6_address_dhcp               = each.value.ipv6_address_dhcp
  ipv6_link_local_addresses       = each.value.ipv6_link_local_addresses
  ipv6_addresses                  = each.value.ipv6_addresses
  ipv6_address_autoconfig_default = each.value.ipv6_address_autoconfig_default
  ipv6_flow_monitors              = each.value.ipv6_flow_monitors
  arp_timeout                     = each.value.arp_timeout
  auto_qos_classify               = each.value.auto_qos_classify
  auto_qos_classify_police        = each.value.auto_qos_classify_police
  auto_qos_trust                  = each.value.auto_qos_trust
  auto_qos_trust_cos              = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp             = each.value.auto_qos_trust_dscp
  auto_qos_video_cts              = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera        = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player     = each.value.auto_qos_video_media_player
  auto_qos_voip_cisco_phone       = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone   = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust             = each.value.auto_qos_voip_trust
  trust_device                    = each.value.trust_device
  ip_arp_inspection_trust         = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate    = each.value.ip_arp_inspection_limit_rate
  ip_router_isis                  = each.value.isis_area_tag

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_flow_monitor.flow_monitor,
    iosxe_policy_map.policy_map,
    iosxe_isis.isis
  ]
}

resource "iosxe_interface_mpls" "ethernet_subinterface_mpls" {
  for_each = { for v in local.interfaces_ethernet_subinterfaces : v.key => v if v.mpls_ip == true || v.mpls_mtu != null }

  device = each.value.device
  type   = each.value.type
  name   = each.value.name
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_ethernet.ethernet_subinterface
  ]
}

resource "iosxe_interface_ospf" "ethernet_subinterface_ospf" {
  for_each = { for v in local.interfaces_ethernet_subinterfaces : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.name
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  mtu_ignore                       = each.value.ospf_mtu_ignore
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  ttl_security_hops                = each.value.ospf_ttl_security_hops
  process_ids                      = each.value.ospf_process_ids
  message_digest_keys              = each.value.ospf_message_digest_keys
  multi_area_ids                   = each.value.ospf_multi_area_ids

  depends_on = [
    iosxe_interface_ethernet.ethernet_subinterface,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "ethernet_subinterface_ospfv3" {
  for_each = { for v in local.interfaces_ethernet_subinterfaces : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.name
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_ethernet.ethernet_subinterface,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_pim" "ethernet_subinterface_pim" {
  for_each = { for v in local.interfaces_ethernet_subinterfaces : v.key => v if v.pim }

  device            = each.value.device
  type              = each.value.type
  name              = each.value.name
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_ethernet.ethernet_subinterface
  ]
}

resource "iosxe_interface_isis" "ethernet_subinterface_isis" {
  for_each = { for v in local.interfaces_ethernet_subinterfaces : v.key => v if v.isis }

  device                 = each.value.device
  type                   = each.value.type
  name                   = each.value.name
  network_point_to_point = each.value.isis_network_point_to_point
  ipv4_metric_levels     = each.value.isis_ipv4_metric_levels

  depends_on = [
    iosxe_interface_ethernet.ethernet_subinterface,
    iosxe_isis.isis
  ]
}

##### NVE #####

locals {
  nves = flatten([
    for device in local.devices : [
      for nve in try(local.device_config[device.name].interfaces.nves, []) : {
        key    = format("%s/%s", device.name, nve.id)
        device = device.name

        id                             = try(nve.id, null)
        description                    = try(nve.description, null)
        shutdown                       = try(nve.shutdown, null)
        host_reachability_protocol_bgp = try(nve.host_reachability_protocol_bgp, null)
        source_interface_loopback      = try(nve.source_interface_type, null) == "Loopback" ? try(nve.source_interface_id, null) : null

        # Lists
        vni_vrfs = try(length(nve.vni_vrfs) == 0, true) ? null : [for vni_vrf in nve.vni_vrfs : {
          vni_range = "${vni_vrf.vni_from}${try(vni_vrf.vni_to, null) != null ? format("-%s", vni_vrf.vni_to) : ""}"
          vrf       = try(vni_vrf.vrf, null)
          }
        ]

        vnis = try(length(nve.vnis) == 0, true) ? null : [for vni in nve.vnis : {
          vni_range            = "${vni.vni_from}${try(vni.vni_to, null) != null ? format("-%s", vni.vni_to) : ""}"
          ipv4_multicast_group = try(vni.ipv4_multicast_group, null)
          ingress_replication  = try(vni.ingress_replication, null)
          local_routing        = try(vni.local_routing, null)
          }
        ]
    }]
  ])
}

resource "iosxe_interface_nve" "nve" {
  for_each = { for e in local.nves : e.key => e }
  device   = each.value.device

  name                           = each.value.id
  description                    = each.value.description
  shutdown                       = each.value.shutdown
  host_reachability_protocol_bgp = each.value.host_reachability_protocol_bgp
  source_interface_loopback      = each.value.source_interface_loopback

  # Lists
  vnis     = each.value.vnis
  vni_vrfs = each.value.vni_vrfs

  depends_on = [iosxe_vrf.vrf]
}

##### TUNNELS #####

locals {
  interfaces_tunnels = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.tunnels, []) : {
        key                            = format("%s/Tunnel%s", device.name, int.name)
        device                         = device.name
        name                           = int.name
        description                    = try(int.description, null)
        shutdown                       = try(int.shutdown, null)
        vrf_forwarding                 = try(int.vrf_forwarding, null)
        ipv4_address                   = try(int.ipv4.address, null)
        ipv4_address_mask              = try(int.ipv4.address_mask, null)
        ipv4_address_dhcp              = try(int.ipv4.address_dhcp, null)
        ip_proxy_arp                   = try(int.ipv4.proxy_arp, null)
        ip_dhcp_relay_source_interface = try("${try(int.ipv4.dhcp_relay_source_interface_type, null)}${try(int.ipv4.dhcp_relay_source_interface_id, null)}", null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for ha in int.ipv4.helper_addresses : {
          address = try(ha.address, null)
          global  = try(ha.global, null)
          vrf     = try(ha.vrf, null)
        }]
        ip_access_group_in         = try(int.ipv4.access_group_in, null)
        ip_access_group_in_enable  = try(int.ipv4.access_group_in, null) != null ? true : null
        ip_access_group_out        = try(int.ipv4.access_group_out, null)
        ip_access_group_out_enable = try(int.ipv4.access_group_out, null) != null ? true : null
        ip_flow_monitors = try(length(int.ipv4.flow_monitors) == 0, true) ? null : [for fm in int.ipv4.flow_monitors : {
          name      = try(fm.name, null)
          direction = try(fm.direction, null)
        }]
        ip_redirects         = try(int.ipv4.redirects, null)
        ip_unreachables      = try(int.ipv4.unreachables, null)
        ip_nat_inside        = try(int.ipv4.nat_inside, null)
        ip_nat_outside       = try(int.ipv4.nat_outside, null)
        zone_member_security = try(int.zone_member_security, null)
        unnumbered           = try("${try(int.ipv4.unnumbered_interface_type, null)}${try(int.ipv4.unnumbered_interface_id, null)}", null)
        ipv6_enable          = try(int.ipv6.enable, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = try(addr.prefix, null)
          eui_64 = try(addr.eui_64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp               = try(int.ipv6.address_dhcp, null)
        ipv6_mtu                        = try(int.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all         = try(int.ipv6.nd_ra_suppress_all, null)
        ipv6_flow_monitors = try(length(int.ipv6.flow_monitors) == 0, true) ? null : [for fm in int.ipv6.flow_monitors : {
          name      = try(fm.name, null)
          direction = try(fm.direction, null)
        }]
        bfd_enable                      = try(int.bfd.enable, null)
        bfd_template                    = try(int.bfd.template, null)
        bfd_local_address               = try(int.bfd.local_address, null)
        bfd_interval                    = try(int.bfd.interval, null)
        bfd_interval_min_rx             = try(int.bfd.interval_min_rx, null)
        bfd_interval_multiplier         = try(int.bfd.interval_multiplier, null)
        bfd_echo                        = try(int.bfd.echo, null)
        tunnel_destination_ipv4         = try(int.tunnel_destination_ipv4, null)
        tunnel_source                   = try(int.tunnel_source, null)
        tunnel_vrf                      = try(int.tunnel_vrf, null)
        tunnel_mode_ipsec_ipv4          = try(int.tunnel_mode_ipsec_ipv4, null)
        tunnel_mode_gre_multipoint      = try(int.tunnel_mode_gre_multipoint, null)
        tunnel_protection_ipsec_profile = try(int.tunnel_protection_ipsec_profile, null)
        tunnel_key                      = try(int.tunnel_key, null)
        tunnel_bandwidth_transmit       = try(int.tunnel_bandwidth_transmit, null)
        tunnel_bandwidth_receive        = try(int.tunnel_bandwidth_receive, null)
        ip_nhrp_authentication          = try(int.ip_nhrp_authentication, null)
        ip_nhrp_network_id              = try(int.ip_nhrp_network_id, null)
        ip_nhrp_nhs = try(length(int.ip_nhrp_nhs) == 0, true) ? null : [for nhs in int.ip_nhrp_nhs : {
          ipv4 = try(nhs.ipv4, null)
        }]
        ip_nhrp_maps = try(length(int.ip_nhrp_maps) == 0, true) ? null : [for m in int.ip_nhrp_maps : {
          dest_ipv4 = try(m.dest_ipv4, null)
          nbma_ipv4 = try(m.nbma_ipv4, null)
        }]
        ip_nhrp_redirect                      = try(int.ip_nhrp_redirect, null)
        ip_nhrp_shortcut                      = try(int.ip_nhrp_shortcut, null)
        mpls_nhrp                             = try(int.mpls_nhrp, null)
        service_policy_input                  = try(int.service_policy_input, null)
        service_policy_output                 = try(int.service_policy_output, null)
        arp_timeout                           = try(int.arp_timeout, null)
        bandwidth                             = try(int.bandwidth, null)
        ip_mtu                                = try(int.ip_mtu, null)
        load_interval                         = try(int.load_interval, null)
        snmp_trap_link_status                 = try(int.snmp_trap_link_status, null)
        logging_event_link_status_enable      = try(int.logging_event_link_status_enable, null)
        ospf_authentication_key_chain         = try(int.ospf.authentication_key_chain, null)
        ospf_authentication_message_digest    = try(int.ospf.authentication_message_digest, null)
        ospf_authentication_null              = try(int.ospf.authentication_null, null)
        ospf_cost                             = try(int.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, null)
          md5_auth_key  = try(key.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, null)
        }]
        ospf_multi_area_ids = try(length(int.ospf.multi_area_ids) == 0, true) ? null : [for area in int.ospf.multi_area_ids : {
          area_id = area
        }]
        ospfv3                                  = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                             = try(int.ospfv3.cost, null)
        ospfv3_bfd                              = try(int.ospfv3.bfd, null)
        ospfv3_dead_interval                    = try(int.ospfv3.dead_interval, null)
        ospfv3_hello_interval                   = try(int.ospfv3.hello_interval, null)
        ospfv3_mtu_ignore                       = try(int.ospfv3.mtu_ignore, null)
        ospfv3_priority                         = try(int.ospfv3.priority, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, null)
        pim_border                              = try(int.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, null)
        ipv6_pim                                = try(int.ipv6.pim, null) != null ? true : false
        ipv6_pim_pim                            = try(int.ipv6.pim.pim, null)
        ipv6_pim_bfd                            = try(int.ipv6.pim.bfd, null)
        ipv6_pim_bsr_border                     = try(int.ipv6.pim.bsr_border, null)
        ipv6_pim_dr_priority                    = try(int.ipv6.pim.dr_priority, null)
        ip_igmp_version                         = try(int.igmp.version, null)
      }
    ]
  ])
}

resource "iosxe_interface_tunnel" "tunnel" {
  for_each = { for v in local.interfaces_tunnels : v.key => v }
  device   = each.value.device

  name                             = each.value.name
  description                      = each.value.description
  shutdown                         = each.value.shutdown
  vrf_forwarding                   = each.value.vrf_forwarding
  ipv4_address                     = each.value.ipv4_address
  ipv4_address_mask                = each.value.ipv4_address_mask
  ipv4_address_dhcp                = each.value.ipv4_address_dhcp
  ip_proxy_arp                     = each.value.ip_proxy_arp
  ip_dhcp_relay_source_interface   = each.value.ip_dhcp_relay_source_interface
  helper_addresses                 = each.value.helper_addresses
  ip_access_group_in               = each.value.ip_access_group_in
  ip_access_group_in_enable        = each.value.ip_access_group_in_enable
  ip_access_group_out              = each.value.ip_access_group_out
  ip_access_group_out_enable       = each.value.ip_access_group_out_enable
  ip_flow_monitors                 = each.value.ip_flow_monitors
  ip_redirects                     = each.value.ip_redirects
  ip_unreachables                  = each.value.ip_unreachables
  ip_nat_inside                    = each.value.ip_nat_inside
  ip_nat_outside                   = each.value.ip_nat_outside
  zone_member_security             = each.value.zone_member_security
  unnumbered                       = each.value.unnumbered
  ipv6_enable                      = each.value.ipv6_enable
  ipv6_addresses                   = each.value.ipv6_addresses
  ipv6_link_local_addresses        = each.value.ipv6_link_local_addresses
  ipv6_address_autoconfig_default  = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                = each.value.ipv6_address_dhcp
  ipv6_mtu                         = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all          = each.value.ipv6_nd_ra_suppress_all
  ipv6_flow_monitors               = each.value.ipv6_flow_monitors
  bfd_enable                       = each.value.bfd_enable
  bfd_template                     = each.value.bfd_template
  bfd_local_address                = each.value.bfd_local_address
  bfd_interval                     = each.value.bfd_interval
  bfd_interval_min_rx              = each.value.bfd_interval_min_rx
  bfd_interval_multiplier          = each.value.bfd_interval_multiplier
  bfd_echo                         = each.value.bfd_echo
  tunnel_destination_ipv4          = each.value.tunnel_destination_ipv4
  tunnel_source                    = each.value.tunnel_source
  tunnel_vrf                       = each.value.tunnel_vrf
  tunnel_mode_ipsec_ipv4           = each.value.tunnel_mode_ipsec_ipv4
  tunnel_mode_gre_multipoint       = each.value.tunnel_mode_gre_multipoint
  tunnel_protection_ipsec_profile  = each.value.tunnel_protection_ipsec_profile
  tunnel_key                       = each.value.tunnel_key
  tunnel_bandwidth_transmit        = each.value.tunnel_bandwidth_transmit
  tunnel_bandwidth_receive         = each.value.tunnel_bandwidth_receive
  ip_nhrp_authentication           = each.value.ip_nhrp_authentication
  ip_nhrp_network_id               = each.value.ip_nhrp_network_id
  ip_nhrp_nhs                      = each.value.ip_nhrp_nhs
  ip_nhrp_maps                     = each.value.ip_nhrp_maps
  ip_nhrp_redirect                 = each.value.ip_nhrp_redirect
  ip_nhrp_shortcut                 = each.value.ip_nhrp_shortcut
  mpls_nhrp                        = each.value.mpls_nhrp
  bandwidth                        = each.value.bandwidth
  service_policy_input             = each.value.service_policy_input
  service_policy_output            = each.value.service_policy_output
  arp_timeout                      = each.value.arp_timeout
  ip_mtu                           = each.value.ip_mtu
  load_interval                    = each.value.load_interval
  snmp_trap_link_status            = each.value.snmp_trap_link_status
  logging_event_link_status_enable = each.value.logging_event_link_status_enable
  ip_igmp_version                  = each.value.ip_igmp_version

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_zone_security.zone_security,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_crypto_ipsec_profile.crypto_ipsec_profile,
    iosxe_policy_map.policy_map,
    iosxe_flow_monitor.flow_monitor
  ]
}

resource "iosxe_interface_ospf" "tunnel_ospf" {
  for_each = { for v in local.interfaces_tunnels : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = "Tunnel"
  name                             = each.value.name
  authentication_key_chain         = each.value.ospf_authentication_key_chain
  authentication_message_digest    = each.value.ospf_authentication_message_digest
  authentication_null              = each.value.ospf_authentication_null
  cost                             = each.value.ospf_cost
  dead_interval                    = each.value.ospf_dead_interval
  hello_interval                   = each.value.ospf_hello_interval
  mtu_ignore                       = each.value.ospf_mtu_ignore
  network_type_broadcast           = each.value.ospf_network_type_broadcast
  network_type_non_broadcast       = each.value.ospf_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospf_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospf_network_type_point_to_point
  priority                         = each.value.ospf_priority
  ttl_security_hops                = each.value.ospf_ttl_security_hops
  process_ids                      = each.value.ospf_process_ids
  message_digest_keys              = each.value.ospf_message_digest_keys
  multi_area_ids                   = each.value.ospf_multi_area_ids

  depends_on = [
    iosxe_interface_tunnel.tunnel,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "tunnel_ospfv3" {
  for_each = { for v in local.interfaces_tunnels : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = "Tunnel"
  name                             = each.value.name
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost
  bfd                              = each.value.ospfv3_bfd
  dead_interval                    = each.value.ospfv3_dead_interval
  hello_interval                   = each.value.ospfv3_hello_interval
  mtu_ignore                       = each.value.ospfv3_mtu_ignore
  priority                         = each.value.ospfv3_priority

  depends_on = [
    iosxe_interface_tunnel.tunnel,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_pim" "tunnel_pim" {
  for_each = { for v in local.interfaces_tunnels : v.key => v if v.pim }

  device            = each.value.device
  type              = "Tunnel"
  name              = each.value.name
  passive           = each.value.pim_passive
  dense_mode        = each.value.pim_dense_mode
  sparse_mode       = each.value.pim_sparse_mode
  sparse_dense_mode = each.value.pim_sparse_dense_mode
  bfd               = each.value.pim_bfd
  border            = each.value.pim_border
  bsr_border        = each.value.pim_bsr_border
  dr_priority       = each.value.pim_dr_priority

  depends_on = [
    iosxe_system.system,
    iosxe_interface_tunnel.tunnel
  ]
}

resource "iosxe_interface_pim_ipv6" "tunnel_pim_ipv6" {
  for_each = { for v in local.interfaces_tunnels : v.key => v if v.ipv6_pim }

  device      = each.value.device
  type        = "Tunnel"
  name        = each.value.name
  pim         = each.value.ipv6_pim_pim
  bfd         = each.value.ipv6_pim_bfd
  bsr_border  = each.value.ipv6_pim_bsr_border
  dr_priority = each.value.ipv6_pim_dr_priority

  depends_on = [
    iosxe_interface_tunnel.tunnel
  ]
}
