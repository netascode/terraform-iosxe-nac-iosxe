locals {
  wireless_flex_profiles = flatten([
    for device in local.devices : [
      for fp in try(local.device_config[device.name].wireless.flex_profiles, []) : {
        key                     = format("%s/%s", device.name, fp.name)
        device                  = device.name
        name                    = fp.name
        description             = try(fp.description, null)
        native_vlan_id          = try(fp.native_vlan_id, null)
        arp_caching             = try(fp.arp_caching, null)
        fallback_radio_shut     = try(fp.fallback_radio_shut, null)
        efficient_image_upgrade = try(fp.efficient_image_upgrade, null)

        vlan_names = try(length(fp.vlan_names) == 0, true) ? null : [
          for vn in fp.vlan_names : {
            name    = vn.name
            vlan_id = try(vn.vlan_id, null)
          }
        ]

        acl_policies = try(length(fp.acl_policies) == 0, true) ? null : [
          for acl in fp.acl_policies : {
            name = acl.name
          }
        ]
      }
    ]
  ])
}

resource "iosxe_wireless_flex_profile" "wireless_flex_profile" {
  for_each = { for e in local.wireless_flex_profiles : e.key => e }

  device                  = each.value.device
  name                    = each.value.name
  description             = each.value.description
  native_vlan_id          = each.value.native_vlan_id
  arp_caching             = each.value.arp_caching
  fallback_radio_shut     = each.value.fallback_radio_shut
  efficient_image_upgrade = each.value.efficient_image_upgrade
  vlan_names              = each.value.vlan_names
  acl_policies            = each.value.acl_policies
}
