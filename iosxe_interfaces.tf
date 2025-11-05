##### ETHERNETS #####

locals {
  interfaces_ethernets = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.ethernets, []) : {
        key                            = format("%s/%s%s", device.name, try(int.type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.type, null), trimprefix(int.id, "$string "))
        device                         = device.name
        id                             = trimprefix(int.id, "$string ")
        type                           = try(int.type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.type, null)
        media_type                     = try(int.media_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.media_type, null)
        bandwidth                      = try(int.bandwidth, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bandwidth, null)
        mtu                            = try(int.mtu, local.defaults.iosxe.devices.configuration.interfaces.ethernets.mtu, null)
        description                    = try(int.description, local.defaults.iosxe.devices.configuration.interfaces.ethernets.description, null)
        shutdown                       = try(int.shutdown, local.defaults.iosxe.devices.configuration.interfaces.ethernets.shutdown, false)
        vrf_forwarding                 = try(int.vrf_forwarding, local.defaults.iosxe.devices.configuration.interfaces.ethernets.vrf_forwarding, null)
        ipv4_address                   = try(int.ipv4.address, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.address, null)
        ipv4_address_mask              = try(int.ipv4.address_mask, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.address_mask, null)
        ip_proxy_arp                   = try(int.ipv4.proxy_arp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.proxy_arp, null)
        ip_arp_inspection_trust        = try(int.ipv4.arp_inspection_trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.arp_inspection_trust, null)
        ip_arp_inspection_limit_rate   = try(int.ipv4.arp_inspection_limit_rate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.arp_inspection_limit_rate, null)
        ip_dhcp_snooping_trust         = try(int.ipv4.dhcp_snooping_trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.dhcp_snooping_trust, null)
        ip_dhcp_relay_source_interface = try("${try(int.ipv4.dhcp_relay_source_interface_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.dhcp_relay_source_interface_type)}${try(int.ipv4.dhcp_relay_source_interface_id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.dhcp_relay_source_interface_id)}", null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for ha in int.ipv4.helper_addresses : {
          address = try(ha.address, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.helper_addresses.address, null)
          global  = try(ha.global, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.helper_addresses.global, null)
          vrf     = try(ha.vrf, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.helper_addresses.vrf, null)
        }]
        ip_access_group_in         = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_in, null)
        ip_access_group_in_enable  = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_in, null) != null ? true : false
        ip_access_group_out        = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_out, null)
        ip_access_group_out_enable = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_out, null) != null ? true : false
        ip_flow_monitors = try(length(int.ipv4.flow_monitors) == 0, true) ? null : [for fm in int.ipv4.flow_monitors : {
          name      = try(fm.name, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.flow_monitors.name, null)
          direction = try(fm.direction, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.flow_monitors.direction, null)
        }]
        ip_nbar_protocol_discovery = try(int.nbar_protocol_discovery, local.defaults.iosxe.devices.configuration.interfaces.ethernets.nbar_protocol_discovery, null)
        ip_redirects               = try(int.ipv4.redirects, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.redirects, null)
        ip_unreachables            = try(int.ipv4.unreachables, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.unreachables, null)
        unnumbered                 = try("${try(int.ipv4.unnumbered_interface_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.unnumbered_interface_type)}${try(int.ipv4.unnumbered_interface_id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.unnumbered_interface_id)}", null)
        source_template            = try(int.source_template, local.defaults.iosxe.devices.configuration.interfaces.ethernets.source_template, [])
        ipv6_enable                = try(int.ipv6.enable, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.enable, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = "${try(addr.prefix, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.addresses.prefix, null)}/${try(addr.prefix_length, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.addresses.prefix_length, null)}"
          eui64  = try(addr.eui64, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.addresses.eui64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp               = try(int.ipv6.address_dhcp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.address_dhcp, null)
        ipv6_mtu                        = try(int.ipv6.mtu, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all         = try(int.ipv6.nd_ra_suppress_all, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.nd_ra_suppress_all, null)
        ipv6_flow_monitors = try(length(int.ipv6.flow_monitors) == 0, true) ? null : [for fm in int.ipv6.flow_monitors : {
          name      = try(fm.name, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.flow_monitors.name, null)
          direction = try(fm.direction, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.flow_monitors.direction, null)
        }]
        bfd_enable                   = try(int.bfd.enable, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.enable, null)
        bfd_template                 = try(int.bfd.template, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.template, null)
        bfd_local_address            = try(int.bfd.local_address, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.local_address, null)
        bfd_interval                 = try(int.bfd.interval, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.interval, null)
        bfd_interval_min_rx          = try(int.bfd.interval_min_rx, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.interval_min_rx, null)
        bfd_interval_multiplier      = try(int.bfd.interval_multiplier, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.interval_multiplier, null)
        bfd_echo                     = try(int.bfd.echo, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.echo, null)
        spanning_tree_guard          = try(int.spanning_tree.guard, local.defaults.iosxe.devices.configuration.interfaces.ethernets.spanning_tree.guard, null)
        spanning_tree_link_type      = try(int.spanning_tree.link_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.spanning_tree.link_type, null)
        spanning_tree_portfast_trunk = try(int.spanning_tree.portfast_trunk, local.defaults.iosxe.devices.configuration.interfaces.ethernets.spanning_tree.portfast_trunk, null)
        speed_100                    = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 100 ? true : null
        speed_1000                   = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 1000 ? true : null
        speed_2500                   = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 2500 ? true : null
        speed_5000                   = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 5000 ? true : null
        speed_10000                  = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 10000 ? true : null
        speed_25000                  = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 25000 ? true : null
        speed_40000                  = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 40000 ? true : null
        speed_100000                 = try(int.speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 100000 ? true : null
        speed_nonegotiate            = try(int.speed_nonegotiate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed_nonegotiate, null)
        channel_group_number         = try(int.port_channel_id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.port_channel_id, null)
        channel_group_mode           = try(int.port_channel_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.port_channel_mode, null)
        source_templates = try(length(int.source_templates) == 0, true) ? null : [for st in int.source_templates : {
          template_name = try(st.name, local.defaults.iosxe.devices.configuration.interfaces.ethernets.source_templates.name, null)
          merge         = try(st.merge, local.defaults.iosxe.devices.configuration.interfaces.ethernets.source_templates.merge, null)
        }]
        arp_timeout                      = try(int.arp_timeout, local.defaults.iosxe.devices.configuration.interfaces.ethernets.arp_timeout, null)
        negotiation_auto                 = try(int.negotiation_auto, local.defaults.iosxe.devices.configuration.interfaces.ethernets.negotiation_auto, null)
        service_policy_input             = try(int.service_policy_input, local.defaults.iosxe.devices.configuration.interfaces.ethernets.service_policy_input, null)
        service_policy_output            = try(int.service_policy_output, local.defaults.iosxe.devices.configuration.interfaces.ethernets.service_policy_output, null)
        load_interval                    = try(int.load_interval, local.defaults.iosxe.devices.configuration.interfaces.ethernets.load_interval, null)
        snmp_trap_link_status            = try(int.snmp_trap_link_status, local.defaults.iosxe.devices.configuration.interfaces.ethernets.snmp_trap_link_status, null)
        logging_event_link_status_enable = try(int.logging_event_link_status, local.defaults.iosxe.devices.configuration.interfaces.ethernets.logging_event_link_status, null)
        device_tracking                  = try(int.device_tracking, local.defaults.iosxe.devices.configuration.interfaces.ethernets.device_tracking, null)
        device_tracking_attached_policies = try(length(int.device_tracking_attached_policies) == 0, true) ? null : [for policy in int.device_tracking_attached_policies : {
          name = policy
        }]
        encapsulation_dot1q_vlan_id              = try(int.encapsulation_dot1q_vlan_id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.encapsulation_dot1q_vlan_id, null)
        switchport                               = try(int.switchport.enable, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.enable, null)
        switchport_mode                          = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null)
        switchport_access_vlan                   = try(int.switchport.access_vlan, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.access_vlan, null)
        switchport_mode_access                   = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "access" ? true : null
        switchport_mode_trunk                    = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "trunk" ? true : null
        switchport_mode_dot1q_tunnel             = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "dot1q-tunnel" ? true : null
        switchport_mode_private_vlan_trunk       = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "private-vlan-trunk" ? true : null
        switchport_mode_private_vlan_host        = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "private-vlan-host" ? true : null
        switchport_mode_private_vlan_promiscuous = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "private-vlan-promiscuous" ? true : null
        switchport_nonegotiate                   = try(int.switchport.nonegotiate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.nonegotiate, null)
        switchport_trunk_allowed_vlans = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_allowed_vlans),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_none = length(try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_allowed_vlans),
            "list"
          ),
          []
        )) == 0 && contains(["trunk", "private-vlan-trunk"], try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, "")) ? true : null
        switchport_trunk_native_vlan_tag      = try(int.switchport.trunk_native_vlan_tag, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_native_vlan_tag, null)
        switchport_trunk_native_vlan          = try(int.switchport.trunk_native_vlan_id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_native_vlan_id, null)
        switchport_host                       = try(int.switchport.host, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.host, null)
        auto_qos_classify                     = try(int.auto_qos.classify, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.classify, null)
        auto_qos_classify_police              = try(int.auto_qos.classify_police, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.classify_police, null)
        auto_qos_trust                        = try(int.auto_qos.trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust, null)
        auto_qos_trust_cos                    = try(int.auto_qos.trust_cos, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust_cos, null)
        auto_qos_trust_dscp                   = try(int.auto_qos.trust_dscp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust_dscp, null)
        auto_qos_video_cts                    = try(int.auto_qos.video_cts, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.video_cts, null)
        auto_qos_video_ip_camera              = try(int.auto_qos.video_ip_camera, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.video_ip_camera, null)
        auto_qos_video_media_player           = try(int.auto_qos.video_media_player, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.video_media_player, null)
        auto_qos_voip                         = try(int.auto_qos.voip, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip, null)
        auto_qos_voip_cisco_phone             = try(int.auto_qos.voip_cisco_phone, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip_cisco_phone, null)
        auto_qos_voip_cisco_softphone         = try(int.auto_qos.voip_cisco_softphone, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip_cisco_softphone, null)
        auto_qos_voip_trust                   = try(int.auto_qos.voip_trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip_trust, null)
        trust_device                          = try(int.auto_qos.trust_device, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust_device, null)
        mpls_ip                               = try(int.mpls.ip, local.defaults.iosxe.devices.configuration.interfaces.ethernets.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, local.defaults.iosxe.devices.configuration.interfaces.ethernets.mpls.mtu, null)
        ospf_cost                             = try(int.ospf.cost, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.process_ids.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.message_digest_keys.id, null)
          md5_auth_key  = try(key.md5_auth_key, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.message_digest_keys.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospf.message_digest_keys.md5_auth_type, null)
        }]
        ospfv3                                     = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast              = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast          = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint    = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point         = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                                = try(int.ospfv3.cost, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ospfv3.cost, null)
        pim                                        = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                                = try(int.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.passive, null)
        pim_dense_mode                             = try(int.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.dense_mode, null)
        pim_sparse_mode                            = try(int.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.sparse_mode, null)
        pim_sparse_dense_mode                      = try(int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.sparse_dense_mode, null)
        pim_bfd                                    = try(int.pim.bfd, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.bfd, null)
        pim_border                                 = try(int.pim.border, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.border, null)
        pim_bsr_border                             = try(int.pim.bsr_border, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.bsr_border, null)
        pim_dr_priority                            = try(int.pim.dr_priority, local.defaults.iosxe.devices.configuration.interfaces.ethernets.pim.dr_priority, null)
        authentication_periodic                    = try(int.network_access_control.authentication_periodic, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.authentication_periodic, null)
        authentication_timer_reauthenticate        = try(int.network_access_control.authentication_timer_reauthenticate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.authentication_timer_reauthenticate, null)
        authentication_timer_reauthenticate_server = try(int.network_access_control.authentication_timer_reauthenticate_server, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.authentication_timer_reauthenticate_server, null)
        mab                                        = try(int.network_access_control.mab, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.mab, null)
        mab_eap                                    = try(int.network_access_control.mab_eap, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.mab_eap, null)
        dot1x_pae                                  = try(int.network_access_control.dot1x_pae, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_pae, null)
        dot1x_timeout_auth_period                  = try(int.network_access_control.dot1x_timeout_auth_period, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_auth_period, null)
        dot1x_timeout_held_period                  = try(int.network_access_control.dot1x_timeout_held_period, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_held_period, null)
        dot1x_timeout_quiet_period                 = try(int.network_access_control.dot1x_timeout_quiet_period, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_quiet_period, null)
        dot1x_timeout_ratelimit_period             = try(int.network_access_control.dot1x_timeout_ratelimit_period, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_ratelimit_period, null)
        dot1x_timeout_server_timeout               = try(int.network_access_control.dot1x_timeout_server_timeout, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_server_timeout, null)
        dot1x_timeout_start_period                 = try(int.network_access_control.dot1x_timeout_start_period, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_start_period, null)
        dot1x_timeout_supp_timeout                 = try(int.network_access_control.dot1x_timeout_supp_timeout, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_supp_timeout, null)
        dot1x_timeout_tx_period                    = try(int.network_access_control.dot1x_timeout_tx_period, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_timeout_tx_period, null)
        dot1x_max_reauth_req                       = try(int.network_access_control.dot1x_max_reauth_req, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_max_reauth_req, null)
        dot1x_max_req                              = try(int.network_access_control.dot1x_max_req, local.defaults.iosxe.devices.configuration.interfaces.ethernets.network_access_control.dot1x_max_req, null)
        cdp_enable                                 = try(int.cdp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.cdp, null)
        cdp_tlv_app                                = try(int.cdp_tlv_app, local.defaults.iosxe.devices.configuration.interfaces.ethernets.cdp_tlv_app, null)
        cdp_tlv_location                           = try(int.cdp_tlv_location, local.defaults.iosxe.devices.configuration.interfaces.ethernets.cdp_tlv_location, null)
        cdp_tlv_server_location                    = try(int.cdp_tlv_server_location, local.defaults.iosxe.devices.configuration.interfaces.ethernets.cdp_tlv_server_location, null)
        ip_nat_inside                              = try(int.ipv4.nat_inside, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.nat_inside, null)
        ip_nat_outside                             = try(int.ipv4.nat_outside, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.nat_outside, null)
      }
    ]
  ])
}

