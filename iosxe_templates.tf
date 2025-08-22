locals {
  templates = flatten([
    for device in local.devices : [
      for template in try(local.device_config[device.name].templates, []) : {
        key                                            = format("%s/%s", device.name, template.name)
        device                                         = device.name
        name                                           = template.name
        dot1x_pae                                      = try(template.network_access_control.dot1x_pae, local.defaults.iosxe.configuration.templates.network_access_control.dot1x_pae, null)
        dot1x_max_reauth_req                           = try(template.network_access_control.dot1x_max_reauth_req, local.defaults.iosxe.configuration.templates.network_access_control.dot1x_max_reauth_req, null)
        dot1x_max_req                                  = try(template.network_access_control.dot1x_max_req, local.defaults.iosxe.configuration.templates.network_access_control.dot1x_max_req, null)
        dot1x_timeout_tx_period                        = try(template.network_access_control.dot1x_timeout_tx_period, local.defaults.iosxe.configuration.templates.network_access_control.dot1x_timeout_tx_period, null)
        service_policy_type_control_subscriber         = try(template.service_policy_type_control_subscriber, local.defaults.iosxe.configuration.templates.service_policy_type_control_subscriber, null)
        service_policy_input                           = try(template.service_policy_input, local.defaults.iosxe.configuration.templates.service_policy_input, null)
        service_policy_output                          = try(template.service_policy_output, local.defaults.iosxe.configuration.templates.service_policy_output, null)
        source_template                                = try(template.source_template, local.defaults.iosxe.configuration.templates.source_template, null)
        switchport_mode_trunk                          = try(template.switchport.mode, local.defaults.iosxe.configuration.templates.switchport.mode, null) == "trunk" ? true : false
        switchport_mode_access                         = try(template.switchport.mode, local.defaults.iosxe.configuration.templates.switchport.mode, null) == "access" ? true : false
        switchport_nonegotiate                         = try(template.switchport.nonegotiate, local.defaults.iosxe.configuration.templates.switchport.nonegotiate, null)
        switchport_block_unicast                       = try(template.switchport.block_unicast, local.defaults.iosxe.configuration.templates.switchport.block_unicast, null)
        switchport_port_security                       = try(template.switchport.port_security, local.defaults.iosxe.configuration.templates.switchport.port_security, null)
        switchport_port_security_aging_static          = try(template.switchport.port_security_aging_static, local.defaults.iosxe.configuration.templates.switchport.port_security_aging_static, null)
        switchport_port_security_aging_time            = try(template.switchport.port_security_aging_time, local.defaults.iosxe.configuration.templates.switchport.port_security_aging_time, null)
        switchport_port_security_aging_type            = try(template.switchport.port_security_aging_type, local.defaults.iosxe.configuration.templates.switchport.port_security_aging_type, null)
        switchport_port_security_aging_type_inactivity = try(template.switchport.port_security_aging_type_inactivity, local.defaults.iosxe.configuration.templates.switchport.port_security_aging_type_inactivity, null)
        switchport_port_security_maximum_range = try(length(template.switchport.port_security_maximum_ranges) == 0, true) ? null : [for range in template.switchport.port_security_maximum_ranges : {
          range       = try(range.range, local.defaults.iosxe.configuration.templates.switchport.port_security_maximum_ranges.range, null)
          vlan        = try(range.vlan, local.defaults.iosxe.configuration.templates.switchport.port_security_maximum_ranges.vlans, null)
          vlan_access = try(range.vlan_access, local.defaults.iosxe.configuration.templates.switchport.port_security_maximum_ranges.vlan_access, null)
        }]
        switchport_port_security_violation_protect               = try(template.switchport.port_security_violation_protect, local.defaults.iosxe.configuration.templates.switchport.port_security_violation_protect, null)
        switchport_port_security_violation_restrict              = try(template.switchport.port_security_violation_restrict, local.defaults.iosxe.configuration.templates.switchport.port_security_violation_restrict, null)
        switchport_port_security_violation_shutdown              = try(template.switchport.port_security_violation_shutdown, local.defaults.iosxe.configuration.templates.switchport.port_security_violation_shutdown, null)
        switchport_access_vlan                                   = try(template.switchport.access_vlan, local.defaults.iosxe.configuration.templates.switchport.access_vlan, null)
        switchport_voice_vlan                                    = try(template.switchport.voice_vlan, local.defaults.iosxe.configuration.templates.switchport.voice_vlan, null)
        switchport_private_vlan_host_association_primary_range   = try(template.switchport.private_vlan_host_association_primary_range, local.defaults.iosxe.configuration.templates.switchport.private_vlan_host_association_primary_range, null)
        switchport_private_vlan_host_association_secondary_range = try(template.switchport.private_vlan_host_association_secondary_range, local.defaults.iosxe.configuration.templates.switchport.private_vlan_host_association_secondary_range, null)
        switchport_trunk_allowed_vlans                           = try(template.switchport.trunk_allowed_vlans, local.defaults.iosxe.configuration.templates.switchport.trunk_allowed_vlans, null)
        switchport_trunk_allowed_vlans_none                      = try(template.switchport.trunk_allowed_vlans_none, local.defaults.iosxe.configuration.templates.switchport.trunk_allowed_vlans_none, null)
        switchport_trunk_allowed_vlans_all                       = try(template.switchport.trunk_allowed_vlans_all, local.defaults.iosxe.configuration.templates.switchport.trunk_allowed_vlans_all, null)
        switchport_trunk_native_vlan_tag                         = try(template.switchport.trunk_native_vlan_tag, local.defaults.iosxe.configuration.templates.switchport.trunk_native_vlan_tag, null)
        switchport_trunk_native_vlan_vlan_id                     = try(template.switchport.trunk_native_vlan_id, local.defaults.iosxe.configuration.templates.switchport.trunk_native_vlan, null)
        mab                                                      = try(template.network_access_control.mab, local.defaults.iosxe.configuration.templates.network_access_control.mab, null)
        mab_eap                                                  = try(template.network_access_control.mab_eap, local.defaults.iosxe.configuration.templates.network_access_control.mab_eap, null)
        access_session_closed                                    = try(template.network_access_control.access_session_closed, local.defaults.iosxe.configuration.templates.network_access_control.access_session_closed, null)
        access_session_monitor                                   = try(template.network_access_control.access_session_monitor, local.defaults.iosxe.configuration.templates.network_access_control.access_session_monitor, null)
        access_session_port_control                              = try(template.network_access_control.access_session_port_control, local.defaults.iosxe.configuration.templates.network_access_control.access_session_port_control, null)
        access_session_control_direction                         = try(template.network_access_control.access_session_control_direction, local.defaults.iosxe.configuration.templates.network_access_control.access_session_control_direction, null)
        access_session_host_mode                                 = try(template.network_access_control.access_session_host_mode, local.defaults.iosxe.configuration.templates.network_access_control.access_session_host_mode, null)
        access_session_interface_template_sticky                 = try(template.network_access_control.access_session_interface_template_sticky, local.defaults.iosxe.configuration.templates.network_access_control.access_session_interface_template_sticky, null)
        access_session_interface_template_sticky_timer           = try(template.network_access_control.access_session_interface_template_sticky_timer, local.defaults.iosxe.configuration.templates.network_access_control.access_session_interface_template_sticky_timer, null)
        authentication_periodic                                  = try(template.network_access_control.authentication_periodic, local.defaults.iosxe.configuration.templates.network_access_control.authentication_periodic, null)
        authentication_timer_reauthenticate_server               = try(template.network_access_control.authentication_timer_reauthenticate_server, local.defaults.iosxe.configuration.templates.network_access_control.authentication_timer_reauthenticate_server, null)
        authentication_timer_reauthenticate_range                = try(template.network_access_control.authentication_timer_reauthenticate_range, local.defaults.iosxe.configuration.templates.network_access_control.authentication_timer_reauthenticate_range, null)
        spanning_tree_bpduguard_enable                           = try(template.spanning_tree.bpduguard, local.defaults.iosxe.configuration.templates.spanning_tree.bpduguard, null)
        spanning_tree_service_policy                             = try(template.spanning_tree.service_policy, local.defaults.iosxe.configuration.templates.spanning_tree.service_policy, null)
        spanning_tree_portfast                                   = try(template.spanning_tree.portfast, local.defaults.iosxe.configuration.templates.spanning_tree.portfast, null)
        spanning_tree_portfast_disable                           = try(template.spanning_tree.portfast_disable, local.defaults.iosxe.configuration.templates.spanning_tree.portfast_disable, null)
        spanning_tree_portfast_edge                              = try(template.spanning_tree.portfast_edge, local.defaults.iosxe.configuration.templates.spanning_tree.portfast_edge, null)
        spanning_tree_portfast_network                           = try(template.spanning_tree.portfast_network, local.defaults.iosxe.configuration.templates.spanning_tree.portfast_network, null)
        storm_control_broadcast_level_pps_threshold              = try(template.storm_control.broadcast_level_pps_threshold, local.defaults.iosxe.configuration.templates.storm_control.broadcast_level_pps_threshold, null)
        storm_control_broadcast_level_bps_threshold              = try(template.storm_control.broadcast_level_bps_threshold, local.defaults.iosxe.configuration.templates.storm_control.broadcast_level_bps_threshold, null)
        storm_control_broadcast_level_threshold                  = try(template.storm_control.broadcast_level_threshold, local.defaults.iosxe.configuration.templates.storm_control.broadcast_level_threshold, null)
        storm_control_multicast_level_pps_threshold              = try(template.storm_control.multicast_level_pps_threshold, local.defaults.iosxe.configuration.templates.storm_control.multicast_level_pps_threshold, null)
        storm_control_multicast_level_bps_threshold              = try(template.storm_control.multicast_level_bps_threshold, local.defaults.iosxe.configuration.templates.storm_control.multicast_level_bps_threshold, null)
        storm_control_multicast_level_threshold                  = try(template.storm_control.multicast_level_threshold, local.defaults.iosxe.configuration.templates.storm_control.multicast_level_threshold, null)
        storm_control_action_shutdown                            = try(template.storm_control.action_shutdown, local.defaults.iosxe.configuration.templates.storm_control.action_shutdown, null)
        storm_control_action_trap                                = try(template.storm_control.action_trap, local.defaults.iosxe.configuration.templates.storm_control.action_trap, null)
        load_interval                                            = try(template.load_interval, local.defaults.iosxe.configuration.templates.load_interval, null)
        ip_dhcp_snooping_limit_rate                              = try(template.ipv4.dhcp_snooping_limit_rate, local.defaults.iosxe.configuration.templates.ipv4.dhcp_snooping_limit_rate, null)
        ip_dhcp_snooping_trust                                   = try(template.ipv4.dhcp_snooping_trust, local.defaults.iosxe.configuration.templates.ipv4.dhcp_snooping_trust, null)
        ip_access_group = concat(
          try(template.ipv4.access_group_in, local.defaults.iosxe.configuration.templates.ipv4.access_group_in, null) != null ? [{
            direction   = "in"
            access_list = try(template.ipv4.access_group_in, local.defaults.iosxe.configuration.templates.ipv4.access_group_in, null)
          }] : [],
          try(template.ipv4.access_group_out, local.defaults.iosxe.configuration.templates.ipv4.access_group_out, null) != null ? [{
            direction   = "out"
            access_list = try(template.ipv4.access_group_out, local.defaults.iosxe.configuration.templates.ipv4.access_group_out, null)
          }] : []
        )
        subscriber_aging_inactivity_timer_probe = try(template.subscriber_aging_inactivity_timer_probe, local.defaults.iosxe.configuration.templates.subscriber_aging_inactivity_timer_probe, null)
        subscriber_aging_inactivity_timer_value = try(template.subscriber_aging_inactivity_timer_value, local.defaults.iosxe.configuration.templates.subscriber_aging_inactivity_timer_value, null)
        subscriber_aging_probe                  = try(template.subscriber_aging_probe, local.defaults.iosxe.configuration.templates.subscriber_aging_probe, null)
        device_tracking                         = try(template.device_tracking, local.defaults.iosxe.configuration.templates.device_tracking, null)
        device_tracking_attach_policy = try(length(template.device_tracking_attached_policies) == 0, true) ? null : [for policy in template.device_tracking_attached_policies : {
          policy_name = try(policy.name, local.defaults.iosxe.configuration.templates.device_tracking_attached_policies.name, null)
          vlan_range  = try(policy.vlan_range, local.defaults.iosxe.configuration.templates.device_tracking_attached_policies.vlan_range, null)
        }]
        device_tracking_vlan_range       = try(template.device_tracking_vlan_range, local.defaults.iosxe.configuration.templates.device_tracking_vlan_range, null)
        cts_manual                       = try(template.network_access_control.cts_manual, local.defaults.iosxe.configuration.templates.network_access_control.cts_manual, null)
        cts_manual_policy_static_sgt     = try(template.network_access_control.cts_manual_policy_static_sgt, local.defaults.iosxe.configuration.templates.network_access_control.cts_manual_policy_static_sgt, null)
        cts_manual_policy_static_trusted = try(template.network_access_control.cts_manual_policy_static_trusted, local.defaults.iosxe.configuration.templates.network_access_control.cts_manual_policy_static_trusted, null)
        cts_manual_propagate_sgt         = try(template.network_access_control.cts_manual_propagate_sgt, local.defaults.iosxe.configuration.templates.network_access_control.cts_manual_propagate_sgt, null)
        cts_role_based_enforcement       = try(template.network_access_control.cts_role_based_enforcement, local.defaults.iosxe.configuration.templates.network_access_control.cts_role_based_enforcement, null)
      }
    ]
  ])
}

