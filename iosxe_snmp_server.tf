resource "iosxe_snmp_server" "snmp_server" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].snmp_server, null) != null }
  device   = each.value.name

  chassis_id                                         = try(local.device_config[each.value.name].snmp_server.chassis_id, local.defaults.iosxe.configuration.snmp_server.chassis_id, null)
  contact                                            = try(local.device_config[each.value.name].snmp_server.contact, local.defaults.iosxe.configuration.snmp_server.contact, null)
  enable_informs                                     = try(local.device_config[each.value.name].snmp_server.enable_informs, local.defaults.iosxe.configuration.snmp_server.enable_informs, null)
  enable_logging_getop                               = try(local.device_config[each.value.name].snmp_server.enable_logging_getop, local.defaults.iosxe.configuration.snmp_server.enable_logging_getop, null)
  enable_logging_setop                               = try(local.device_config[each.value.name].snmp_server.enable_logging_setop, local.defaults.iosxe.configuration.snmp_server.enable_logging_setop, null)
  enable_traps                                       = try(local.device_config[each.value.name].snmp_server.enable_traps, local.defaults.iosxe.configuration.snmp_server.enable_traps, null)
  enable_traps_auth_framework_sec_violation          = try(local.device_config[each.value.name].snmp_server.traps.auth_framework_sec_violation, local.defaults.iosxe.configuration.snmp_server.traps.auth_framework_sec_violation, null)
  enable_traps_bfd                                   = try(local.device_config[each.value.name].snmp_server.traps.bfd, local.defaults.iosxe.configuration.snmp_server.traps.bfd, null)
  enable_traps_bgp_cbgp2                             = try(local.device_config[each.value.name].snmp_server.traps.bgp_cbgp2, local.defaults.iosxe.configuration.snmp_server.traps.bgp_cbgp2, null)
  enable_traps_bridge_newroot                        = try(local.device_config[each.value.name].snmp_server.traps.bridge_newroot, local.defaults.iosxe.configuration.snmp_server.traps.bridge_newroot, null)
  enable_traps_bridge_topologychange                 = try(local.device_config[each.value.name].snmp_server.traps.bridge_topologychange, local.defaults.iosxe.configuration.snmp_server.traps.bridge_topologychange, null)
  enable_traps_bulkstat_collection                   = try(local.device_config[each.value.name].snmp_server.traps.bulkstat_collection, local.defaults.iosxe.configuration.snmp_server.traps.bulkstat_collection, null)
  enable_traps_bulkstat_transfer                     = try(local.device_config[each.value.name].snmp_server.traps.bulkstat_transfer, local.defaults.iosxe.configuration.snmp_server.traps.bulkstat_transfer, null)
  enable_traps_call_home_message_send_fail           = try(local.device_config[each.value.name].snmp_server.traps.call_home_message_send_fail, local.defaults.iosxe.configuration.snmp_server.traps.call_home_message_send_fail, null)
  enable_traps_call_home_server_fail                 = try(local.device_config[each.value.name].snmp_server.traps.call_home_server_fail, local.defaults.iosxe.configuration.snmp_server.traps.call_home_server_fail, null)
  enable_traps_cef_inconsistency                     = try(local.device_config[each.value.name].snmp_server.traps.cef_inconsistency, local.defaults.iosxe.configuration.snmp_server.traps.cef_inconsistency, null)
  enable_traps_cef_peer_fib_state_change             = try(local.device_config[each.value.name].snmp_server.traps.cef_peer_fib_state_change, local.defaults.iosxe.configuration.snmp_server.traps.cef_peer_fib_state_change, null)
  enable_traps_cef_peer_state_change                 = try(local.device_config[each.value.name].snmp_server.traps.cef_peer_state_change, local.defaults.iosxe.configuration.snmp_server.traps.cef_peer_state_change, null)
  enable_traps_cef_resource_failure                  = try(local.device_config[each.value.name].snmp_server.traps.cef_resource_failure, local.defaults.iosxe.configuration.snmp_server.traps.cef_resource_failure, null)
  enable_traps_config                                = try(local.device_config[each.value.name].snmp_server.traps.config, local.defaults.iosxe.configuration.snmp_server.traps.config, null)
  enable_traps_config_copy                           = try(local.device_config[each.value.name].snmp_server.traps.config_copy, local.defaults.iosxe.configuration.snmp_server.traps.config_copy, null)
  enable_traps_config_ctid                           = try(local.device_config[each.value.name].snmp_server.traps.config_ctid, local.defaults.iosxe.configuration.snmp_server.traps.config_ctid, null)
  enable_traps_cpu_threshold                         = try(local.device_config[each.value.name].snmp_server.traps.cpu_threshold, local.defaults.iosxe.configuration.snmp_server.traps.cpu_threshold, null)
  enable_traps_dhcp                                  = try(local.device_config[each.value.name].snmp_server.traps.dhcp, local.defaults.iosxe.configuration.snmp_server.traps.dhcp, null)
  enable_traps_eigrp                                 = try(local.device_config[each.value.name].snmp_server.traps.eigrp, local.defaults.iosxe.configuration.snmp_server.traps.eigrp, null)
  enable_traps_energywise                            = try(local.device_config[each.value.name].snmp_server.traps.energywise, local.defaults.iosxe.configuration.snmp_server.traps.energywise, null)
  enable_traps_entity                                = try(local.device_config[each.value.name].snmp_server.traps.entity, local.defaults.iosxe.configuration.snmp_server.traps.entity, null)
  enable_traps_entity_diag_boot_up_fail              = try(local.device_config[each.value.name].snmp_server.traps.entity_diag_boot_up_fail, local.defaults.iosxe.configuration.snmp_server.traps.entity_diag_boot_up_fail, null)
  enable_traps_entity_diag_hm_test_recover           = try(local.device_config[each.value.name].snmp_server.traps.entity_diag_hm_test_recover, local.defaults.iosxe.configuration.snmp_server.traps.entity_diag_hm_test_recover, null)
  enable_traps_entity_diag_hm_thresh_reached         = try(local.device_config[each.value.name].snmp_server.traps.entity_diag_hm_thresh_reached, local.defaults.iosxe.configuration.snmp_server.traps.entity_diag_hm_thresh_reached, null)
  enable_traps_entity_diag_scheduled_test_fail       = try(local.device_config[each.value.name].snmp_server.traps.entity_diag_scheduled_test_fail, local.defaults.iosxe.configuration.snmp_server.traps.entity_diag_scheduled_test_fail, null)
  enable_traps_entity_perf_throughput_notif          = try(local.device_config[each.value.name].snmp_server.traps.entity_perf_throughput_notif, local.defaults.iosxe.configuration.snmp_server.traps.entity_perf_throughput_notif, null)
  enable_traps_envmon                                = try(local.device_config[each.value.name].snmp_server.traps.envmon, local.defaults.iosxe.configuration.snmp_server.traps.envmon, null)
  enable_traps_errdisable                            = try(local.device_config[each.value.name].snmp_server.traps.errdisable, local.defaults.iosxe.configuration.snmp_server.traps.errdisable, null)
  enable_traps_event_manager                         = try(local.device_config[each.value.name].snmp_server.traps.event_manager, local.defaults.iosxe.configuration.snmp_server.traps.event_manager, null)
  enable_traps_fast_reroute_protected                = try(local.device_config[each.value.name].snmp_server.traps.fast_reroute_protected, local.defaults.iosxe.configuration.snmp_server.traps.fast_reroute_protected, null)
  enable_traps_flash_insertion                       = try(local.device_config[each.value.name].snmp_server.traps.flash_insertion, local.defaults.iosxe.configuration.snmp_server.traps.flash_insertion, null)
  enable_traps_flash_lowspace                        = try(local.device_config[each.value.name].snmp_server.traps.flash_lowspace, local.defaults.iosxe.configuration.snmp_server.traps.flash_lowspace, null)
  enable_traps_flash_removal                         = try(local.device_config[each.value.name].snmp_server.traps.flash_removal, local.defaults.iosxe.configuration.snmp_server.traps.flash_removal, null)
  enable_traps_flowmon                               = try(local.device_config[each.value.name].snmp_server.traps.flowmon, local.defaults.iosxe.configuration.snmp_server.traps.flowmon, null)
  enable_traps_fru_ctrl                              = try(local.device_config[each.value.name].snmp_server.traps.fru_ctrl, local.defaults.iosxe.configuration.snmp_server.traps.fru_ctrl, null)
  enable_traps_hsrp                                  = try(local.device_config[each.value.name].snmp_server.traps.hsrp, local.defaults.iosxe.configuration.snmp_server.traps.hsrp, null)
  enable_traps_ike_policy_add                        = try(local.device_config[each.value.name].snmp_server.traps.ike_policy_add, local.defaults.iosxe.configuration.snmp_server.traps.ike_policy_add, null)
  enable_traps_ike_policy_delete                     = try(local.device_config[each.value.name].snmp_server.traps.ike_policy_delete, local.defaults.iosxe.configuration.snmp_server.traps.ike_policy_delete, null)
  enable_traps_ike_tunnel_start                      = try(local.device_config[each.value.name].snmp_server.traps.ike_tunnel_start, local.defaults.iosxe.configuration.snmp_server.traps.ike_tunnel_start, null)
  enable_traps_ike_tunnel_stop                       = try(local.device_config[each.value.name].snmp_server.traps.ike_tunnel_stop, local.defaults.iosxe.configuration.snmp_server.traps.ike_tunnel_stop, null)
  enable_traps_ipmulticast                           = try(local.device_config[each.value.name].snmp_server.traps.ip_multicast, local.defaults.iosxe.configuration.snmp_server.traps.ip_multicast, null)
  enable_traps_ipsec_cryptomap_add                   = try(local.device_config[each.value.name].snmp_server.traps.ipsec_cryptomap_add, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_cryptomap_add, null)
  enable_traps_ipsec_cryptomap_attach                = try(local.device_config[each.value.name].snmp_server.traps.ipsec_cryptomap_attach, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_cryptomap_attach, null)
  enable_traps_ipsec_cryptomap_delete                = try(local.device_config[each.value.name].snmp_server.traps.ipsec_cryptomap_delete, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_cryptomap_delete, null)
  enable_traps_ipsec_cryptomap_detach                = try(local.device_config[each.value.name].snmp_server.traps.ipsec_cryptomap_detach, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_cryptomap_detach, null)
  enable_traps_ipsec_too_many_sas                    = try(local.device_config[each.value.name].snmp_server.traps.ipsec_too_many_sas, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_too_many_sas, null)
  enable_traps_ipsec_tunnel_start                    = try(local.device_config[each.value.name].snmp_server.traps.ipsec_tunnel_start, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_tunnel_start, null)
  enable_traps_ipsec_tunnel_stop                     = try(local.device_config[each.value.name].snmp_server.traps.ipsec_tunnel_stop, local.defaults.iosxe.configuration.snmp_server.traps.ipsec_tunnel_stop, null)
  enable_traps_ipsla                                 = try(local.device_config[each.value.name].snmp_server.traps.ipsla, local.defaults.iosxe.configuration.snmp_server.traps.ipsla, null)
  enable_traps_isis                                  = try(local.device_config[each.value.name].snmp_server.traps.isis, local.defaults.iosxe.configuration.snmp_server.traps.isis, null)
  enable_traps_license                               = try(local.device_config[each.value.name].snmp_server.traps.license, local.defaults.iosxe.configuration.snmp_server.traps.license, null)
  enable_traps_local_auth                            = try(local.device_config[each.value.name].snmp_server.traps.local_auth, local.defaults.iosxe.configuration.snmp_server.traps.local_auth, null)
  enable_traps_mac_notification_change               = try(local.device_config[each.value.name].snmp_server.traps.mac_notification_change, local.defaults.iosxe.configuration.snmp_server.traps.mac_notification_change, null)
  enable_traps_mac_notification_move                 = try(local.device_config[each.value.name].snmp_server.traps.mac_notification_move, local.defaults.iosxe.configuration.snmp_server.traps.mac_notification_move, null)
  enable_traps_mac_notification_threshold            = try(local.device_config[each.value.name].snmp_server.traps.mac_notification_threshold, local.defaults.iosxe.configuration.snmp_server.traps.mac_notification_threshold, null)
  enable_traps_memory_bufferpeak                     = try(local.device_config[each.value.name].snmp_server.traps.memory_bufferpeak, local.defaults.iosxe.configuration.snmp_server.traps.memory_bufferpeak, null)
  enable_traps_mpls_ldp                              = try(local.device_config[each.value.name].snmp_server.traps.mpls_ldp, local.defaults.iosxe.configuration.snmp_server.traps.mpls_ldp, null)
  enable_traps_mpls_rfc_ldp                          = try(local.device_config[each.value.name].snmp_server.traps.mpls_rfc_ldp, local.defaults.iosxe.configuration.snmp_server.traps.mpls_rfc_ldp, null)
  enable_traps_mpls_traffic_eng                      = try(local.device_config[each.value.name].snmp_server.traps.mpls_traffic_eng, local.defaults.iosxe.configuration.snmp_server.traps.mpls_traffic_eng, null)
  enable_traps_mpls_vpn                              = try(local.device_config[each.value.name].snmp_server.traps.mpls_vpn, local.defaults.iosxe.configuration.snmp_server.traps.mpls_vpn, null)
  enable_traps_msdp                                  = try(local.device_config[each.value.name].snmp_server.traps.msdp, local.defaults.iosxe.configuration.snmp_server.traps.msdp, null)
  enable_traps_nhrp_nhc                              = try(local.device_config[each.value.name].snmp_server.traps.nhrp_nhc, local.defaults.iosxe.configuration.snmp_server.traps.nhrp_nhc, null)
  enable_traps_nhrp_nhp                              = try(local.device_config[each.value.name].snmp_server.traps.nhrp_nhp, local.defaults.iosxe.configuration.snmp_server.traps.nhrp_nhp, null)
  enable_traps_nhrp_nhs                              = try(local.device_config[each.value.name].snmp_server.traps.nhrp_nhs, local.defaults.iosxe.configuration.snmp_server.traps.nhrp_nhs, null)
  enable_traps_nhrp_quota_exceeded                   = try(local.device_config[each.value.name].snmp_server.traps.nhrp_quota_exceeded, local.defaults.iosxe.configuration.snmp_server.traps.nhrp_quota_exceeded, null)
  enable_traps_ospf_config_errors                    = try(local.device_config[each.value.name].snmp_server.traps.ospf_config_errors, local.defaults.iosxe.configuration.snmp_server.traps.ospf_config_errors, null)
  enable_traps_ospf_config_lsa                       = try(local.device_config[each.value.name].snmp_server.traps.ospf_config_lsa, local.defaults.iosxe.configuration.snmp_server.traps.ospf_config_lsa, null)
  enable_traps_ospf_config_retransmit                = try(local.device_config[each.value.name].snmp_server.traps.ospf_config_retransmit, local.defaults.iosxe.configuration.snmp_server.traps.ospf_config_retransmit, null)
  enable_traps_ospf_config_state_change              = try(local.device_config[each.value.name].snmp_server.traps.ospf_config_state_change, local.defaults.iosxe.configuration.snmp_server.traps.ospf_config_state_change, null)
  enable_traps_ospf_errors_enable                    = try(local.device_config[each.value.name].snmp_server.traps.ospf_errors_enable, local.defaults.iosxe.configuration.snmp_server.traps.ospf_errors_enable, null)
  enable_traps_ospf_lsa_enable                       = try(local.device_config[each.value.name].snmp_server.traps.ospf_lsa_enable, local.defaults.iosxe.configuration.snmp_server.traps.ospf_lsa_enable, null)
  enable_traps_ospf_nssa_trans_change                = try(local.device_config[each.value.name].snmp_server.traps.ospf_nssa_trans_change, local.defaults.iosxe.configuration.snmp_server.traps.ospf_nssa_trans_change, null)
  enable_traps_ospf_retransmit_enable                = try(local.device_config[each.value.name].snmp_server.traps.ospf_retransmit_enable, local.defaults.iosxe.configuration.snmp_server.traps.ospf_retransmit_enable, null)
  enable_traps_ospf_shamlink_interface               = try(local.device_config[each.value.name].snmp_server.traps.ospf_shamlink_interface, local.defaults.iosxe.configuration.snmp_server.traps.ospf_shamlink_interface, null)
  enable_traps_ospf_shamlink_neighbor                = try(local.device_config[each.value.name].snmp_server.traps.ospf_shamlink_neighbor, local.defaults.iosxe.configuration.snmp_server.traps.ospf_shamlink_neighbor, null)
  enable_traps_ospfv3_config_errors                  = try(local.device_config[each.value.name].snmp_server.traps.ospfv3_config_errors, local.defaults.iosxe.configuration.snmp_server.traps.ospfv3_config_errors, null)
  enable_traps_ospfv3_config_state_change            = try(local.device_config[each.value.name].snmp_server.traps.ospfv3_config_state_change, local.defaults.iosxe.configuration.snmp_server.traps.ospfv3_config_state_change, null)
  enable_traps_pim_invalid_pim_message               = try(local.device_config[each.value.name].snmp_server.traps.pim_invalid_pim_message, local.defaults.iosxe.configuration.snmp_server.traps.pim_invalid_pim_message, null)
  enable_traps_pim_neighbor_change                   = try(local.device_config[each.value.name].snmp_server.traps.pim_neighbor_change, local.defaults.iosxe.configuration.snmp_server.traps.pim_neighbor_change, null)
  enable_traps_pim_rp_mapping_change                 = try(local.device_config[each.value.name].snmp_server.traps.pim_rp_mapping_change, local.defaults.iosxe.configuration.snmp_server.traps.pim_rp_mapping_change, null)
  enable_traps_port_security                         = try(local.device_config[each.value.name].snmp_server.traps.port_security, local.defaults.iosxe.configuration.snmp_server.traps.port_security, null)
  enable_traps_power_ethernet_group                  = try(local.device_config[each.value.name].snmp_server.traps.power_ethernet_group, local.defaults.iosxe.configuration.snmp_server.traps.power_ethernet_group, null)
  enable_traps_power_ethernet_police                 = try(local.device_config[each.value.name].snmp_server.traps.power_ethernet_police, local.defaults.iosxe.configuration.snmp_server.traps.power_ethernet_police, null)
  enable_traps_pw_vc                                 = try(local.device_config[each.value.name].snmp_server.traps.pw_vc, local.defaults.iosxe.configuration.snmp_server.traps.pw_vc, null)
  enable_traps_rep                                   = try(local.device_config[each.value.name].snmp_server.traps.rep, local.defaults.iosxe.configuration.snmp_server.traps.rep, null)
  enable_traps_rf                                    = try(local.device_config[each.value.name].snmp_server.traps.rf, local.defaults.iosxe.configuration.snmp_server.traps.rf, null)
  enable_traps_smart_license                         = try(local.device_config[each.value.name].snmp_server.traps.smart_license, local.defaults.iosxe.configuration.snmp_server.traps.smart_license, null)
  enable_traps_snmp_authentication                   = try(local.device_config[each.value.name].snmp_server.traps.snmp_authentication, local.defaults.iosxe.configuration.snmp_server.traps.snmp_authentication, null)
  enable_traps_snmp_coldstart                        = try(local.device_config[each.value.name].snmp_server.traps.snmp_coldstart, local.defaults.iosxe.configuration.snmp_server.traps.snmp_coldstart, null)
  enable_traps_snmp_linkdown                         = try(local.device_config[each.value.name].snmp_server.traps.snmp_linkdown, local.defaults.iosxe.configuration.snmp_server.traps.snmp_linkdown, null)
  enable_traps_snmp_linkup                           = try(local.device_config[each.value.name].snmp_server.traps.snmp_linkup, local.defaults.iosxe.configuration.snmp_server.traps.snmp_linkup, null)
  enable_traps_snmp_warmstart                        = try(local.device_config[each.value.name].snmp_server.traps.snmp_warmstart, local.defaults.iosxe.configuration.snmp_server.traps.snmp_warmstart, null)
  enable_traps_stackwise                             = try(local.device_config[each.value.name].snmp_server.traps.stackwise, local.defaults.iosxe.configuration.snmp_server.traps.stackwise, null)
  enable_traps_stpx_inconsistency                    = try(local.device_config[each.value.name].snmp_server.traps.stpx_inconsistency, local.defaults.iosxe.configuration.snmp_server.traps.stpx_inconsistency, null)
  enable_traps_stpx_loop_inconsistency               = try(local.device_config[each.value.name].snmp_server.traps.stpx_loop_inconsistency, local.defaults.iosxe.configuration.snmp_server.traps.stpx_loop_inconsistency, null)
  enable_traps_stpx_root_inconsistency               = try(local.device_config[each.value.name].snmp_server.traps.stpx_root_inconsistency, local.defaults.iosxe.configuration.snmp_server.traps.stpx_root_inconsistency, null)
  enable_traps_syslog                                = try(local.device_config[each.value.name].snmp_server.traps.syslog, local.defaults.iosxe.configuration.snmp_server.traps.syslog, null)
  enable_traps_transceiver_all                       = try(local.device_config[each.value.name].snmp_server.traps.transceiver_all, local.defaults.iosxe.configuration.snmp_server.traps.transceiver_all, null)
  enable_traps_tty                                   = try(local.device_config[each.value.name].snmp_server.traps.tty, local.defaults.iosxe.configuration.snmp_server.traps.tty, null)
  enable_traps_udld_link_fail_rpt                    = try(local.device_config[each.value.name].snmp_server.traps.udld_link_fail_rpt, local.defaults.iosxe.configuration.snmp_server.traps.udld_link_fail_rpt, null)
  enable_traps_udld_status_change                    = try(local.device_config[each.value.name].snmp_server.traps.udld_status_change, local.defaults.iosxe.configuration.snmp_server.traps.udld_status_change, null)
  enable_traps_vlan_membership                       = try(local.device_config[each.value.name].snmp_server.traps.vlan_membership, local.defaults.iosxe.configuration.snmp_server.traps.vlan_membership, null)
  enable_traps_vlancreate                            = try(local.device_config[each.value.name].snmp_server.traps.vlancreate, local.defaults.iosxe.configuration.snmp_server.traps.vlancreate, null)
  enable_traps_vlandelete                            = try(local.device_config[each.value.name].snmp_server.traps.vlandelete, local.defaults.iosxe.configuration.snmp_server.traps.vlandelete, null)
  enable_traps_vrfmib_vnet_trunk_down                = try(local.device_config[each.value.name].snmp_server.traps.vrfmib_vnet_trunk_down, local.defaults.iosxe.configuration.snmp_server.traps.vrfmib_vnet_trunk_down, null)
  enable_traps_vrfmib_vnet_trunk_up                  = try(local.device_config[each.value.name].snmp_server.traps.vrfmib_vnet_trunk_up, local.defaults.iosxe.configuration.snmp_server.traps.vrfmib_vnet_trunk_up, null)
  enable_traps_vrfmib_vrf_down                       = try(local.device_config[each.value.name].snmp_server.traps.vrfmib_vrf_down, local.defaults.iosxe.configuration.snmp_server.traps.vrfmib_vrf_down, null)
  enable_traps_vrfmib_vrf_up                         = try(local.device_config[each.value.name].snmp_server.traps.vrfmib_vrf_up, local.defaults.iosxe.configuration.snmp_server.traps.vrfmib_vrf_up, null)
  enable_traps_vtp                                   = try(local.device_config[each.value.name].snmp_server.traps.vtp, local.defaults.iosxe.configuration.snmp_server.traps.vtp, null)
  enable_traps_aaa_server                            = try(local.device_config[each.value.name].snmp_server.traps.aaa_server, local.defaults.iosxe.configuration.snmp_server.traps.aaa_server, null)
  enable_traps_adslline                              = try(local.device_config[each.value.name].snmp_server.traps.adslline, local.defaults.iosxe.configuration.snmp_server.traps.adslline, null)
  enable_traps_alarm_type                            = try(local.device_config[each.value.name].snmp_server.traps.alarm_type, local.defaults.iosxe.configuration.snmp_server.traps.alarm_type, null)
  enable_traps_casa                                  = try(local.device_config[each.value.name].snmp_server.traps.casa, local.defaults.iosxe.configuration.snmp_server.traps.casa, null)
  enable_traps_cnpd                                  = try(local.device_config[each.value.name].snmp_server.traps.cnpd, local.defaults.iosxe.configuration.snmp_server.traps.cnpd, null)
  enable_traps_dial                                  = try(local.device_config[each.value.name].snmp_server.traps.dial, local.defaults.iosxe.configuration.snmp_server.traps.dial, null)
  enable_traps_dlsw                                  = try(local.device_config[each.value.name].snmp_server.traps.dlsw, local.defaults.iosxe.configuration.snmp_server.traps.dlsw, null)
  enable_traps_ds1                                   = try(local.device_config[each.value.name].snmp_server.traps.ds1, local.defaults.iosxe.configuration.snmp_server.traps.ds1, null)
  enable_traps_dsp_card_status                       = try(local.device_config[each.value.name].snmp_server.traps.dsp_card_status, local.defaults.iosxe.configuration.snmp_server.traps.dsp_card_status, null)
  enable_traps_dsp_oper_state                        = try(local.device_config[each.value.name].snmp_server.traps.dsp_oper_state, local.defaults.iosxe.configuration.snmp_server.traps.dsp_oper_state, null)
  enable_traps_ether_oam                             = try(local.device_config[each.value.name].snmp_server.traps.ether_oam, local.defaults.iosxe.configuration.snmp_server.traps.ether_oam, null)
  enable_traps_ethernet_cfm_alarm                    = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_alarm, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_alarm, null)
  enable_traps_ethernet_cfm_cc_config                = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_cc_config, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_cc_config, null)
  enable_traps_ethernet_cfm_cc_cross_connect         = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_cc_cross_connect, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_cc_cross_connect, null)
  enable_traps_ethernet_cfm_cc_loop                  = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_cc_loop, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_cc_loop, null)
  enable_traps_ethernet_cfm_cc_mep_down              = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_cc_mep_down, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_cc_mep_down, null)
  enable_traps_ethernet_cfm_cc_mep_up                = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_cc_mep_up, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_cc_mep_up, null)
  enable_traps_ethernet_cfm_crosscheck_mep_missing   = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_crosscheck_mep_missing, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_crosscheck_mep_missing, null)
  enable_traps_ethernet_cfm_crosscheck_mep_unknown   = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_crosscheck_mep_unknown, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_crosscheck_mep_unknown, null)
  enable_traps_ethernet_cfm_crosscheck_service_up    = try(local.device_config[each.value.name].snmp_server.traps.ethernet_cfm_crosscheck_service_up, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_cfm_crosscheck_service_up, null)
  enable_traps_ethernet_evc_create                   = try(local.device_config[each.value.name].snmp_server.traps.ethernet_evc_create, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_evc_create, null)
  enable_traps_ethernet_evc_delete                   = try(local.device_config[each.value.name].snmp_server.traps.ethernet_evc_delete, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_evc_delete, null)
  enable_traps_ethernet_evc_status                   = try(local.device_config[each.value.name].snmp_server.traps.ethernet_evc_status, local.defaults.iosxe.configuration.snmp_server.traps.ethernet_evc_status, null)
  enable_traps_firewall_serverstatus                 = try(local.device_config[each.value.name].snmp_server.traps.firewall_serverstatus, local.defaults.iosxe.configuration.snmp_server.traps.firewall_serverstatus, null)
  enable_traps_frame_relay_config_bundle_mismatch    = try(local.device_config[each.value.name].snmp_server.traps.frame_relay_config_bundle_mismatch, local.defaults.iosxe.configuration.snmp_server.traps.frame_relay_config_bundle_mismatch, null)
  enable_traps_frame_relay_config_only               = try(local.device_config[each.value.name].snmp_server.traps.frame_relay_config_only, local.defaults.iosxe.configuration.snmp_server.traps.frame_relay_config_only, null)
  enable_traps_frame_relay_config_subif_configs      = try(local.device_config[each.value.name].snmp_server.traps.frame_relay_config_subif_configs, local.defaults.iosxe.configuration.snmp_server.traps.frame_relay_config_subif_configs, null)
  enable_traps_frame_relay_multilink_bundle_mismatch = try(local.device_config[each.value.name].snmp_server.traps.frame_relay_multilink_bundle_mismatch, local.defaults.iosxe.configuration.snmp_server.traps.frame_relay_multilink_bundle_mismatch, null)
  enable_traps_frame_relay_subif_count               = try(local.device_config[each.value.name].snmp_server.traps.frame_relay_subif_count, local.defaults.iosxe.configuration.snmp_server.traps.frame_relay_subif_count, null)
  enable_traps_frame_relay_subif_interval            = try(local.device_config[each.value.name].snmp_server.traps.frame_relay_subif_interval, local.defaults.iosxe.configuration.snmp_server.traps.frame_relay_subif_interval, null)
  enable_traps_ip_local_pool                         = try(local.device_config[each.value.name].snmp_server.traps.ip_local_pool, local.defaults.iosxe.configuration.snmp_server.traps.ip_local_pool, null)
  enable_traps_isdn_call_information                 = try(local.device_config[each.value.name].snmp_server.traps.isdn_call_information, local.defaults.iosxe.configuration.snmp_server.traps.isdn_call_information, null)
  enable_traps_isdn_chan_not_avail                   = try(local.device_config[each.value.name].snmp_server.traps.isdn_chan_not_avail, local.defaults.iosxe.configuration.snmp_server.traps.isdn_chan_not_avail, null)
  enable_traps_isdn_ietf                             = try(local.device_config[each.value.name].snmp_server.traps.isdn_ietf, local.defaults.iosxe.configuration.snmp_server.traps.isdn_ietf, null)
  enable_traps_isdn_layer2                           = try(local.device_config[each.value.name].snmp_server.traps.isdn_layer2, local.defaults.iosxe.configuration.snmp_server.traps.isdn_layer2, null)
  enable_traps_l2tun_pseudowire_status               = try(local.device_config[each.value.name].snmp_server.traps.l2tun_pseudowire_status, local.defaults.iosxe.configuration.snmp_server.traps.l2tun_pseudowire_status, null)
  enable_traps_l2tun_session                         = try(local.device_config[each.value.name].snmp_server.traps.l2tun_session, local.defaults.iosxe.configuration.snmp_server.traps.l2tun_session, null)
  enable_traps_l2tun_tunnel                          = try(local.device_config[each.value.name].snmp_server.traps.l2tun_tunnel, local.defaults.iosxe.configuration.snmp_server.traps.l2tun_tunnel, null)
  enable_traps_lisp                                  = try(local.device_config[each.value.name].snmp_server.traps.lisp, local.defaults.iosxe.configuration.snmp_server.traps.lisp, null)
  enable_traps_mpls                                  = try(local.device_config[each.value.name].snmp_server.traps.mpls, local.defaults.iosxe.configuration.snmp_server.traps.mpls, null)
  enable_traps_mpls_rfc                              = try(local.device_config[each.value.name].snmp_server.traps.mpls_rfc, local.defaults.iosxe.configuration.snmp_server.traps.mpls_rfc, null)
  enable_traps_mvpn                                  = try(local.device_config[each.value.name].snmp_server.traps.mvpn, local.defaults.iosxe.configuration.snmp_server.traps.mvpn, null)
  enable_traps_pfr                                   = try(local.device_config[each.value.name].snmp_server.traps.pfr, local.defaults.iosxe.configuration.snmp_server.traps.pfr, null)
  enable_traps_pimstdmib_interface_election          = try(local.device_config[each.value.name].snmp_server.traps.pimstdmib_interface_election, local.defaults.iosxe.configuration.snmp_server.traps.pimstdmib_interface_election, null)
  enable_traps_pimstdmib_invalid_join_prune          = try(local.device_config[each.value.name].snmp_server.traps.pimstdmib_invalid_join_prune, local.defaults.iosxe.configuration.snmp_server.traps.pimstdmib_invalid_join_prune, null)
  enable_traps_pimstdmib_invalid_register            = try(local.device_config[each.value.name].snmp_server.traps.pimstdmib_invalid_register, local.defaults.iosxe.configuration.snmp_server.traps.pimstdmib_invalid_register, null)
  enable_traps_pimstdmib_neighbor_loss               = try(local.device_config[each.value.name].snmp_server.traps.pimstdmib_neighbor_loss, local.defaults.iosxe.configuration.snmp_server.traps.pimstdmib_neighbor_loss, null)
  enable_traps_pimstdmib_rp_mapping_change           = try(local.device_config[each.value.name].snmp_server.traps.pimstdmib_rp_mapping_change, local.defaults.iosxe.configuration.snmp_server.traps.pimstdmib_rp_mapping_change, null)
  enable_traps_pki                                   = try(local.device_config[each.value.name].snmp_server.traps.pki, local.defaults.iosxe.configuration.snmp_server.traps.pki, null)
  enable_traps_pppoe                                 = try(local.device_config[each.value.name].snmp_server.traps.pppoe, local.defaults.iosxe.configuration.snmp_server.traps.pppoe, null)
  enable_traps_resource_policy                       = try(local.device_config[each.value.name].snmp_server.traps.resource_policy, local.defaults.iosxe.configuration.snmp_server.traps.resource_policy, null)
  enable_traps_rsvp                                  = try(local.device_config[each.value.name].snmp_server.traps.rsvp, local.defaults.iosxe.configuration.snmp_server.traps.rsvp, null)
  enable_traps_sonet                                 = try(local.device_config[each.value.name].snmp_server.traps.sonet, local.defaults.iosxe.configuration.snmp_server.traps.sonet, null)
  enable_traps_srp                                   = try(local.device_config[each.value.name].snmp_server.traps.srp, local.defaults.iosxe.configuration.snmp_server.traps.srp, null)
  enable_traps_vdsl2line                             = try(local.device_config[each.value.name].snmp_server.traps.vdsl2line, local.defaults.iosxe.configuration.snmp_server.traps.vdsl2line, null)
  enable_traps_voice                                 = try(local.device_config[each.value.name].snmp_server.traps.voice, local.defaults.iosxe.configuration.snmp_server.traps.voice, null)
  enable_traps_vrrp                                  = try(local.device_config[each.value.name].snmp_server.traps.vrrp, local.defaults.iosxe.configuration.snmp_server.traps.vrrp, null)
  enable_traps_entity_qfp_mem_res_thresh             = try(local.device_config[each.value.name].snmp_server.traps.entity_qfp_mem_res_thresh, local.defaults.iosxe.configuration.snmp_server.traps.entity_qfp_mem_res_thresh, null)
  enable_traps_entity_qfp_throughput_notif           = try(local.device_config[each.value.name].snmp_server.traps.entity_qfp_throughput_notif, local.defaults.iosxe.configuration.snmp_server.traps.entity_qfp_throughput_notif, null)
  enable_traps_entity_sensor                         = try(local.device_config[each.value.name].snmp_server.traps.entity_sensor, local.defaults.iosxe.configuration.snmp_server.traps.entity_sensor, null)
  enable_traps_entity_state                          = try(local.device_config[each.value.name].snmp_server.traps.entity_state, local.defaults.iosxe.configuration.snmp_server.traps.entity_state, null)
  ifindex_persist                                    = try(local.device_config[each.value.name].snmp_server.ifindex_persist, local.defaults.iosxe.configuration.snmp_server.ifindex_persist, null)
  location                                           = try(local.device_config[each.value.name].snmp_server.location, local.defaults.iosxe.configuration.snmp_server.location, null)
  packetsize                                         = try(local.device_config[each.value.name].snmp_server.packet_size, local.defaults.iosxe.configuration.snmp_server.packet_size, null)
  queue_length                                       = try(local.device_config[each.value.name].snmp_server.queue_length, local.defaults.iosxe.configuration.snmp_server.queue_length, null)
  source_interface_informs_forty_gigabit_ethernet    = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "FortyGigabitEthernet" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_gigabit_ethernet          = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "GigabitEthernet" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_hundred_gig_e             = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "HundredGigE" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_loopback                  = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "Loopback" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_port_channel              = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "PortChannel" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_port_channel_subinterface = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "PortChannelSubinterface" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_ten_gigabit_ethernet      = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "TenGigabitEthernet" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_informs_vlan                      = try(local.device_config[each.value.name].snmp_server.source_interface_informs_type, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_type, null) == "Vlan" ? try(local.device_config[each.value.name].snmp_server.source_interface_informs_id, local.defaults.iosxe.configuration.snmp_server.source_interface_informs_id, null) : null
  source_interface_traps_forty_gigabit_ethernet      = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "FortyGigabitEthernet" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_gigabit_ethernet            = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "GigabitEthernet" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_hundred_gig_e               = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "HundredGigE" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_loopback                    = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "Loopback" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_port_channel                = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "PortChannel" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_port_channel_subinterface   = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "PortChannelSubinterface" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_ten_gigabit_ethernet        = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "TenGigabitEthernet" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  source_interface_traps_vlan                        = try(local.device_config[each.value.name].snmp_server.source_interface_traps_type, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_type, null) == "Vlan" ? try(local.device_config[each.value.name].snmp_server.source_interface_traps_id, local.defaults.iosxe.configuration.snmp_server.source_interface_traps_id, null) : null
  system_shutdown                                    = try(local.device_config[each.value.name].snmp_server.system_shutdown, local.defaults.iosxe.configuration.snmp_server.system_shutdown, null)
  contexts = [for context in try(local.device_config[each.value.name].snmp_server.contexts, []) : {
    name = context
  }]
  hosts = [for host in try(local.device_config[each.value.name].snmp_server.hosts, []) : {
    ip_address        = host.ip
    community_or_user = try(host.user, host.community, local.defaults.iosxe.configuration.snmp_server.hosts.user, local.defaults.iosxe.configuration.snmp_server.hosts.community, null)
    encryption        = try(host.encryption, local.defaults.iosxe.configuration.snmp_server.hosts.encryption, null)
    version           = try(host.version, local.defaults.iosxe.configuration.snmp_server.hosts.version, null)
  }]
  snmp_communities = [for e in try(local.device_config[each.value.name].snmp_server.snmp_communities, []) : {
    name             = e.name
    access_list_name = try(e.ipv4_acl, local.defaults.iosxe.configuration.snmp_server.snmp_communities.ipv4_acl, null)
    ipv6             = try(e.ipv6_acl, local.defaults.iosxe.configuration.snmp_server.snmp_communities.ipv6_acl, null)
    permission       = try(e.permission, local.defaults.iosxe.configuration.snmp_server.snmp_communities.permission, null)
    view             = try(e.view, local.defaults.iosxe.configuration.snmp_server.snmp_communities.view, null)
  }]
  views = [for e in try(local.device_config[each.value.name].snmp_server.views, []) : {
    name    = e.name
    mib     = e.mib
    inc_exl = try(e.scope, local.defaults.iosxe.configuration.snmp_server.views.scope, null)
  }]
}

