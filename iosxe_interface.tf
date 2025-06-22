locals {
  interfaces_ethernets_group = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.ethernets, []) : {
        key           = format("%s/%s", device.name, int.id)
        configuration = yamldecode(provider::utils::yaml_merge([for g in try(int.interface_groups, []) : try([for ig in local.interface_groups : yamlencode(ig.configuration) if ig.name == g][0], "")]))
      }
    ]
  ])
  interfaces_ethernets_group_config = {
    for int in local.interfaces_ethernets_group : int.key => int.configuration
  }
  interfaces_ethernets = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.ethernets, []) : {
        key                            = format("%s/%s", device.name, int.id)
        device                         = device.name
        id                             = int.id
        type                           = try(int.type, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.type, null)
        media_type                     = try(int.media_type, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].media_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.media_type, null)
        bandwidth                      = try(int.bandwidth, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bandwidth, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bandwidth, null)
        description                    = try(int.description, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].description, local.defaults.iosxe.devices.configuration.interfaces.ethernets.description, null)
        shutdown                       = try(int.shutdown, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].shutdown, local.defaults.iosxe.devices.configuration.interfaces.ethernets.shutdown, false)
        vrf_forwarding                 = try(int.vrf_forwarding, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].vrf_forwarding, local.defaults.iosxe.devices.configuration.interfaces.ethernets.vrf_forwarding, null)
        ipv4_address                   = try(int.ipv4.address, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.address, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.address, null)
        ipv4_address_mask              = try(int.ipv4.address_mask, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.address_mask, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.address_mask, null)
        ip_proxy_arp                   = try(int.ipv4.proxy_arp, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.proxy_arp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.proxy_arp, null)
        ip_arp_inspection_trust        = try(int.ipv4.arp_inspection_trust, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.arp_inspection_trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.arp_inspection_trust, null)
        ip_arp_inspection_limit_rate   = try(int.ipv4.arp_inspection_limit_rate, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.arp_inspection_limit_rate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.arp_inspection_limit_rate, null)
        ip_dhcp_snooping_trust         = try(int.ipv4.dhcp_snooping_trust, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.dhcp_snooping_trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.dhcp_snooping_trust, null)
        ip_dhcp_relay_source_interface = try(int.ipv4.dhcp_relay_source_interface, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.dhcp_relay_source_interface, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.dhcp_relay_source_interface, null)
        helper_addresses = [for ha in try(int.ipv4.helper_addresses, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.helper_addresses, []) : {
          address = ha.address
          global  = try(ha.global, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.helper_addresses.global, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.helper_addresses.global, null)
          vrf     = try(ha.vrf, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.helper_addresses.vrf, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.helper_addresses.vrf, null)
        }]
        ip_access_group_in         = try(int.ipv4.access_group_in, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_in, null)
        ip_access_group_in_enable  = try(int.ipv4.access_group_in, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.access_group_in, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_in, null) != null ? true : false
        ip_access_group_out        = try(int.ipv4.access_group_out, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_out, null)
        ip_access_group_out_enable = try(int.ipv4.access_group_out, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.access_group_out, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.access_group_out, null) != null ? true : false
        ip_flow_monitors = [for fm in try(int.ipv4.flow_monitors, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.flow_monitors, []) : {
          name      = fm.name
          direction = try(fm.direction, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.flow_monitors.direction, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.flow_monitors.direction, null)
        }]
        ip_redirects    = try(int.ipv4.redirects, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.redirects, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.redirects, null)
        ip_unreachables = try(int.ipv4.unreachables, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.unreachables, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.unreachables, null)
        unnumbered      = try(int.ipv4.unnumbered, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv4.unnumbered, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv4.unnumbered, null)
        source_template = try(int.source_template, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].source_template, local.defaults.iosxe.devices.configuration.interfaces.ethernets.source_template, [])
        ipv6_enable     = try(int.ipv6.enable, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.enable, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.enable, null)
        ipv6_addresses = [for addr in try(int.ipv6.addresses, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.addresses, []) : {
          prefix = "${addr.prefix}/${addr.prefix_length}"
          eui64  = try(addr.eui64, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.addresses.eui64, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.addresses.eui64, null)
        }]
        ipv6_link_local_addresses = [for addr in try(int.ipv6.link_local_addresses, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.link_local_addresses, []) : {
          address    = addr
          link_local = true
        }]
        ipv6_address_autoconfig_default = try(int.ipv6.address_autoconfig_default, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.address_autoconfig_default, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.address_autoconfig_default, null)
        ipv6_address_dhcp               = try(int.ipv6.address_dhcp, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.address_dhcp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.address_dhcp, null)
        ipv6_mtu                        = try(int.ipv6.mtu, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.mtu, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.mtu, null)
        ipv6_nd_ra_suppress_all         = try(int.ipv6.nd_ra_suppress_all, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].ipv6.nd_ra_suppress_all, local.defaults.iosxe.devices.configuration.interfaces.ethernets.ipv6.nd_ra_suppress_all, null)
        bfd_enable                      = try(int.bfd.enable, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.enable, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.enable, null)
        bfd_template                    = try(int.bfd.template, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.template, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.template, null)
        bfd_local_address               = try(int.bfd.local_address, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.local_address, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.local_address, null)
        bfd_interval                    = try(int.bfd.interval, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.interval, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.interval, null)
        bfd_interval_min_rx             = try(int.bfd.interval_min_rx, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.interval_min_rx, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.interval_min_rx, null)
        bfd_interval_multiplier         = try(int.bfd.interval_multiplier, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.interval_multiplier, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.interval_multiplier, null)
        bfd_echo                        = try(int.bfd.echo, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].bfd.echo, local.defaults.iosxe.devices.configuration.interfaces.ethernets.bfd.echo, null)
        spanning_tree_guard             = try(int.spanning_tree.guard, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].spanning_tree.guard, local.defaults.iosxe.devices.configuration.interfaces.ethernets.spanning_tree.guard, null)
        spanning_tree_link_type         = try(int.spanning_tree.link_type, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].spanning_tree.link_type, local.defaults.iosxe.devices.configuration.interfaces.ethernets.spanning_tree.link_type, null)
        spanning_tree_portfast_trunk    = try(int.spanning_tree.portfast_trunk, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].spanning_tree.portfast_trunk, local.defaults.iosxe.devices.configuration.interfaces.ethernets.spanning_tree.portfast_trunk, null)
        speed_100                       = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 100 ? true : null
        speed_1000                      = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 1000 ? true : null
        speed_2500                      = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 2500 ? true : null
        speed_5000                      = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 5000 ? true : null
        speed_10000                     = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 10000 ? true : null
        speed_25000                     = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 25000 ? true : null
        speed_40000                     = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 40000 ? true : null
        speed_100000                    = try(int.speed, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed, null) == 100000 ? true : null
        speed_nonegotiate               = try(int.speed_nonegotiate, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].speed_nonegotiate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.speed_nonegotiate, null)
        channel_group_number            = try(int.port_channel_id, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].port_channel_id, local.defaults.iosxe.devices.configuration.interfaces.ethernets.port_channel_id, null)
        channel_group_mode              = try(int.port_channel_mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].port_channel_mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.port_channel_mode, null)
        source_templates = [for st in try(int.source_templates, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].source_templates, []) : {
          template_name = st.name
          merge         = try(st.merge, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].source_templates.merge, local.defaults.iosxe.devices.configuration.interfaces.ethernets.source_templates.merge, null)
        }]
        arp_timeout                              = try(int.arp_timeout, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].arp_timeout, local.defaults.iosxe.devices.configuration.interfaces.ethernets.arp_timeout, null)
        negotiation_auto                         = try(int.negotiation_auto, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].negotiation_auto, local.defaults.iosxe.devices.configuration.interfaces.ethernets.negotiation_auto, null)
        service_policy_input                     = try(int.service_policy_input, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].service_policy_input, local.defaults.iosxe.devices.configuration.interfaces.ethernets.service_policy_input, null)
        service_policy_output                    = try(int.service_policy_output, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].service_policy_output, local.defaults.iosxe.devices.configuration.interfaces.ethernets.service_policy_output, null)
        load_interval                            = try(int.load_interval, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].load_interval, local.defaults.iosxe.devices.configuration.interfaces.ethernets.load_interval, null)
        snmp_trap_link_status                    = try(int.snmp_trap_link_status, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].snmp_trap_link_status, local.defaults.iosxe.devices.configuration.interfaces.ethernets.snmp_trap_link_status, null)
        logging_event_link_status_enable         = try(int.logging_event_link_status, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].logging_event_link_status, local.defaults.iosxe.devices.configuration.interfaces.ethernets.logging_event_link_status, null)
        switchport                               = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) != null ? true : false
        switchport_access_vlan                   = try(int.switchport.access_vlan, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.access_vlan, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.access_vlan, null)
        switchport_mode_access                   = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "access" ? true : null
        switchport_mode_trunk                    = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "trunk" ? true : null
        switchport_mode_dot1q_tunnel             = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "dot1q-tunnel" ? true : null
        switchport_mode_private_vlan_trunk       = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "private-vlan-trunk" ? true : null
        switchport_mode_private_vlan_host        = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "private-vlan-host" ? true : null
        switchport_mode_private_vlan_promiscuous = try(int.switchport.mode, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.mode, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.mode, null) == "private-vlan-promiscuous" ? true : null
        switchport_nonegotiate                   = try(int.switchport.nonegotiate, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.nonegotiate, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.nonegotiate, null)
        switchport_trunk_allowed_vlans           = try(int.switchport.trunk_allowed_vlans, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.trunk_allowed_vlans, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_allowed_vlans, null)
        switchport_trunk_native_vlan_tag         = try(int.switchport.trunk_native_vlan_tag, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.trunk_native_vlan_tag, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_native_vlan_tag, null)
        switchport_trunk_native_vlan             = try(int.switchport.trunk_native_vlan, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.trunk_native_vlan, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.trunk_native_vlan, null)
        switchport_host                          = try(int.switchport.host, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].switchport.host, local.defaults.iosxe.devices.configuration.interfaces.ethernets.switchport.host, null)
        auto_qos_classify                        = try(int.auto_qos.classify, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.classify, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.classify, null)
        auto_qos_classify_police                 = try(int.auto_qos.classify_police, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.classify_police, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.classify_police, null)
        auto_qos_trust                           = try(int.auto_qos.trust, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust, null)
        auto_qos_trust_cos                       = try(int.auto_qos.trust_cos, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.trust_cos, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust_cos, null)
        auto_qos_trust_dscp                      = try(int.auto_qos.trust_dscp, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.trust_dscp, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust_dscp, null)
        auto_qos_video_cts                       = try(int.auto_qos.video_cts, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.video_cts, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.video_cts, null)
        auto_qos_video_ip_camera                 = try(int.auto_qos.video_ip_camera, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.video_ip_camera, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.video_ip_camera, null)
        auto_qos_video_media_player              = try(int.auto_qos.video_media_player, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.video_media_player, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.video_media_player, null)
        auto_qos_voip                            = try(int.auto_qos.voip, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.voip, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip, null)
        auto_qos_voip_cisco_phone                = try(int.auto_qos.voip_cisco_phone, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.voip_cisco_phone, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip_cisco_phone, null)
        auto_qos_voip_cisco_softphone            = try(int.auto_qos.voip_cisco_softphone, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.voip_cisco_softphone, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip_cisco_softphone, null)
        auto_qos_voip_trust                      = try(int.auto_qos.voip_trust, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.voip_trust, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.voip_trust, null)
        trust_device                             = try(int.auto_qos.trust_device, local.interfaces_ethernets_group_config[format("%s/%s", device.name, int.id)].auto_qos.trust_device, local.defaults.iosxe.devices.configuration.interfaces.ethernets.auto_qos.trust_device, null)
      }
    ]
  ])
}

