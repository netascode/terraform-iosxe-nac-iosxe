locals {
  vrf_configurations = flatten([
    for device in local.devices : [
      for vrf in try(local.device_config[device.name].vrfs, []) : {
        key                 = format("%s/%s", device.name, vrf.name)
        device              = device.name
        name                = vrf.name
        description         = try(vrf.description, local.defaults.iosxe.configuration.vrfs.description, null)
        rd                  = try(vrf.route_distinguisher, local.defaults.iosxe.configuration.vrfs.route_distinguisher, null)
        rd_auto             = try(vrf.rd_auto, local.defaults.iosxe.configuration.vrfs.rd_auto, null)
        address_family_ipv4 = try(vrf.address_family_ipv4.enable, local.defaults.iosxe.configuration.vrfs.address_family_ipv4.enable, try(vrf.address_family_ipv4, null) != null ? true : null)
        address_family_ipv6 = try(vrf.address_family_ipv6.enable, local.defaults.iosxe.configuration.vrfs.address_family_ipv6.enable, try(vrf.address_family_ipv6, null) != null ? true : null)

        vpn_id = try(vrf.vpn_id, local.defaults.iosxe.configuration.vrfs.vpn_id, null)

        vnid = try(length(vrf.vnid) == 0, true) ? null : [
          for v in vrf.vnid : {
            vnid_value = v.vnid_value
            evpn_instance_vni = try(length(v.evpn_instance_vni) == 0, true) ? null : [
              for vni in v.evpn_instance_vni : {
                vni_num   = vni.vni_num
                core_vlan = try(vni.core_vlan, null)
              }
            ]
          }
        ]


        ipv4_route_target_import = try(length(vrf.address_family_ipv4.import_route_targets) == 0, true) ? null : [
          for rt in vrf.address_family_ipv4.import_route_targets : {
            value = rt
          }
        ]

        ipv4_route_target_import_stitching = try(length(vrf.address_family_ipv4.import_route_targets_stitching) == 0, true) ? null : [
          for rt in vrf.address_family_ipv4.import_route_targets_stitching : {
            value = rt
          }
        ]

        ipv4_route_target_export = try(length(vrf.address_family_ipv4.export_route_targets) == 0, true) ? null : [
          for rt in vrf.address_family_ipv4.export_route_targets : {
            value = rt
          }
        ]

        ipv4_route_target_export_stitching = try(length(vrf.address_family_ipv4.export_route_targets_stitching) == 0, true) ? null : [
          for rt in vrf.address_family_ipv4.export_route_targets_stitching : {
            value = rt
          }
        ]

        ipv4_route_replicate = try(length(vrf.address_family_ipv4.route_replicate) == 0, true) ? null : [
          for rr in vrf.address_family_ipv4.route_replicate : {
            name                  = rr.name
            unicast_all           = true
            unicast_all_route_map = try(rr.route_map, null)
          }
        ]

        ipv6_route_target_import = try(length(vrf.address_family_ipv6.import_route_targets) == 0, true) ? null : [
          for rt in vrf.address_family_ipv6.import_route_targets : {
            value = rt
          }
        ]

        ipv6_route_target_import_stitching = try(length(vrf.address_family_ipv6.import_route_targets_stitching) == 0, true) ? null : [
          for rt in vrf.address_family_ipv6.import_route_targets_stitching : {
            value = rt
          }
        ]

        ipv6_route_target_export = try(length(vrf.address_family_ipv6.export_route_targets) == 0, true) ? null : [
          for rt in vrf.address_family_ipv6.export_route_targets : {
            value = rt
          }
        ]

        ipv6_route_target_export_stitching = try(length(vrf.address_family_ipv6.export_route_targets_stitching) == 0, true) ? null : [
          for rt in vrf.address_family_ipv6.export_route_targets_stitching : {
            value = rt
          }
        ]

        ipv4_evpn_mcast_mdt_default_address = try(
          vrf.address_family_ipv4.evpn_mcast.mdt_default_address,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.evpn_mcast.mdt_default_address,
          null
        )

        ipv4_evpn_mcast_anycast = try(
          vrf.address_family_ipv4.evpn_mcast.anycast,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.evpn_mcast.anycast,
          null
        )

        ipv4_evpn_mcast_data_address = try(
          vrf.address_family_ipv4.evpn_mcast.data_address,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.evpn_mcast.data_address,
          null
        )

        ipv4_evpn_mcast_data_mask_bits = try(
          vrf.address_family_ipv4.evpn_mcast.data_mask_bits,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.evpn_mcast.data_mask_bits,
          null
        )

        ipv6_evpn_mcast_mdt_default_address = try(
          vrf.address_family_ipv6.evpn_mcast.mdt_default_address,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv6.evpn_mcast.mdt_default_address,
          null
        )

        ipv6_evpn_mcast_anycast = try(
          vrf.address_family_ipv6.evpn_mcast.anycast,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv6.evpn_mcast.anycast,
          null
        )

        ipv6_evpn_mcast_data_address = try(
          vrf.address_family_ipv6.evpn_mcast.data_address,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv6.evpn_mcast.data_address,
          null
        )

        ipv6_evpn_mcast_data_mask_bits = try(
          vrf.address_family_ipv6.evpn_mcast.data_mask_bits,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv6.evpn_mcast.data_mask_bits,
          null
        )

        ipv4_mdt_default_address = try(
          vrf.address_family_ipv4.mdt.default_address,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.default_address,
          null
        )

        ipv4_mdt_auto_discovery_vxlan = try(
          vrf.address_family_ipv4.mdt.auto_discovery_vxlan,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.auto_discovery_vxlan,
          null
        )

        ipv4_mdt_auto_discovery_vxlan_inter_as = try(
          vrf.address_family_ipv4.mdt.auto_discovery_vxlan_inter_as,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.auto_discovery_vxlan_inter_as,
          null
        )

        ipv4_mdt_auto_discovery_interworking_vxlan_pim = try(
          vrf.address_family_ipv4.mdt.auto_discovery_interworking_vxlan_pim,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.auto_discovery_interworking_vxlan_pim,
          null
        )

        ipv4_mdt_auto_discovery_interworking_vxlan_pim_inter_as = try(
          vrf.address_family_ipv4.mdt.auto_discovery_interworking_vxlan_pim_inter_as,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.auto_discovery_interworking_vxlan_pim_inter_as,
          null
        )

        ipv4_mdt_overlay_use_bgp = try(
          vrf.address_family_ipv4.mdt.overlay_use_bgp,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.overlay_use_bgp,
          null
        )

        ipv4_mdt_overlay_use_bgp_spt_only = try(
          vrf.address_family_ipv4.mdt.overlay_use_bgp_spt_only,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.overlay_use_bgp_spt_only,
          null
        )

        ipv4_mdt_data_threshold = try(
          vrf.address_family_ipv4.mdt.data_threshold,
          local.defaults.iosxe.configuration.vrfs.address_family_ipv4.mdt.data_threshold,
          null
        )

        ipv4_mdt_data_multicast = try(length(vrf.address_family_ipv4.mdt.data_multicast) == 0, true) ? null : [
          for dm in vrf.address_family_ipv4.mdt.data_multicast : {
            address  = dm.address
            wildcard = dm.wildcard
            list     = try(dm.access_list, null)
          }
        ]
      }
    ]
  ])
}

