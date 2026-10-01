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

  wireless_mesh_profiles = flatten([
    for device in local.devices : [
      for profile in try(local.device_config[device.name].wireless.mesh_profiles, []) : {
        key          = format("%s/%s", device.name, profile.name)
        device       = device.name
        profile_name = profile.name
        description  = try(profile.description, null)
        convergence_method = try(
          local.wireless_mesh_convergence_map[profile.convergence],
          null
        )
        multicast_mode = try(
          local.wireless_mesh_multicast_map[profile.multicast],
          null
        )
        range = try(profile.range, null)
        security_mode = try(
          local.wireless_mesh_security_map[profile.security],
          null
        )
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
