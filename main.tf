module "model" {
  source = "./modules/model"

  yaml_directories          = var.yaml_directories
  yaml_files                = var.yaml_files
  model                     = var.model
  managed_device_groups     = var.managed_device_groups
  managed_devices           = var.managed_devices
  write_model_file          = var.write_model_file
  write_default_values_file = var.write_default_values_file
}

locals {
  model    = module.model.model
  defaults = module.model.default_values
  iosxe    = try(local.model.iosxe, {})
  devices  = try(local.iosxe.devices, [])

  device_config = { for device in try(local.iosxe.devices, []) :
    device.name => try(device.configuration, {})
  }

  provider_devices = module.model.devices
}

provider "iosxe" {
  devices = local.provider_devices
}

locals {
  cli_snippets = flatten([
    for device in local.devices : [
      for cli in try(local.device_config[device.name].extensions.cli_snippets, []) : {
        key    = format("%s/%s", device.name, try(cli.name, null))
        device = device.name
        name   = try(cli.name, local.defaults.iosxe.configuration.extensions.cli_snippets.name, null)
        cli    = cli.content
      }
    ]
  ])
}

resource "iosxe_cli" "cli" {
  for_each = { for e in local.cli_snippets : e.key => e }
  device   = each.value.device

  cli = each.value.cli

  depends_on = [
    iosxe_aaa.aaa,
    iosxe_aaa_accounting.aaa_accounting,
    iosxe_aaa_authentication.aaa_authentication,
    iosxe_aaa_authorization.aaa_authorization,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_arp.arp,
    iosxe_as_path_access_list.as_path_access_list,
    iosxe_banner.banner,
    iosxe_bfd.bfd,
    iosxe_bfd_template_single_hop.bfd_template_single_hop,
    iosxe_bfd_template_multi_hop.bfd_template_multi_hop,
    iosxe_bgp.bgp,
    iosxe_bgp_neighbor.bgp_neighbor,
    iosxe_bgp_address_family_ipv4.bgp_address_family_ipv4,
    iosxe_bgp_address_family_ipv6.bgp_address_family_ipv6,
    iosxe_bgp_address_family_l2vpn.bgp_address_family_l2vpn,
    iosxe_bgp_address_family_ipv4_vrf.bgp_address_family_ipv4_vrf,
    iosxe_bgp_address_family_ipv6_vrf.bgp_address_family_ipv6_vrf,
    iosxe_bgp_ipv4_unicast_neighbor.bgp_ipv4_unicast_neighbor,
    iosxe_bgp_ipv6_unicast_neighbor.bgp_ipv6_unicast_neighbor,
    iosxe_bgp_l2vpn_evpn_neighbor.bgp_l2vpn_evpn_neighbor,
    iosxe_bgp_ipv4_unicast_vrf_neighbor.bgp_ipv4_unicast_vrf_neighbor,
    iosxe_cdp.cdp,
    iosxe_class_map.class_map,
    iosxe_clock.clock,
    iosxe_community_list_standard.community_list_standard,
    iosxe_community_list_expanded.community_list_expanded,
    iosxe_crypto_ipsec_profile.crypto_ipsec_profile,
    iosxe_crypto_ipsec_transform_set.crypto_ipsec_transform_set,
    iosxe_crypto_ikev2.crypto_ikev2,
    iosxe_crypto_ikev2_profile.crypto_ikev2_profile,
    iosxe_crypto_ikev2_keyring.crypto_ikev2_keyring,
    iosxe_crypto_ikev2_policy.crypto_ikev2_policy,
    iosxe_crypto_ikev2_proposal.crypto_ikev2_proposal,
    iosxe_crypto_pki.crypto_pki,
    iosxe_cts.cts,
    iosxe_device_sensor.device_sensor,
    iosxe_dhcp.dhcp,
    iosxe_dot1x.dot1x,
    iosxe_errdisable.errdisable,
    iosxe_evpn.evpn,
    iosxe_evpn_instance.evpn_instance,
    iosxe_flow_exporter.flow_exporter,
    iosxe_flow_monitor.flow_monitor,
    iosxe_flow_record.flow_record,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_switchport.ethernet_switchport,
    iosxe_interface_mpls.ethernet_mpls,
    iosxe_interface_ospf.ethernet_ospf,
    iosxe_interface_ospfv3.ethernet_ospfv3,
    iosxe_interface_pim.ethernet_pim,
    iosxe_interface_loopback.loopback,
    iosxe_interface_mpls.loopback_mpls,
    iosxe_interface_ospf.loopback_ospf,
    iosxe_interface_ospfv3.loopback_ospfv3,
    iosxe_interface_pim.loopback_pim,
    iosxe_interface_vlan.vlan,
    iosxe_interface_mpls.vlan_mpls,
    iosxe_interface_ospf.vlan_ospf,
    iosxe_interface_ospfv3.vlan_ospfv3,
    iosxe_interface_pim.vlan_pim,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_switchport.port_channel_switchport,
    iosxe_interface_mpls.port_channel_mpls,
    iosxe_interface_ospf.port_channel_ospf,
    iosxe_interface_ospfv3.port_channel_ospfv3,
    iosxe_interface_pim.port_channel_pim,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_interface_mpls.port_channel_subinterface_mpls,
    iosxe_interface_ospf.port_channel_subinterface_ospf,
    iosxe_interface_ospfv3.port_channel_subinterface_ospfv3,
    iosxe_interface_pim.port_channel_subinterface_pim,
    iosxe_interface_nve.nve,
    iosxe_license.license,
    iosxe_line.line,
    iosxe_lldp.lldp,
    iosxe_logging.logging,
    iosxe_mdt_subscription.mdt_subscription,
    iosxe_msdp.msdp,
    iosxe_msdp_vrf.msdp_vrf,
    iosxe_ntp.ntp,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf,
    iosxe_pim.pim,
    iosxe_pim_vrf.pim_vrf,
    iosxe_policy_map.policy_map,
    iosxe_policy_map_event.policy_map_event,
    iosxe_prefix_list.prefix_list,
    iosxe_radius.radius,
    iosxe_radius_server.radius_server,
    iosxe_route_map.route_map,
    iosxe_service.service,
    iosxe_service_template.service_template,
    iosxe_snmp_server.snmp_server,
    iosxe_snmp_server_group.snmp_server_group,
    iosxe_snmp_server_user.snmp_server_user,
    iosxe_spanning_tree.spanning_tree,
    iosxe_static_route.static_route,
    iosxe_static_route_vrf.static_route_vrf,
    iosxe_system.system,
    iosxe_tacacs_server.tacacs_server,
    iosxe_template.template,
    iosxe_udld.udld,
    iosxe_username.username,
    iosxe_vlan.vlan,
    iosxe_vlan_configuration.vlan_configuration,
    iosxe_vlan_access_map.vlan_access_map,
    iosxe_vlan_filter.vlan_filter,
    iosxe_vlan_group.vlan_group,
    iosxe_vrf.vrf,
    iosxe_vtp.vtp
  ]
}

resource "iosxe_save_config" "save_config" {
  for_each = { for device in local.devices : device.name => device if var.save_config }
  device   = each.key

  depends_on = [
    iosxe_cli.cli
  ]
}