resource "iosxe_template" "template" {
  for_each                                                 = { for e in local.templates : e.key => e }
  device                                                   = each.value.device
  template_name                                            = each.value.name
  dot1x_pae                                                = each.value.dot1x_pae
  dot1x_max_reauth_req                                     = each.value.dot1x_max_reauth_req
  dot1x_max_req                                            = each.value.dot1x_max_req
  dot1x_timeout_tx_period                                  = each.value.dot1x_timeout_tx_period
  service_policy_type_control_subscriber                   = each.value.service_policy_type_control_subscriber
  service_policy_input                                     = each.value.service_policy_input
  service_policy_output                                    = each.value.service_policy_output
  source_template                                          = each.value.source_template
  switchport_mode_trunk                                    = each.value.switchport_mode_trunk
  switchport_mode_access                                   = each.value.switchport_mode_access
  switchport_nonegotiate                                   = each.value.switchport_nonegotiate
  switchport_block_unicast                                 = each.value.switchport_block_unicast
  switchport_port_security                                 = each.value.switchport_port_security
  switchport_port_security_aging_static                    = each.value.switchport_port_security_aging_static
  switchport_port_security_aging_time                      = each.value.switchport_port_security_aging_time
  switchport_port_security_aging_type                      = each.value.switchport_port_security_aging_type
  switchport_port_security_aging_type_inactivity           = each.value.switchport_port_security_aging_type_inactivity
  switchport_port_security_maximum_range                   = each.value.switchport_port_security_maximum_range
  switchport_port_security_violation_protect               = each.value.switchport_port_security_violation_protect
  switchport_port_security_violation_restrict              = each.value.switchport_port_security_violation_restrict
  switchport_port_security_violation_shutdown              = each.value.switchport_port_security_violation_shutdown
  switchport_access_vlan                                   = each.value.switchport_access_vlan
  switchport_voice_vlan                                    = each.value.switchport_voice_vlan
  switchport_private_vlan_host_association_primary_range   = each.value.switchport_private_vlan_host_association_primary_range
  switchport_private_vlan_host_association_secondary_range = each.value.switchport_private_vlan_host_association_secondary_range
  switchport_trunk_allowed_vlans                           = each.value.switchport_trunk_allowed_vlans
  switchport_trunk_allowed_vlans_none                      = each.value.switchport_trunk_allowed_vlans_none
  switchport_trunk_allowed_vlans_all                       = each.value.switchport_trunk_allowed_vlans_all
  switchport_trunk_native_vlan_tag                         = each.value.switchport_trunk_native_vlan_tag
  switchport_trunk_native_vlan_vlan_id                     = each.value.switchport_trunk_native_vlan_vlan_id
  mab                                                      = each.value.mab
  mab_eap                                                  = each.value.mab_eap
  access_session_closed                                    = each.value.access_session_closed
  access_session_monitor                                   = each.value.access_session_monitor
  access_session_port_control                              = each.value.access_session_port_control
  access_session_control_direction                         = each.value.access_session_control_direction
  access_session_host_mode                                 = each.value.access_session_host_mode
  access_session_interface_template_sticky                 = each.value.access_session_interface_template_sticky
  access_session_interface_template_sticky_timer           = each.value.access_session_interface_template_sticky_timer
  authentication_periodic                                  = each.value.authentication_periodic
  authentication_timer_reauthenticate_server               = each.value.authentication_timer_reauthenticate_server
  authentication_timer_reauthenticate_range                = each.value.authentication_timer_reauthenticate_range
  spanning_tree_bpduguard_enable                           = each.value.spanning_tree_bpduguard_enable
  spanning_tree_service_policy                             = each.value.spanning_tree_service_policy
  spanning_tree_portfast                                   = each.value.spanning_tree_portfast
  spanning_tree_portfast_disable                           = each.value.spanning_tree_portfast_disable
  spanning_tree_portfast_edge                              = each.value.spanning_tree_portfast_edge
  spanning_tree_portfast_network                           = each.value.spanning_tree_portfast_network
  storm_control_broadcast_level_pps_threshold              = each.value.storm_control_broadcast_level_pps_threshold
  storm_control_broadcast_level_bps_threshold              = each.value.storm_control_broadcast_level_bps_threshold
  storm_control_broadcast_level_threshold                  = each.value.storm_control_broadcast_level_threshold
  storm_control_multicast_level_pps_threshold              = each.value.storm_control_multicast_level_pps_threshold
  storm_control_multicast_level_bps_threshold              = each.value.storm_control_multicast_level_bps_threshold
  storm_control_multicast_level_threshold                  = each.value.storm_control_multicast_level_threshold
  storm_control_action_shutdown                            = each.value.storm_control_action_shutdown
  storm_control_action_trap                                = each.value.storm_control_action_trap
  load_interval                                            = each.value.load_interval
  ip_dhcp_snooping_limit_rate                              = each.value.ip_dhcp_snooping_limit_rate
  ip_dhcp_snooping_trust                                   = each.value.ip_dhcp_snooping_trust
  ip_access_group                                          = each.value.ip_access_group
  subscriber_aging_inactivity_timer_probe                  = each.value.subscriber_aging_inactivity_timer_probe
  subscriber_aging_inactivity_timer_value                  = each.value.subscriber_aging_inactivity_timer_value
  subscriber_aging_probe                                   = each.value.subscriber_aging_probe
  device_tracking                                          = each.value.device_tracking
  device_tracking_attach_policy                            = each.value.device_tracking_attach_policy
  device_tracking_vlan_range                               = each.value.device_tracking_vlan_range
  cts_manual                                               = each.value.cts_manual
  cts_manual_policy_static_sgt                             = each.value.cts_manual_policy_static_sgt
  cts_manual_policy_static_trusted                         = each.value.cts_manual_policy_static_trusted
  cts_manual_propagate_sgt                                 = each.value.cts_manual_propagate_sgt
  cts_role_based_enforcement                               = each.value.cts_role_based_enforcement

  depends_on = [
    iosxe_vlan.vlan,
    iosxe_policy_map.policy_map,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}