resource "iosxe_interface_ethernet" "ethernet" {
  for_each = { for v in local.interfaces_ethernets : v.key => v }
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
  helper_addresses                           = each.value.helper_addresses
  ip_access_group_in                         = each.value.ip_access_group_in
  ip_access_group_in_enable                  = each.value.ip_access_group_in_enable
  ip_access_group_out                        = each.value.ip_access_group_out
  ip_access_group_out_enable                 = each.value.ip_access_group_out_enable
  ip_flow_monitors                           = each.value.ip_flow_monitors
  ip_nbar_protocol_discovery                 = each.value.ip_nbar_protocol_discovery
  ip_redirects                               = each.value.ip_redirects
  ip_unreachables                            = each.value.ip_unreachables
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
  auto_qos_voip                              = each.value.auto_qos_voip
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
  ip_nat_inside                              = each.value.ip_nat_inside
  ip_nat_outside                             = each.value.ip_nat_outside

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map
  ]
}

resource "iosxe_interface_switchport" "ethernet_switchport" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.switchport == true || v.switchport_mode != null }

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
  trunk_allowed_vlans           = each.value.switchport_trunk_allowed_vlans
  trunk_allowed_vlans_none      = each.value.switchport_trunk_allowed_vlans_none
  trunk_native_vlan_tag         = each.value.switchport_trunk_native_vlan_tag
  trunk_native_vlan             = each.value.switchport_trunk_native_vlan
  host                          = each.value.switchport_host

  depends_on = [
    iosxe_interface_ethernet.ethernet
  ]
}

