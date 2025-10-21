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
  cli_templates_0 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 0
    ]
  ])
  cli_templates_1 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 1
    ]
  ])
  cli_templates_2 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 2
    ]
  ])
  cli_templates_3 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 3
    ]
  ])
  cli_templates_4 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 4
    ]
  ])
  cli_templates_5 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 5
    ]
  ])
  cli_templates_6 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 6
    ]
  ])
  cli_templates_7 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 7
    ]
  ])
  cli_templates_8 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 8
    ]
  ])
  cli_templates_9 = flatten([
    for device in local.devices : [
      for template in try(device.cli_templates, []) : {
        key     = format("%s/%s", device.name, template.name)
        device  = device.name
        content = template.content
      } if try(template.order, local.defaults.iosxe.templates.order) == 9
    ]
  ])
}

resource "iosxe_cli" "cli_0" {
  for_each = { for e in local.cli_templates_0 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_aaa.aaa,
    iosxe_aaa_accounting.aaa_accounting,
    iosxe_aaa_authentication.aaa_authentication,
    iosxe_aaa_authorization.aaa_authorization,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_access_list_role_based.access_list_role_based,
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
    iosxe_nat.nat,
    iosxe_ntp.ntp,
    iosxe_ospf.ospf,
    iosxe_ospf_vrf.ospf_vrf,
    iosxe_pim.pim,
    iosxe_policy_map.policy_map,
    iosxe_policy_map_event.policy_map_event,
    iosxe_prefix_list.prefix_list,
    iosxe_radius.radius,
    iosxe_radius_server.radius_server,
    iosxe_route_map.route_map,
    iosxe_service.service,
    iosxe_service_template.service_template,
    iosxe_sla.sla,
    iosxe_snmp_server.snmp_server,
    iosxe_spanning_tree.spanning_tree,
    iosxe_static_route.static_route,
    iosxe_static_routes_vrf.static_routes_vrf,
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

resource "iosxe_cli" "cli_1" {
  for_each = { for e in local.cli_templates_1 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_0
  ]
}

resource "iosxe_cli" "cli_2" {
  for_each = { for e in local.cli_templates_2 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_1
  ]
}

resource "iosxe_cli" "cli_3" {
  for_each = { for e in local.cli_templates_3 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_2
  ]
}

resource "iosxe_cli" "cli_4" {
  for_each = { for e in local.cli_templates_4 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_3
  ]
}

resource "iosxe_cli" "cli_5" {
  for_each = { for e in local.cli_templates_5 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_4
  ]
}

resource "iosxe_cli" "cli_6" {
  for_each = { for e in local.cli_templates_6 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_5
  ]
}

resource "iosxe_cli" "cli_7" {
  for_each = { for e in local.cli_templates_7 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_6
  ]
}

resource "iosxe_cli" "cli_8" {
  for_each = { for e in local.cli_templates_8 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_7
  ]
}

resource "iosxe_cli" "cli_9" {
  for_each = { for e in local.cli_templates_9 : e.key => e }
  device   = each.value.device

  cli = each.value.content
  raw = true

  depends_on = [
    iosxe_cli.cli_8
  ]
}

resource "iosxe_save_config" "save_config" {
  for_each = { for device in local.devices : device.name => device if var.save_config }
  device   = each.key

  depends_on = [
    iosxe_cli.cli_9
  ]
}