resource "iosxe_vrf" "vrf" {
  for_each = { for vrf in local.vrf_configurations : vrf.key => vrf }

  device              = each.value.device
  name                = each.value.name
  description         = each.value.description
  rd                  = each.value.rd
  rd_auto             = each.value.rd_auto
  address_family_ipv4 = each.value.address_family_ipv4
  address_family_ipv6 = each.value.address_family_ipv6

  vpn_id = each.value.vpn_id

  vnid = each.value.vnid

  ipv4_route_target_import           = each.value.ipv4_route_target_import
  ipv4_route_target_import_stitching = each.value.ipv4_route_target_import_stitching
  ipv4_route_target_export           = each.value.ipv4_route_target_export
  ipv4_route_target_export_stitching = each.value.ipv4_route_target_export_stitching
  ipv4_route_replicate               = each.value.ipv4_route_replicate

  ipv6_route_target_import           = each.value.ipv6_route_target_import
  ipv6_route_target_import_stitching = each.value.ipv6_route_target_import_stitching
  ipv6_route_target_export           = each.value.ipv6_route_target_export
  ipv6_route_target_export_stitching = each.value.ipv6_route_target_export_stitching

  ipv4_evpn_mcast_mdt_default_address = each.value.ipv4_evpn_mcast_mdt_default_address
  ipv4_evpn_mcast_anycast             = each.value.ipv4_evpn_mcast_anycast
  ipv4_evpn_mcast_data_address        = each.value.ipv4_evpn_mcast_data_address
  ipv4_evpn_mcast_data_mask_bits      = each.value.ipv4_evpn_mcast_data_mask_bits

  ipv6_evpn_mcast_mdt_default_address = each.value.ipv6_evpn_mcast_mdt_default_address
  ipv6_evpn_mcast_anycast             = each.value.ipv6_evpn_mcast_anycast
  ipv6_evpn_mcast_data_address        = each.value.ipv6_evpn_mcast_data_address
  ipv6_evpn_mcast_data_mask_bits      = each.value.ipv6_evpn_mcast_data_mask_bits

  ipv4_mdt_default_address                                = each.value.ipv4_mdt_default_address
  ipv4_mdt_auto_discovery_vxlan                           = each.value.ipv4_mdt_auto_discovery_vxlan
  ipv4_mdt_auto_discovery_vxlan_inter_as                  = each.value.ipv4_mdt_auto_discovery_vxlan_inter_as
  ipv4_mdt_auto_discovery_interworking_vxlan_pim          = each.value.ipv4_mdt_auto_discovery_interworking_vxlan_pim
  ipv4_mdt_auto_discovery_interworking_vxlan_pim_inter_as = each.value.ipv4_mdt_auto_discovery_interworking_vxlan_pim_inter_as
  ipv4_mdt_overlay_use_bgp                                = each.value.ipv4_mdt_overlay_use_bgp
  ipv4_mdt_overlay_use_bgp_spt_only                       = each.value.ipv4_mdt_overlay_use_bgp_spt_only
  ipv4_mdt_data_multicast                                 = each.value.ipv4_mdt_data_multicast
  ipv4_mdt_data_threshold                                 = each.value.ipv4_mdt_data_threshold
}