resource "iosxe_interface_mpls" "ethernet_mpls" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.mpls_ip == true || v.mpls_mtu != null }

  device = each.value.device
  type   = each.value.type
  name   = each.value.id
  ip     = each.value.mpls_ip
  mtu    = each.value.mpls_mtu

  depends_on = [
    iosxe_interface_ethernet.ethernet
  ]
}

resource "iosxe_interface_ospf" "ethernet_ospf" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.ospf }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
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

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_ospfv3" "ethernet_ospfv3" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.ospfv3 }

  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
  network_type_broadcast           = each.value.ospfv3_network_type_broadcast
  network_type_non_broadcast       = each.value.ospfv3_network_type_non_broadcast
  network_type_point_to_multipoint = each.value.ospfv3_network_type_point_to_multipoint
  network_type_point_to_point      = each.value.ospfv3_network_type_point_to_point
  cost                             = each.value.ospfv3_cost

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf
  ]
}

resource "iosxe_interface_pim" "ethernet_pim" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.pim }

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
    iosxe_interface_ethernet.ethernet
  ]
}

##### LOOPBACKS #####

locals {
  interfaces_loopbacks = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.loopbacks, []) : {
        key                        = format("%s/Loopback%s", device.name, int.id)
        device                     = device.name
        id                         = int.id
        description                = try(int.description, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.description, null)
        shutdown                   = try(int.shutdown, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.shutdown, false)
        vrf_forwarding             = try(int.vrf_forwarding, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.vrf_forwarding, null)
        ipv4_address               = try(int.ipv4.address, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.address, null)
        ipv4_address_mask          = try(int.ipv4.address_mask, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.address_mask, null)
        ip_proxy_arp               = try(int.ipv4.proxy_arp, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.proxy_arp, null)
        ip_access_group_in         = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.access_group_in, null)
        ip_access_group_in_enable  = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.access_group_in, null) != null ? true : false
        ip_access_group_out        = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.access_group_out, null)
        ip_access_group_out_enable = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.access_group_out, null) != null ? true : false
        ip_redirects               = try(int.ipv4.redirects, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.redirects, null)
        ip_unreachables            = try(int.ipv4.unreachables, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv4.unreachables, null)
        source_template            = try(int.source_template, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.source_template, [])
        ipv6_enable                = try(int.ipv6.enable, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.enable, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = "${try(addr.prefix, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.addresses.prefix, null)}/${try(addr.prefix_length, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.addresses.prefix_length, null)}"
          eui64  = try(addr.eui64, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.addresses.eui64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp               = try(int.ipv6.address_dhcp, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.address_dhcp, null)
        ipv6_mtu                        = try(int.ipv6.mtu, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all         = try(int.ipv6.nd_ra_suppress_all, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ipv6.nd_ra_suppress_all, null)
        source_templates = try(length(int.source_templates) == 0, true) ? null : [for st in int.source_templates : {
          template_name = try(st.name, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.source_templates.name, null)
          merge         = try(st.merge, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.source_templates.merge, null)
        }]
        arp_timeout                           = try(int.arp_timeout, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.arp_timeout, null)
        load_interval                         = try(int.load_interval, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.load_interval, null)
        mpls_ip                               = try(int.mpls.ip, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.mpls.mtu, null)
        ospf_cost                             = try(int.ospf.cost, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.process_ids.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.message_digest_keys.id, null)
          md5_auth_key  = try(key.md5_auth_key, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.message_digest_keys.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospf.message_digest_keys.md5_auth_type, null)
        }]
        ospfv3                                  = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                             = try(int.ospfv3.cost, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.ospfv3.cost, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.bfd, null)
        pim_border                              = try(int.pim.border, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, local.defaults.iosxe.devices.configuration.interfaces.loopbacks.pim.dr_priority, null)
      }
    ]
  ])
}

resource "iosxe_interface_loopback" "loopback" {
  for_each = { for v in local.interfaces_loopbacks : v.key => v }
  device   = each.value.device

  name                            = each.value.id
  description                     = each.value.description
  shutdown                        = each.value.shutdown
  vrf_forwarding                  = each.value.vrf_forwarding
  ipv4_address                    = each.value.ipv4_address
  ipv4_address_mask               = each.value.ipv4_address_mask
  ip_proxy_arp                    = each.value.ip_proxy_arp
  ip_access_group_in              = each.value.ip_access_group_in
  ip_access_group_in_enable       = each.value.ip_access_group_in_enable
  ip_access_group_out             = each.value.ip_access_group_out
  ip_access_group_out_enable      = each.value.ip_access_group_out_enable
  ip_redirects                    = each.value.ip_redirects
  ip_unreachables                 = each.value.ip_unreachables
  ipv6_enable                     = each.value.ipv6_enable
  ipv6_addresses                  = each.value.ipv6_addresses
  ipv6_link_local_addresses       = each.value.ipv6_link_local_addresses
  ipv6_address_autoconfig_default = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp               = each.value.ipv6_address_dhcp
  ipv6_mtu                        = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all         = each.value.ipv6_nd_ra_suppress_all
  arp_timeout                     = each.value.arp_timeout

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map
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
    iosxe_interface_loopback.loopback
  ]
}

####### VLANS #######