locals {
  snmp_server_group = flatten([
    for device in local.devices : [
      for group in try(local.device_config[device.name].snmp_server.groups, []) : {
        key    = format("%s/%s", device.name, group.name)
        device = device.name
        name   = group.name
        v3_security = [for e in try(group.v3_security_levels, []) : {
          security_level      = e.security_level
          context_node        = try(e.context_node, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.context_node, null)
          match_node          = try(e.match_node, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.match_node, null)
          read_node           = try(e.read_node, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.read_node, null)
          write_node          = try(e.write_node, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.write_node, null)
          notify_node         = try(e.notify_node, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.notify_node, null)
          access_ipv6_acl     = try(e.access_ipv6_acl, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.access_ipv6_acl, null)
          access_standard_acl = try(e.access_standard_acl, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.access_standard_acl, null)
          access_acl_name     = try(e.access_acl_name, local.defaults.iosxe.configuration.snmp_server.groups.v3_securities.access_acl_name, null)
        }]
      }
    ]
  ])
}

resource "iosxe_snmp_server_group" "snmp_server_group" {
  for_each = { for e in local.snmp_server_group : e.key => e }
  device   = each.value.device

  name        = each.value.name
  v3_security = each.value.v3_security
}

locals {
  snmp_server_user = flatten([
    for device in local.devices : [
      for user in try(local.device_config[device.name].snmp_server.users, []) : {
        key      = format("%s/%s", device.name, user.name)
        device   = device.name
        username = user.name
        grpname  = user.group

        # Authentication settings
        v3_auth_algorithm = user.v3_authentication.algorithm
        v3_auth_password  = user.v3_authentication.password

        # Authentication access settings
        v3_auth_access_ipv6_acl = try(user.v3_authentication.access.ipv6_acl,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.access.ipv6_acl,
        null)
        v3_auth_access_standard_acl = try(user.v3_authentication.access.standard_acl,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.access.standard_acl,
        null)
        v3_auth_access_acl_name = try(user.v3_authentication.access.acl_name,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.access.acl_name,
        null)

        # AES privacy settings
        v3_auth_priv_aes_algorithm = try(
          user.v3_authentication.privacy.aes.enabled ? user.v3_authentication.privacy.aes.algorithm : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.aes.algorithm,
          null
        )
        v3_auth_priv_aes_password = try(
          user.v3_authentication.privacy.aes.enabled ? user.v3_authentication.privacy.aes.password : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.aes.password,
          null
        )

        # AES access settings
        v3_auth_priv_aes_access_ipv6_acl = try(
          user.v3_authentication.privacy.aes.enabled ? user.v3_authentication.privacy.aes.access.ipv6_acl : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.aes.access.ipv6_acl,
          null
        )
        v3_auth_priv_aes_access_standard_acl = try(
          user.v3_authentication.privacy.aes.enabled ? user.v3_authentication.privacy.aes.access.standard_acl : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.aes.access.standard_acl,
          null
        )
        v3_auth_priv_aes_access_acl_name = try(
          user.v3_authentication.privacy.aes.enabled ? user.v3_authentication.privacy.aes.access.acl_name : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.aes.access.acl_name,
          null
        )

        # DES privacy settings
        v3_auth_priv_des_password = try(
          user.v3_authentication.privacy.des.enabled ? user.v3_authentication.privacy.des.password : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des.password,
          null
        )

        # DES access settings
        v3_auth_priv_des_access_ipv6_acl = try(
          user.v3_authentication.privacy.des.enabled ? user.v3_authentication.privacy.des.access.ipv6_acl : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des.access.ipv6_acl,
          null
        )
        v3_auth_priv_des_access_standard_acl = try(
          user.v3_authentication.privacy.des.enabled ? user.v3_authentication.privacy.des.access.standard_acl : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des.access.standard_acl,
          null
        )
        v3_auth_priv_des_access_acl_name = try(
          user.v3_authentication.privacy.des.enabled ? user.v3_authentication.privacy.des.access.acl_name : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des.access.acl_name,
          null
        )

        # 3DES privacy settings
        v3_auth_priv_des3_password = try(
          user.v3_authentication.privacy.des3.enabled ? user.v3_authentication.privacy.des3.password : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des3.password,
          null
        )

        # 3DES access settings
        v3_auth_priv_des3_access_ipv6_acl = try(
          user.v3_authentication.privacy.des3.enabled ? user.v3_authentication.privacy.des3.access.ipv6_acl : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des3.access.ipv6_acl,
          null
        )
        v3_auth_priv_des3_access_standard_acl = try(
          user.v3_authentication.privacy.des3.enabled ? user.v3_authentication.privacy.des3.access.standard_acl : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des3.access.standard_acl,
          null
        )
        v3_auth_priv_des3_access_acl_name = try(
          user.v3_authentication.privacy.des3.enabled ? user.v3_authentication.privacy.des3.access.acl_name : null,
          local.defaults.iosxe.configuration.snmp_server.users.v3_authentication.privacy.des3.access.acl_name,
          null
        )
      }
    ]
  ])
}

