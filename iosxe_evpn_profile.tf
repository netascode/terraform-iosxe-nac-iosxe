locals {
  evpn_profile_list = flatten([
    for device in local.devices : [
      for profile in try(local.device_config[device.name].evpn_profile.profiles, []) : {
        key        = format("%s/%s", device.name, profile.name)
        device     = device.name
        name       = try(profile.name, local.defaults.iosxe.configuration.evpn_profile.profiles.name, null)
        evi_base   = try(profile.evi_base, local.defaults.iosxe.configuration.evpn_profile.profiles.evi_base, null)
        l2vni_base = try(profile.l2vni_base, local.defaults.iosxe.configuration.evpn_profile.profiles.l2vni_base, null)
      }
    ]
  ])
}

resource "iosxe_evpn_profile" "evpn_profile" {
  for_each = { for item in local.evpn_profile_list : item.key => item }

  device     = each.value.device
  name       = each.value.name
  evi_base   = each.value.evi_base
  l2vni_base = each.value.l2vni_base

  depends_on = [
    iosxe_evpn.evpn
  ]
}