locals {
  interfaces_vlans = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.vlans, []) : {
        key                            = format("%s/Vlan%s", device.name, int.id)
        device                         = device.name
        id                             = int.id
        type                           = try(int.type, local.defaults.iosxe.devices.configuration.interfaces.vlans.type, null)
        description                    = try(int.description, local.defaults.iosxe.devices.configuration.interfaces.vlans.description, null)
        shutdown                       = try(int.shutdown, local.defaults.iosxe.devices.configuration.interfaces.vlans.shutdown, false)
        autostate                      = try(int.autostate, local.defaults.iosxe.devices.configuration.interfaces.vlans.autostate, null)
        vrf_forwarding                 = try(int.vrf_forwarding, local.defaults.iosxe.devices.configuration.interfaces.vlans.vrf_forwarding, null)
        ipv4_address                   = try(int.ipv4.address, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.address, null)
        ipv4_address_mask              = try(int.ipv4.address_mask, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.address_mask, null)
        ip_proxy_arp                   = try(int.ipv4.proxy_arp, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.proxy_arp, null)
        mac_address                    = try(int.mac_address, local.defaults.iosxe.devices.configuration.interfaces.vlans.mac_address, null)
        ip_dhcp_relay_source_interface = try("${try(int.ipv4.dhcp_relay_source_interface_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.dhcp_relay_source_interface_type)}${try(int.ipv4.dhcp_relay_source_interface_id, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.dhcp_relay_source_interface_id)}", null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for ha in int.ipv4.helper_addresses : {
          address = try(ha.address, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.helper_addresses.address, null)
          global  = try(ha.global, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.helper_addresses.global, null)
          vrf     = try(ha.vrf, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.helper_addresses.vrf, null)
        }]
        ip_access_group_in         = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.access_group_in, null)
        ip_access_group_in_enable  = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.access_group_in, null) != null ? true : false
        ip_access_group_out        = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.access_group_out, null)
        ip_access_group_out_enable = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.access_group_out, null) != null ? true : false
        ip_redirects               = try(int.ipv4.redirects, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.redirects, null)
        ip_unreachables            = try(int.ipv4.unreachables, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.unreachables, null)
        unnumbered                 = try("${try(int.ipv4.unnumbered_interface_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.unnumbered_interface_type)}${try(int.ipv4.unnumbered_interface_id, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv4.unnumbered_interface_id)}", null)
        ipv6_enable                = try(int.ipv6.enable, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.enable, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = "${try(addr.prefix, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.addresses.prefix, null)}/${try(addr.prefix_length, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.addresses.prefix_length, null)}"
          eui64  = try(addr.eui64, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.addresses.eui64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default       = try(int.ipv6.address_autoconfig_default, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp                     = try(int.ipv6.address_dhcp, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.address_dhcp, null)
        ipv6_mtu                              = try(int.ipv6.mtu, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all               = try(int.ipv6.nd_ra_suppress_all, local.defaults.iosxe.devices.configuration.interfaces.vlans.ipv6.nd_ra_suppress_all, null)
        bfd_enable                            = try(int.bfd.enable, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.enable, null)
        bfd_template                          = try(int.bfd.template, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.template, null)
        bfd_local_address                     = try(int.bfd.local_address, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.local_address, null)
        bfd_interval                          = try(int.bfd.interval, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.interval, null)
        bfd_interval_min_rx                   = try(int.bfd.interval_min_rx, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.interval_min_rx, null)
        bfd_interval_multiplier               = try(int.bfd.interval_multiplier, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.interval_multiplier, null)
        bfd_echo                              = try(int.bfd.echo, local.defaults.iosxe.devices.configuration.interfaces.vlans.bfd.echo, null)
        load_interval                         = try(int.load_interval, local.defaults.iosxe.devices.configuration.interfaces.vlans.load_interval, null)
        snmp_trap_link_status                 = try(int.snmp_trap_link_status, local.defaults.iosxe.devices.configuration.interfaces.vlans.snmp_trap_link_status, null)
        logging_event_link_status_enable      = try(int.logging_event_link_status, local.defaults.iosxe.devices.configuration.interfaces.vlans.logging_event_link_status, null)
        mpls_ip                               = try(int.mpls.ip, local.defaults.iosxe.devices.configuration.interfaces.vlans.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, local.defaults.iosxe.devices.configuration.interfaces.vlans.mpls.mtu, null)
        ospf_cost                             = try(int.ospf.cost, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.mtu_ignore, null)
        ospf                                  = try(int.ospf, null) != null ? true : false
        ospf_network_type_broadcast           = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.network_type, null) == "broadcast" ? true : null
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.network_type, null) == "non-broadcast" ? true : null
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.network_type, null) == "point-to-multipoint" ? true : null
        ospf_network_type_point_to_point      = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.network_type, null) == "point-to-point" ? true : null
        ospf_priority                         = try(int.ospf.priority, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id = try(pid.id, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.process_ids.id, null)
          areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
            area_id = area
          }]
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.message_digest_keys.id, null)
          md5_auth_key  = try(key.md5_auth_key, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.message_digest_keys.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospf.message_digest_keys.md5_auth_type, null)
        }]
        ospfv3                                  = try(int.ospfv3, null) != null ? true : false
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospfv3.network_type, null) == "broadcast" ? true : null
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospfv3.network_type, null) == "non-broadcast" ? true : null
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospfv3.network_type, null) == "point-to-point" ? true : null
        ospfv3_cost                             = try(int.ospfv3.cost, local.defaults.iosxe.devices.configuration.interfaces.vlans.ospfv3.cost, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.bfd, null)
        pim_border                              = try(int.pim.border, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, local.defaults.iosxe.devices.configuration.interfaces.vlans.pim.dr_priority, null)
      }
    ]
  ])
}

