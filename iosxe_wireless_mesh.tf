locals {
  wireless_mesh_convergence_map = {
    "standard"            = "mesh-convergence-standard"
    "fast"                = "mesh-convergence-fast"
    "very-fast"           = "mesh-convergence-veryfast"
    "noise-tolerant-fast" = "mesh-convergence-noise-tolerant-fast"
  }
  wireless_mesh_multicast_map = {
    "regular" = "mesh-multicast-mode-regular"
    "in-only" = "mesh-multicast-mode-in"
    "in-out"  = "mesh-multicast-mode-inout"
  }
  wireless_mesh_security_map = {
    "eap" = "mesh-security-mode-eap"
    "psk" = "mesh-security-mode-psk"
  }

  # YANG defaults (Cisco-IOS-XE-wireless-mesh-cfg, 17.15.1 and 17.18.1). The
  # controller omits a leaf at its default from get-config, so a value equal to
  # its default is sent as null; otherwise it shows a diff on every plan.
  wireless_mesh_yang_defaults = {
    convergence_method = "mesh-convergence-standard"
    multicast_mode     = "mesh-multicast-mode-inout"
    range              = 12000
    security_mode      = "mesh-security-mode-eap"
  }

  wireless_mesh_profiles = flatten([
    for device in local.devices : [
      for profile in try(local.device_config[device.name].wireless.mesh_profiles, []) : {
        key                = format("%s/%s", device.name, profile.name)
        device             = device.name
        profile_name       = profile.name
        description        = try(profile.description, null)
        convergence_method = try(local.wireless_mesh_convergence_map[profile.convergence], null) == local.wireless_mesh_yang_defaults.convergence_method ? null : try(local.wireless_mesh_convergence_map[profile.convergence], null)
        multicast_mode     = try(local.wireless_mesh_multicast_map[profile.multicast], null) == local.wireless_mesh_yang_defaults.multicast_mode ? null : try(local.wireless_mesh_multicast_map[profile.multicast], null)
        range              = try(profile.range, null) == local.wireless_mesh_yang_defaults.range ? null : try(profile.range, null)
        security_mode      = try(local.wireless_mesh_security_map[profile.security], null) == local.wireless_mesh_yang_defaults.security_mode ? null : try(local.wireless_mesh_security_map[profile.security], null)
      }
    ]
  ])
}

resource "iosxe_wireless_mesh_profile" "wireless_mesh_profile" {
  for_each = { for e in local.wireless_mesh_profiles : e.key => e }

  device             = each.value.device
  profile_name       = each.value.profile_name
  description        = each.value.description
  convergence_method = each.value.convergence_method
  multicast_mode     = each.value.multicast_mode
  range              = each.value.range
  security_mode      = each.value.security_mode
}