resource "iosxe_snmp_server_user" "snmp_server_user" {
  for_each = { for e in local.snmp_server_user : e.key => e }
  device   = each.value.device

  username                              = each.value.username
  grpname                               = each.value.grpname
  v3_auth_algorithm                     = each.value.v3_auth_algorithm
  v3_auth_password                      = each.value.v3_auth_password
  v3_auth_priv_aes_algorithm            = each.value.v3_auth_priv_aes_algorithm
  v3_auth_priv_aes_password             = each.value.v3_auth_priv_aes_password
  v3_auth_priv_aes_access_ipv6_acl      = each.value.v3_auth_priv_aes_access_ipv6_acl
  v3_auth_priv_aes_access_standard_acl  = each.value.v3_auth_priv_aes_access_standard_acl
  v3_auth_priv_aes_access_acl_name      = each.value.v3_auth_priv_aes_access_acl_name
  v3_auth_priv_des_password             = each.value.v3_auth_priv_des_password
  v3_auth_priv_des_access_ipv6_acl      = each.value.v3_auth_priv_des_access_ipv6_acl
  v3_auth_priv_des_access_standard_acl  = each.value.v3_auth_priv_des_access_standard_acl
  v3_auth_priv_des_access_acl_name      = each.value.v3_auth_priv_des_access_acl_name
  v3_auth_priv_des3_password            = each.value.v3_auth_priv_des3_password
  v3_auth_priv_des3_access_ipv6_acl     = each.value.v3_auth_priv_des3_access_ipv6_acl
  v3_auth_priv_des3_access_standard_acl = each.value.v3_auth_priv_des3_access_standard_acl
  v3_auth_priv_des3_access_acl_name     = each.value.v3_auth_priv_des3_access_acl_name
  v3_auth_access_ipv6_acl               = each.value.v3_auth_access_ipv6_acl
  v3_auth_access_standard_acl           = each.value.v3_auth_access_standard_acl
  v3_auth_access_acl_name               = each.value.v3_auth_access_acl_name
}