resource "iosxe_interface_vlan" "vlan" {
  for_each = { for v in local.interfaces_vlans : v.key => v }
  device   = each.value.device

  name                            = each.value.id
  description                     = each.value.description
  shutdown                        = each.value.shutdown
  autostate                       = each.value.autostate
  vrf_forwarding                  = each.value.vrf_forwarding
  ipv4_address                    = each.value.ipv4_address
  ipv4_address_mask               = each.value.ipv4_address_mask
  ip_proxy_arp                    = each.value.ip_proxy_arp
  mac_address                     = each.value.mac_address
  ip_dhcp_relay_source_interface  = each.value.ip_dhcp_relay_source_interface
  helper_addresses                = each.value.helper_addresses
  ip_access_group_in              = each.value.ip_access_group_in
  ip_access_group_in_enable       = each.value.ip_access_group_in_enable
  ip_access_group_out             = each.value.ip_access_group_out
  ip_access_group_out_enable      = each.value.ip_access_group_out_enable
  ip_redirects                    = each.value.ip_redirects
  ip_unreachables                 = each.value.ip_unreachables
  unnumbered                      = each.value.unnumbered
  ipv6_address_autoconfig_default = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp               = each.value.ipv6_address_dhcp
  ipv6_addresses                  = each.value.ipv6_addresses
  ipv6_enable                     = each.value.ipv6_enable
  ipv6_link_local_addresses       = each.value.ipv6_link_local_addresses
  ipv6_mtu                        = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all         = each.value.ipv6_nd_ra_suppress_all
  bfd_enable                      = each.value.bfd_enable
  bfd_template                    = each.value.bfd_template
  bfd_local_address               = each.value.bfd_local_address
  bfd_interval                    = each.value.bfd_interval
  bfd_interval_min_rx             = each.value.bfd_interval_min_rx
  bfd_interval_multiplier         = each.value.bfd_interval_multiplier
  bfd_echo                        = each.value.bfd_echo
  load_interval                   = each.value.load_interval

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map
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
    iosxe_interface_vlan.vlan
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
        description                    = try(int.description, local.defaults.iosxe.devices.configuration.interfaces.port_channels.description, null)
        shutdown                       = try(int.shutdown, local.defaults.iosxe.devices.configuration.interfaces.port_channels.shutdown, false)
        vrf_forwarding                 = try(int.vrf_forwarding, local.defaults.iosxe.devices.configuration.interfaces.port_channels.vrf_forwarding, null)
        ipv4_address                   = try(int.ipv4.address, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.address, null)
        ipv4_address_mask              = try(int.ipv4.address_mask, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.address_mask, null)
        ip_proxy_arp                   = try(int.ipv4.proxy_arp, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.proxy_arp, null)
        ip_dhcp_relay_source_interface = try(int.ipv4.dhcp_relay_source_interface_type, int.ipv4.dhcp_relay_source_interface_id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.dhcp_relay_source_interface_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.dhcp_relay_source_interface_id, null) != null ? format("%s%s", try(int.ipv4.dhcp_relay_source_interface_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.dhcp_relay_source_interface_type), try(int.ipv4.dhcp_relay_source_interface_id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.dhcp_relay_source_interface_id)) : null
        ip_access_group_in             = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.access_group_in, null)
        ip_access_group_in_enable      = try(int.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.access_group_in, null) != null ? true : false
        ip_access_group_out            = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.access_group_out, null)
        ip_access_group_out_enable     = try(int.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.access_group_out, null) != null ? true : false
        ip_redirects                   = try(int.ipv4.redirects, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.redirects, null)
        ip_unreachables                = try(int.ipv4.unreachables, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.unreachables, null)
        ip_arp_inspection_trust        = try(int.ipv4.arp_inspection_trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.arp_inspection_trust, null)
        ip_arp_inspection_limit_rate   = try(int.ipv4.arp_inspection_limit_rate, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.arp_inspection_limit_rate, null)
        ip_dhcp_snooping_trust         = try(int.ipv4.dhcp_snooping_trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.dhcp_snooping_trust, null)
        helper_addresses = try(length(int.ipv4.helper_addresses) == 0, true) ? null : [for addr in int.ipv4.helper_addresses : {
          address = try(addr.address, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.helper_addresses.address, null)
          global  = try(addr.global, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.helper_addresses.global, false)
          vrf     = try(addr.vrf, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv4.helper_addresses.vrf, null)
        }]
        ipv6_enable             = try(int.ipv6.enable, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.enable, null)
        ipv6_mtu                = try(int.ipv6.mtu, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all = try(int.ipv6.nd_ra_suppress_all, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.nd_ra_suppress_all, null)
        ipv6_address_dhcp       = try(int.ipv6.address_dhcp, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.address_dhcp, null)
        ipv6_addresses = try(length(int.ipv6.addresses) == 0, true) ? null : [for addr in int.ipv6.addresses : {
          prefix = try(addr.prefix, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.addresses.prefix, null)
          eui_64 = try(addr.eui_64, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.addresses.eui_64, null)
        }]
        ipv6_link_local_addresses = try(length(int.ipv6.link_local_addresses) == 0, true) ? null : [for addr in int.ipv6.link_local_addresses : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default  = try(int.ipv6.address_autoconfig_default, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ipv6.address_autoconfig_default, null)
        bfd_template                     = try(int.bfd.template, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.template, null)
        bfd_enable                       = try(int.bfd.enable, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.enable, null)
        bfd_local_address                = try(int.bfd.local_address, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.local_address, null)
        bfd_interval                     = try(int.bfd.interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.interval, null)
        bfd_interval_min_rx              = try(int.bfd.interval_min_rx, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.interval_min_rx, null)
        bfd_interval_multiplier          = try(int.bfd.interval_multiplier, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.interval_multiplier, null)
        bfd_echo                         = try(int.bfd.echo, local.defaults.iosxe.devices.configuration.interfaces.port_channels.bfd.echo, null)
        spanning_tree_guard              = try(int.spanning_tree.guard, local.defaults.iosxe.devices.configuration.interfaces.port_channels.spanning_tree.guard, null)
        spanning_tree_link_type          = try(int.spanning_tree.link_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.spanning_tree.link_type, null)
        spanning_tree_portfast_trunk     = try(int.spanning_tree.portfast_trunk, local.defaults.iosxe.devices.configuration.interfaces.port_channels.spanning_tree.portfast_trunk, null)
        arp_timeout                      = try(int.arp_timeout, local.defaults.iosxe.devices.configuration.interfaces.port_channels.arp_timeout, null)
        load_interval                    = try(int.load_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.load_interval, null)
        snmp_trap_link_status            = try(int.snmp_trap_link_status, local.defaults.iosxe.devices.configuration.interfaces.port_channels.snmp_trap_link_status, null)
        logging_event_link_status_enable = try(int.logging_event_link_status, local.defaults.iosxe.devices.configuration.interfaces.port_channels.logging_event_link_status, null)
        device_tracking                  = try(int.device_tracking, local.defaults.iosxe.devices.configuration.interfaces.port_channels.device_tracking, null)
        device_tracking_attached_policies = try(length(int.device_tracking_attached_policies) == 0, true) ? null : [for policy in int.device_tracking_attached_policies : {
          name = policy
        }]
        switchport                               = try(int.switchport.enable, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.enable, null)
        switchport_mode                          = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null)
        switchport_access_vlan                   = try(int.switchport.access_vlan, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.access_vlan, null)
        switchport_mode_access                   = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null) == "access" ? true : null
        switchport_mode_trunk                    = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null) == "trunk" ? true : null
        switchport_mode_dot1q_tunnel             = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null) == "dot1q-tunnel" ? true : null
        switchport_mode_private_vlan_trunk       = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null) == "private-vlan-trunk" ? true : null
        switchport_mode_private_vlan_host        = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null) == "private-vlan-host" ? true : null
        switchport_mode_private_vlan_promiscuous = try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, null) == "private-vlan-promiscuous" ? true : null
        switchport_nonegotiate                   = try(int.switchport.nonegotiate, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.nonegotiate, null)
        switchport_trunk_allowed_vlans = try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.trunk_allowed_vlans),
            "string"
          ),
          null
        )
        switchport_trunk_allowed_vlans_none = length(try(
          provider::utils::normalize_vlans(
            try(int.switchport.trunk_allowed_vlans, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.trunk_allowed_vlans),
            "list"
          ),
          []
        )) == 0 && contains(["trunk", "private-vlan-trunk"], try(int.switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.mode, "")) ? true : null
        switchport_trunk_native_vlan_tag      = try(int.switchport.trunk_native_vlan_tag, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.trunk_native_vlan_tag, null)
        switchport_trunk_native_vlan          = try(int.switchport.trunk_native_vlan_id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.trunk_native_vlan_id, null)
        switchport_host                       = try(int.switchport.host, local.defaults.iosxe.devices.configuration.interfaces.port_channels.switchport.host, null)
        mpls                                  = try(int.mpls.ip, int.mpls.mtu, local.defaults.iosxe.devices.configuration.interfaces.port_channels.mpls.ip, local.defaults.iosxe.devices.configuration.interfaces.port_channels.mpls.mtu, null) != null ? true : false
        mpls_ip                               = try(int.mpls.ip, local.defaults.iosxe.devices.configuration.interfaces.port_channels.mpls.ip, null)
        mpls_mtu                              = try(int.mpls.mtu, local.defaults.iosxe.devices.configuration.interfaces.port_channels.mpls.mtu, null)
        ospf                                  = try(int.ospf.cost, int.ospf.dead_interval, int.ospf.hello_interval, int.ospf.mtu_ignore, int.ospf.network_type, int.ospf.priority, int.ospf.ttl_security_hops, int.ospf.process_ids, int.ospf.message_digest_keys, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.cost, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.dead_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.hello_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.mtu_ignore, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.priority, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.ttl_security_hops, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.process_ids, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.message_digest_keys, null) != null ? true : false
        ospf_cost                             = try(int.ospf.cost, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.cost, null)
        ospf_dead_interval                    = try(int.ospf.dead_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.dead_interval, null)
        ospf_hello_interval                   = try(int.ospf.hello_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.hello_interval, null)
        ospf_mtu_ignore                       = try(int.ospf.mtu_ignore, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.mtu_ignore, null)
        ospf_network_type                     = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.network_type, null)
        ospf_network_type_broadcast           = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.network_type, null) == "broadcast" ? true : false
        ospf_network_type_non_broadcast       = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.network_type, null) == "non-broadcast" ? true : false
        ospf_network_type_point_to_multipoint = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.network_type, null) == "point-to-multipoint" ? true : false
        ospf_network_type_point_to_point      = try(int.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.network_type, null) == "point-to-point" ? true : false
        ospf_priority                         = try(int.ospf.priority, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.priority, null)
        ospf_ttl_security_hops                = try(int.ospf.ttl_security_hops, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.ttl_security_hops, null)
        ospf_process_ids = try(length(int.ospf.process_ids) == 0, true) ? null : [for pid in int.ospf.process_ids : {
          id    = try(pid.id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.process_ids.id, null)
          areas = try(pid.areas, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.process_ids.areas, null)
        }]
        ospf_message_digest_keys = try(length(int.ospf.message_digest_keys) == 0, true) ? null : [for key in int.ospf.message_digest_keys : {
          id            = try(key.id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.message_digest_keys.id, null)
          md5_auth_key  = try(key.md5_auth_key, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.message_digest_keys.md5_auth_key, null)
          md5_auth_type = try(key.md5_auth_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospf.message_digest_keys.md5_auth_type, null)
        }]
        ospfv3                                  = try(int.ospfv3.network_type, int.ospfv3.cost, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.cost, null) != null ? true : false
        ospfv3_network_type                     = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.network_type, null)
        ospfv3_network_type_broadcast           = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.network_type, null) == "broadcast" ? true : false
        ospfv3_network_type_non_broadcast       = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.network_type, null) == "non-broadcast" ? true : false
        ospfv3_network_type_point_to_multipoint = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.network_type, null) == "point-to-multipoint" ? true : false
        ospfv3_network_type_point_to_point      = try(int.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.network_type, null) == "point-to-point" ? true : false
        ospfv3_cost                             = try(int.ospfv3.cost, local.defaults.iosxe.devices.configuration.interfaces.port_channels.ospfv3.cost, null)
        pim                                     = try(int.pim.passive, int.pim.dense_mode, int.pim.sparse_mode, int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.sparse_dense_mode, null) != null ? true : false
        pim_passive                             = try(int.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.passive, null)
        pim_dense_mode                          = try(int.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.dense_mode, null)
        pim_sparse_mode                         = try(int.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.sparse_mode, null)
        pim_sparse_dense_mode                   = try(int.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.sparse_dense_mode, null)
        pim_bfd                                 = try(int.pim.bfd, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.bfd, null)
        pim_border                              = try(int.pim.border, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.border, null)
        pim_bsr_border                          = try(int.pim.bsr_border, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.bsr_border, null)
        pim_dr_priority                         = try(int.pim.dr_priority, local.defaults.iosxe.devices.configuration.interfaces.port_channels.pim.dr_priority, null)
        auto_qos_classify                       = try(int.auto_qos.classify, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.classify, null)
        auto_qos_classify_police                = try(int.auto_qos.classify_police, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.classify_police, null)
        auto_qos_trust                          = try(int.auto_qos.trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.trust, null)
        auto_qos_trust_cos                      = try(int.auto_qos.trust_cos, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.trust_cos, null)
        auto_qos_trust_dscp                     = try(int.auto_qos.trust_dscp, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.trust_dscp, null)
        auto_qos_video_cts                      = try(int.auto_qos.video_cts, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.video_cts, null)
        auto_qos_video_ip_camera                = try(int.auto_qos.video_ip_camera, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.video_ip_camera, null)
        auto_qos_video_media_player             = try(int.auto_qos.video_media_player, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.video_media_player, null)
        auto_qos_voip                           = try(int.auto_qos.voip, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.voip, null)
        auto_qos_voip_cisco_phone               = try(int.auto_qos.voip_cisco_phone, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.voip_cisco_phone, null)
        auto_qos_voip_cisco_softphone           = try(int.auto_qos.voip_cisco_softphone, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.voip_cisco_softphone, null)
        auto_qos_voip_trust                     = try(int.auto_qos.voip_trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.voip_trust, null)
        trust_device                            = try(int.auto_qos.trust_device, local.defaults.iosxe.devices.configuration.interfaces.port_channels.auto_qos.trust_device, null)
        negotiation_auto                        = try(int.negotiation_auto, local.defaults.iosxe.devices.configuration.interfaces.port_channels.negotiation_auto, null)
      }
    ]
  ])
}

