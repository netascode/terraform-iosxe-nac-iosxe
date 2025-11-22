locals {
  vrf_configurations = flatten([
    for device in local.devices : [
      for vrf in try(local.device_config[device.name].vrfs, []) : {
        key         = format("%s/%s", device.name, vrf.name)
        device      = device.name
        name        = vrf.name
        description = try(vrf.description, local.defaults.iosxe.configuration.vrfs.description, null)
        rd          = try(vrf.route_distinguisher, local.defaults.iosxe.configuration.vrfs.route_distinguisher, null)

        address_family_ipv4 = try(vrf.address_family_ipv4.enable, local.defaults.iosxe.configuration.vrfs.address_family_ipv4.enable, try(vrf.address_family_ipv4, null) != null ? true : null)
        address_family_ipv6 = try(vrf.address_family_ipv6.enable, local.defaults.iosxe.configuration.vrfs.address_family_ipv6.enable, try(vrf.address_family_ipv6, null) != null ? true : null)

        vpn_id = try(vrf.vpn_id, local.defaults.iosxe.configuration.vrfs.vpn_id, null)


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
      }
    ]
  ])
}

resource "iosxe_vrf" "vrf" {
  for_each = { for vrf in local.vrf_configurations : vrf.key => vrf }

  device      = each.value.device
  name        = each.value.name
  description = each.value.description
  rd          = each.value.rd

  address_family_ipv4 = each.value.address_family_ipv4
  address_family_ipv6 = each.value.address_family_ipv6

  vpn_id = each.value.vpn_id

  ipv4_route_target_import           = each.value.ipv4_route_target_import
  ipv4_route_target_import_stitching = each.value.ipv4_route_target_import_stitching
  ipv4_route_target_export           = each.value.ipv4_route_target_export
  ipv4_route_target_export_stitching = each.value.ipv4_route_target_export_stitching
  ipv4_route_replicate               = each.value.ipv4_route_replicate

  ipv6_route_target_import           = each.value.ipv6_route_target_import
  ipv6_route_target_import_stitching = each.value.ipv6_route_target_import_stitching
  ipv6_route_target_export           = each.value.ipv6_route_target_export
  ipv6_route_target_export_stitching = each.value.ipv6_route_target_export_stitching
}