resource "iosxe_interface_ethernet" "ethernet" {
  for_each                         = { for v in local.interfaces_ethernets : v.key => v }
  device                           = each.value.device
  type                             = each.value.type
  name                             = each.value.id
  media_type                       = each.value.media_type
  bandwidth                        = each.value.bandwidth
  description                      = each.value.description
  shutdown                         = each.value.shutdown
  vrf_forwarding                   = each.value.vrf_forwarding
  ipv4_address                     = each.value.ipv4_address
  ipv4_address_mask                = each.value.ipv4_address_mask
  ip_proxy_arp                     = each.value.ip_proxy_arp
  ip_arp_inspection_trust          = each.value.ip_arp_inspection_trust
  ip_arp_inspection_limit_rate     = each.value.ip_arp_inspection_limit_rate
  ip_dhcp_snooping_trust           = each.value.ip_dhcp_snooping_trust
  ip_dhcp_relay_source_interface   = each.value.ip_dhcp_relay_source_interface
  helper_addresses                 = each.value.helper_addresses
  ip_access_group_in               = each.value.ip_access_group_in
  ip_access_group_in_enable        = each.value.ip_access_group_in_enable
  ip_access_group_out              = each.value.ip_access_group_out
  ip_access_group_out_enable       = each.value.ip_access_group_out_enable
  ip_flow_monitors                 = each.value.ip_flow_monitors
  ip_redirects                     = each.value.ip_redirects
  ip_unreachables                  = each.value.ip_unreachables
  unnumbered                       = each.value.unnumbered
  ipv6_address_autoconfig_default  = each.value.ipv6_address_autoconfig_default
  ipv6_address_dhcp                = each.value.ipv6_address_dhcp
  ipv6_addresses                   = each.value.ipv6_addresses
  ipv6_enable                      = each.value.ipv6_enable
  ipv6_link_local_addresses        = each.value.ipv6_link_local_addresses
  ipv6_mtu                         = each.value.ipv6_mtu
  ipv6_nd_ra_suppress_all          = each.value.ipv6_nd_ra_suppress_all
  bfd_enable                       = each.value.bfd_enable
  bfd_template                     = each.value.bfd_template
  bfd_local_address                = each.value.bfd_local_address
  bfd_interval                     = each.value.bfd_interval
  bfd_interval_min_rx              = each.value.bfd_interval_min_rx
  bfd_interval_multiplier          = each.value.bfd_interval_multiplier
  bfd_echo                         = each.value.bfd_echo
  spanning_tree_guard              = each.value.spanning_tree_guard
  spanning_tree_link_type          = each.value.spanning_tree_link_type
  spanning_tree_portfast_trunk     = each.value.spanning_tree_portfast_trunk
  speed_100                        = each.value.speed_100
  speed_1000                       = each.value.speed_1000
  speed_2500                       = each.value.speed_2500
  speed_5000                       = each.value.speed_5000
  speed_10000                      = each.value.speed_10000
  speed_25000                      = each.value.speed_25000
  speed_40000                      = each.value.speed_40000
  speed_100000                     = each.value.speed_100000
  speed_nonegotiate                = each.value.speed_nonegotiate
  channel_group_number             = each.value.channel_group_number
  channel_group_mode               = each.value.channel_group_mode
  source_template                  = each.value.source_templates
  arp_timeout                      = each.value.arp_timeout
  negotiation_auto                 = each.value.negotiation_auto
  service_policy_input             = each.value.service_policy_input
  service_policy_output            = each.value.service_policy_output
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
}

resource "iosxe_interface_switchport" "ethernet_switchport" {
  for_each = { for v in local.interfaces_ethernets : v.key => v if v.switchport == true }

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
  trunk_native_vlan_tag         = each.value.switchport_trunk_native_vlan_tag
  trunk_native_vlan             = each.value.switchport_trunk_native_vlan
  host                          = each.value.switchport_host
}