resource "iosxe_interface_port_channel" "port_channel" {
  for_each = { for v in local.interfaces_port_channels : v.key => v }

  device                           = each.value.device
  name                             = each.value.name
  description                      = each.value.description
  shutdown                         = each.value.shutdown
  vrf_forwarding                   = each.value.vrf_forwarding
  ipv4_address                     = each.value.ipv4_address
  ipv4_address_mask                = each.value.ipv4_address_mask
  ip_proxy_arp                     = each.value.ip_proxy_arp
  ip_dhcp_relay_source_interface   = each.value.ip_dhcp_relay_source_interface
  ip_access_group_in_enable        = each.value.ip_access_group_in_enable
  ip_access_group_in               = each.value.ip_access_group_in
  ip_access_group_out_enable       = each.value.ip_access_group_out_enable
  ip_access_group_out              = each.value.ip_access_group_out
  ip_redirects                     = each.value.ip_redirects
  ip_unreachables                  = each.value.ip_unreachables
  ip_arp_inspection_trust          = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate     = each.value.ip_arp_inspection_limit_rate
  ip_dhcp_snooping_trust           = each.value.ip_dhcp_snooping_trust
  helper_addresses                 = each.value.helper_addresses
  ipv6_enable                      = each.value.ipv6_enable
  ipv6_mtu                         = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all          = each.value.ipv6_nd_ra_suppress_all
  ipv6_address_dhcp                = each.value.ipv6_address_dhcp
  ipv6_addresses                   = each.value.ipv6_addresses
  ipv6_link_local_addresses        = each.value.ipv6_link_local_addresses
  ipv6_address_autoconfig_default  = each.value.ipv6_address_autoconfig_default
  bfd_template                     = each.value.bfd_template
  bfd_enable                       = each.value.bfd_enable
  bfd_local_address                = each.value.bfd_local_address
  bfd_interval                     = each.value.bfd_interval
  bfd_interval_min_rx              = each.value.bfd_interval_min_rx
  bfd_interval_multiplier          = each.value.bfd_interval_multiplier
  bfd_echo                         = each.value.bfd_echo
  spanning_tree_guard              = each.value.spanning_tree_guard
  spanning_tree_link_type          = each.value.spanning_tree_link_type
  arp_timeout                      = each.value.arp_timeout
  load_interval                    = each.value.load_interval
  snmp_trap_link_status            = each.value.snmp_trap_link_status
  logging_event_link_status_enable = each.value.logging_event_link_status_enable
  switchport                       = each.value.switchport
  auto_qos_classify                = each.value.auto_qos_classify
  auto_qos_classify_police         = each.value.auto_qos_classify_police
  auto_qos_trust                   = each.value.auto_qos_trust
  auto_qos_trust_cos               = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp              = each.value.auto_qos_trust_dscp
  auto_qos_video_cts               = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera         = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player      = each.value.auto_qos_video_media_player
  auto_qos_voip                    = each.value.auto_qos_voip
  auto_qos_voip_cisco_phone        = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone    = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust              = each.value.auto_qos_voip_trust
  trust_device                     = each.value.trust_device
  negotiation_auto                 = each.value.negotiation_auto
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
  trunk_allowed_vlans           = each.value.switchport_trunk_allowed_vlans
  trunk_allowed_vlans_none      = each.value.switchport_trunk_allowed_vlans_none
  trunk_native_vlan_tag         = each.value.switchport_trunk_native_vlan_tag
  trunk_native_vlan             = each.value.switchport_trunk_native_vlan
  host                          = each.value.switchport_host

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
    iosxe_interface_port_channel.port_channel
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
          description                  = try(sub.description, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.description, null)
          shutdown                     = try(sub.shutdown, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.shutdown, false)
          vrf_forwarding               = try(sub.vrf_forwarding, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.vrf_forwarding, null)
          ipv4_address                 = try(sub.ipv4.address, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.address, null)
          ipv4_address_mask            = try(sub.ipv4.address_mask, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.address_mask, null)
          ip_proxy_arp                 = try(sub.ipv4.proxy_arp, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.proxy_arp, null)
          ip_arp_inspection_trust      = try(sub.ipv4.arp_inspection_trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.arp_inspection_trust, null)
          ip_arp_inspection_limit_rate = try(sub.ipv4.arp_inspection_limit_rate, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.arp_inspection_limit_rate, null)
          helper_addresses = try(length(sub.ipv4.helper_addresses) == 0, true) ? null : [for ha in sub.ipv4.helper_addresses : {
            address = try(ha.address, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.helper_addresses.address, null)
            global  = try(ha.global, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.helper_addresses.global, null)
            vrf     = try(ha.vrf, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.helper_addresses.vrf, null)
          }]
          ip_access_group_in         = try(sub.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.access_group_in, null)
          ip_access_group_in_enable  = try(sub.ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.access_group_in, null) != null ? true : false
          ip_access_group_out        = try(sub.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.access_group_out, null)
          ip_access_group_out_enable = try(sub.ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.access_group_out, null) != null ? true : false
          ip_redirects               = try(sub.ipv4.redirects, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.redirects, null)
          ip_unreachables            = try(sub.ipv4.unreachables, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv4.unreachables, null)
          ipv6_enable                = try(sub.ipv6.enable, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.enable, null)
          ipv6_addresses = try(length(sub.ipv6.addresses) == 0, true) ? null : [for addr in sub.ipv6.addresses : {
            prefix = "${try(addr.prefix, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.addresses.prefix, null)}/${try(addr.prefix_length, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.addresses.prefix_length, null)}"
            eui_64 = try(addr.eui_64, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.addresses.eui_64, null)
          }]
          ipv6_link_local_addresses = try(length(sub.ipv6.link_local_addresses) == 0, true) ? null : [for addr in sub.ipv6.link_local_addresses : {
            address    = addr
            link_local = true
          }]
          ipv6_address_autoconfig_default       = try(sub.ipv6.address_autoconfig_default, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.address_autoconfig_default, null)
          ipv6_address_dhcp                     = try(sub.ipv6.address_dhcp, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.address_dhcp, null)
          ipv6_mtu                              = try(sub.ipv6.mtu, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.mtu, null)
          ipv6_nd_ra_suppress_all               = try(sub.ipv6.nd_ra_suppress_all, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ipv6.nd_ra_suppress_all, null)
          bfd_enable                            = try(sub.bfd.enable, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.enable, null)
          bfd_template                          = try(sub.bfd.template, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.template, null)
          bfd_local_address                     = try(sub.bfd.local_address, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.local_address, null)
          bfd_interval                          = try(sub.bfd.interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.interval, null)
          bfd_interval_min_rx                   = try(sub.bfd.interval_min_rx, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.interval_min_rx, null)
          bfd_interval_multiplier               = try(sub.bfd.interval_multiplier, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.interval_multiplier, null)
          bfd_echo                              = try(sub.bfd.echo, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.bfd.echo, null)
          encapsulation_dot1q_vlan_id           = try(sub.encapsulation_dot1q_vlan_id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.encapsulation_dot1q_vlan_id, null)
          arp_timeout                           = try(sub.arp_timeout, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.arp_timeout, null)
          auto_qos_classify                     = try(sub.auto_qos.classify, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.classify, null)
          auto_qos_classify_police              = try(sub.auto_qos.classify_police, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.classify_police, null)
          auto_qos_trust                        = try(sub.auto_qos.trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.trust, null)
          auto_qos_trust_cos                    = try(sub.auto_qos.trust_cos, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.trust_cos, null)
          auto_qos_trust_dscp                   = try(sub.auto_qos.trust_dscp, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.trust_dscp, null)
          auto_qos_video_cts                    = try(sub.auto_qos.video_cts, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.video_cts, null)
          auto_qos_video_ip_camera              = try(sub.auto_qos.video_ip_camera, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.video_ip_camera, null)
          auto_qos_video_media_player           = try(sub.auto_qos.video_media_player, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.video_media_player, null)
          auto_qos_voip                         = try(sub.auto_qos.voip, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.voip, null)
          auto_qos_voip_cisco_phone             = try(sub.auto_qos.voip_cisco_phone, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.voip_cisco_phone, null)
          auto_qos_voip_cisco_softphone         = try(sub.auto_qos.voip_cisco_softphone, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.voip_cisco_softphone, null)
          auto_qos_voip_trust                   = try(sub.auto_qos.voip_trust, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.voip_trust, null)
          trust_device                          = try(sub.auto_qos.trust_device, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.auto_qos.trust_device, null)
          mpls_ip                               = try(sub.mpls.ip, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.mpls.ip, null)
          mpls_mtu                              = try(sub.mpls.mtu, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.mpls.mtu, null)
          ospf_cost                             = try(sub.ospf.cost, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.cost, null)
          ospf_dead_interval                    = try(sub.ospf.dead_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.dead_interval, null)
          ospf_hello_interval                   = try(sub.ospf.hello_interval, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.hello_interval, null)
          ospf_mtu_ignore                       = try(sub.ospf.mtu_ignore, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.mtu_ignore, null)
          ospf                                  = try(sub.ospf, null) != null ? true : false
          ospf_network_type_broadcast           = try(sub.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.network_type, null) == "broadcast" ? true : null
          ospf_network_type_non_broadcast       = try(sub.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.network_type, null) == "non-broadcast" ? true : null
          ospf_network_type_point_to_multipoint = try(sub.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.network_type, null) == "point-to-multipoint" ? true : null
          ospf_network_type_point_to_point      = try(sub.ospf.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.network_type, null) == "point-to-point" ? true : null
          ospf_priority                         = try(sub.ospf.priority, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.priority, null)
          ospf_ttl_security_hops                = try(sub.ospf.ttl_security_hops, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.ttl_security_hops, null)
          ospf_process_ids = try(length(sub.ospf.process_ids) == 0, true) ? null : [for pid in sub.ospf.process_ids : {
            id = try(pid.id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.process_ids.id, null)
            areas = try(length(pid.areas) == 0, true) ? null : [for area in pid.areas : {
              area_id = area
            }]
          }]
          ospf_message_digest_keys = try(length(sub.ospf.message_digest_keys) == 0, true) ? null : [for key in sub.ospf.message_digest_keys : {
            id            = try(key.id, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.message_digest_keys.id, null)
            md5_auth_key  = try(key.md5_auth_key, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.message_digest_keys.md5_auth_key, null)
            md5_auth_type = try(key.md5_auth_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospf.message_digest_keys.md5_auth_type, null)
          }]
          ospfv3                                  = try(sub.ospfv3, null) != null ? true : false
          ospfv3_network_type_broadcast           = try(sub.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospfv3.network_type, null) == "broadcast" ? true : null
          ospfv3_network_type_non_broadcast       = try(sub.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospfv3.network_type, null) == "non-broadcast" ? true : null
          ospfv3_network_type_point_to_multipoint = try(sub.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospfv3.network_type, null) == "point-to-multipoint" ? true : null
          ospfv3_network_type_point_to_point      = try(sub.ospfv3.network_type, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospfv3.network_type, null) == "point-to-point" ? true : null
          ospfv3_cost                             = try(sub.ospfv3.cost, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.ospfv3.cost, null)
          pim                                     = try(sub.pim.passive, sub.pim.dense_mode, sub.pim.sparse_mode, sub.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.sparse_dense_mode, null) != null ? true : false
          pim_passive                             = try(sub.pim.passive, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.passive, null)
          pim_dense_mode                          = try(sub.pim.dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.dense_mode, null)
          pim_sparse_mode                         = try(sub.pim.sparse_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.sparse_mode, null)
          pim_sparse_dense_mode                   = try(sub.pim.sparse_dense_mode, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.sparse_dense_mode, null)
          pim_bfd                                 = try(sub.pim.bfd, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.bfd, null)
          pim_border                              = try(sub.pim.border, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.border, null)
          pim_bsr_border                          = try(sub.pim.bsr_border, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.bsr_border, null)
          pim_dr_priority                         = try(sub.pim.dr_priority, local.defaults.iosxe.devices.configuration.interfaces.port_channels.subinterfaces.pim.dr_priority, null)
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
  vrf_forwarding                  = each.value.vrf_forwarding
  ipv4_address                    = each.value.ipv4_address
  ipv4_address_mask               = each.value.ipv4_address_mask
  ip_access_group_in_enable       = each.value.ip_access_group_in_enable
  ip_access_group_in              = each.value.ip_access_group_in
  ip_access_group_out_enable      = each.value.ip_access_group_out_enable
  ip_access_group_out             = each.value.ip_access_group_out
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
  arp_timeout                     = each.value.arp_timeout
  auto_qos_classify               = each.value.auto_qos_classify
  auto_qos_classify_police        = each.value.auto_qos_classify_police
  auto_qos_trust                  = each.value.auto_qos_trust
  auto_qos_trust_cos              = each.value.auto_qos_trust_cos
  auto_qos_trust_dscp             = each.value.auto_qos_trust_dscp
  auto_qos_video_cts              = each.value.auto_qos_video_cts
  auto_qos_video_ip_camera        = each.value.auto_qos_video_ip_camera
  auto_qos_video_media_player     = each.value.auto_qos_video_media_player
  auto_qos_voip                   = each.value.auto_qos_voip
  auto_qos_voip_cisco_phone       = each.value.auto_qos_voip_cisco_phone
  auto_qos_voip_cisco_softphone   = each.value.auto_qos_voip_cisco_softphone
  auto_qos_voip_trust             = each.value.auto_qos_voip_trust
  trust_device                    = each.value.trust_device
  ip_arp_inspection_trust         = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate    = each.value.ip_arp_inspection_limit_rate

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_policy_map.policy_map
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
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}

