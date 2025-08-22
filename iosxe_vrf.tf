locals {
  vrf_configurations = flatten([
    for device in local.devices : [
      for vrf in try(local.device_config[device.name].vrfs, []) : {
        key         = format("%s/%s", device.name, vrf.name)
        device      = device.name
        name        = vrf.name
        description = try(vrf.description, local.defaults.iosxe.configuration.vrfs.description, null)
        rd          = try(vrf.route_distinguisher, local.defaults.iosxe.configuration.vrfs.route_distinguisher, null)

        address_family_ipv4 = try(vrf.address_family_ipv4, local.defaults.iosxe.configuration.vrfs.address_family_ipv4, null)
        address_family_ipv6 = try(vrf.address_family_ipv6, local.defaults.iosxe.configuration.vrfs.address_family_ipv6, null)

        vpn_id = try(vrf.vpn_id, local.defaults.iosxe.configuration.vrfs.vpn_id, null)

        route_target_import = try(length(vrf.import_route_targets) == 0, true) ? null : [
          for rt in vrf.import_route_targets : {
            value     = try(rt.value, local.defaults.iosxe.configuration.vrfs.import_route_targets.value, null)
            stitching = try(rt.stitching, local.defaults.iosxe.configuration.vrfs.import_route_targets.stitching, null)
            ipv4      = try(rt.ipv4, local.defaults.iosxe.configuration.vrfs.import_route_targets.ipv4, null)
            ipv6      = try(rt.ipv6, local.defaults.iosxe.configuration.vrfs.import_route_targets.ipv6, null)
          }
        ]

        route_target_export = try(length(vrf.export_route_targets) == 0, true) ? null : [
          for rt in vrf.export_route_targets : {
            value     = try(rt.value, local.defaults.iosxe.configuration.vrfs.export_route_targets.value, null)
            stitching = try(rt.stitching, local.defaults.iosxe.configuration.vrfs.export_route_targets.stitching, null)
            ipv4      = try(rt.ipv4, local.defaults.iosxe.configuration.vrfs.export_route_targets.ipv4, null)
            ipv6      = try(rt.ipv6, local.defaults.iosxe.configuration.vrfs.export_route_targets.ipv6, null)
          }
        ]

        ipv4_route_target_import = try(length(vrf.ipv4_route_target_imports) == 0, true) ? null : [
          for rt in vrf.ipv4_route_target_imports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv4_route_target_imports.value, null)
          } if try(rt.stitching, false) == false
        ]

        ipv4_route_target_import_stitching = try(length(vrf.ipv4_route_target_imports) == 0, true) ? null : [
          for rt in vrf.ipv4_route_target_imports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv4_route_target_imports.value, null)
          } if try(rt.stitching, false) == true
        ]

        ipv4_route_target_export = try(length(vrf.ipv4_route_target_exports) == 0, true) ? null : [
          for rt in vrf.ipv4_route_target_exports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv4_route_target_exports.value, null)
          } if try(rt.stitching, false) == false
        ]

        ipv4_route_target_export_stitching = try(length(vrf.ipv4_route_target_exports) == 0, true) ? null : [
          for rt in vrf.ipv4_route_target_exports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv4_route_target_exports.value, null)
          } if try(rt.stitching, false) == true
        ]

        ipv6_route_target_import = try(length(vrf.ipv6_route_target_imports) == 0, true) ? null : [
          for rt in vrf.ipv6_route_target_imports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv6_route_target_imports.value, null)
          } if try(rt.stitching, false) == false
        ]

        ipv6_route_target_import_stitching = try(length(vrf.ipv6_route_target_imports) == 0, true) ? null : [
          for rt in vrf.ipv6_route_target_imports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv6_route_target_imports.value, null)
          } if try(rt.stitching, false) == true
        ]

        ipv6_route_target_export = try(length(vrf.ipv6_route_target_exports) == 0, true) ? null : [
          for rt in vrf.ipv6_route_target_exports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv6_route_target_exports.value, null)
          } if try(rt.stitching, false) == false
        ]

        ipv6_route_target_export_stitching = try(length(vrf.ipv6_route_target_exports) == 0, true) ? null : [
          for rt in vrf.ipv6_route_target_exports : {
            value = try(rt.value, local.defaults.iosxe.configuration.vrfs.ipv6_route_target_exports.value, null)
          } if try(rt.stitching, false) == true
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

  route_target_import = each.value.route_target_import
  route_target_export = each.value.route_target_export

  ipv4_route_target_import           = each.value.ipv4_route_target_import
  ipv4_route_target_import_stitching = each.value.ipv4_route_target_import_stitching
  ipv4_route_target_export           = each.value.ipv4_route_target_export
  ipv4_route_target_export_stitching = each.value.ipv4_route_target_export_stitching

  ipv6_route_target_import           = each.value.ipv6_route_target_import
  ipv6_route_target_import_stitching = each.value.ipv6_route_target_import_stitching
  ipv6_route_target_export           = each.value.ipv6_route_target_export
  ipv6_route_target_export_stitching = each.value.ipv6_route_target_export_stitching
}