##### NVE #####

locals {
  nves = flatten([
    for device in local.devices : [
      for nve in try(local.device_config[device.name].interfaces.nves, []) : {
        key    = format("%s/%s", device.name, nve.id)
        device = device.name

        id                             = try(nve.id, local.defaults.iosxe.configuration.interfaces.nves.name.id, null)
        description                    = try(nve.description, local.defaults.iosxe.configuration.interfaces.nves.description, null)
        shutdown                       = try(nve.shutdown, local.defaults.iosxe.configuration.interfaces.nves.name.shutdown, null)
        host_reachability_protocol_bgp = try(nve.host_reachability_protocol_bgp, local.defaults.iosxe.configuration.interfaces.nves.name.host_reachability_protocol_bgp, null)
        source_interface_loopback      = try(nve.source_interface_type, local.defaults.iosxe.configuration.interfaces.nves.name.source_interface_type, null) == "Loopback" ? try(nve.source_interface_id, local.defaults.iosxe.configuration.interfaces.nves.name.source_interface_id, null) : null

        # Lists
        vni_vrfs = try(length(nve.vni_vrfs) == 0, true) ? null : [for vni_vrf in nve.vni_vrfs : {
          vni_range = "${vni_vrf.vni_from}${try(vni_vrf.vni_to, null) != null ? format("-%s", vni_vrf.vni_to) : ""}"
          vrf       = try(vni_vrf.vrf, local.defaults.iosxe.configuration.interfaces.nves.vni_vrfs.vrf, null)
          }
        ]

        vnis = try(length(nve.vnis) == 0, true) ? null : [for vni in nve.vnis : {
          vni_range            = "${vni.vni_from}${try(vni.vni_to, null) != null ? format("-%s", vni.vni_to) : ""}"
          ipv4_multicast_group = try(vni.ipv4_multicast_group, local.defaults.iosxe.configuration.interfaces.nves.vnis.ipv4_multicast_group, null)
          ingress_replication  = try(vni.ingress_replication, local.defaults.iosxe.configuration.interfaces.nves.vnis.ingress_replication, null)
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