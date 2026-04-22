locals {
  vlans = flatten([
    for device in local.devices : [
      for vlan in try(local.device_config[device.name].vlan.vlans, []) : {
        key                      = format("%s/%s", device.name, vlan.id)
        device                   = device.name
        id                       = try(vlan.id, local.defaults.iosxe.configuration.vlan.vlans.id, null)
        name                     = try(vlan.name, local.defaults.iosxe.configuration.vlan.vlans.name, null)
        private_vlan_association = try(vlan.private_vlan_association, local.defaults.iosxe.configuration.vlan.vlans.private_vlan_association, null)
        private_vlan_community   = try(vlan.private_vlan_community, local.defaults.iosxe.configuration.vlan.vlans.private_vlan_community, null)
        private_vlan_isolated    = try(vlan.private_vlan_isolated, local.defaults.iosxe.configuration.vlan.vlans.private_vlan_isolated, null)
        private_vlan_primary     = try(vlan.private_vlan_primary, local.defaults.iosxe.configuration.vlan.vlans.private_vlan_primary, null)
        remote_span              = try(vlan.remote_span, local.defaults.iosxe.configuration.vlan.vlans.remote_span, null)
        shutdown                 = try(vlan.shutdown, local.defaults.iosxe.configuration.vlan.vlans.shutdown, null)
      }
    ]
  ])
}

resource "iosxe_vlan" "vlan" {
  for_each = { for e in local.vlans : e.key => e }
  device   = each.value.device

  vlan_id                  = each.value.id
  name                     = each.value.name
  private_vlan_association = each.value.private_vlan_association
  private_vlan_community   = each.value.private_vlan_community
  private_vlan_isolated    = each.value.private_vlan_isolated
  private_vlan_primary     = each.value.private_vlan_primary
  remote_span              = each.value.remote_span
  shutdown                 = each.value.shutdown
}

locals {
  vlan_config = flatten([
    for device in local.devices : [
      for vlan in try(local.device_config[device.name].vlan.vlans, []) : {
        key                             = format("%s/%s", device.name, vlan.id)
        device                          = device.name
        id                              = try(vlan.id, local.defaults.iosxe.configuration.vlan.vlans.id, null)
        vni                             = try(vlan.vni, local.defaults.iosxe.configuration.vlan.vlans.vni, null)
        access_vfi                      = try(vlan.access_vfi, local.defaults.iosxe.configuration.vlan.vlans.access_vfi, null)
        evpn_instance                   = try(vlan.evpn_instance, local.defaults.iosxe.configuration.vlan.vlans.evpn_instance, null)
        evpn_instance_vni               = try(vlan.evpn_instance_vni, local.defaults.iosxe.configuration.vlan.vlans.evpn_instance_vni, null)
        evpn_instance_protected         = try(vlan.evpn_instance_protected, local.defaults.iosxe.configuration.vlan.vlans.evpn_instance_protected, null)
        evpn_instance_profile           = try(vlan.evpn_instance_profile, local.defaults.iosxe.configuration.vlan.vlans.evpn_instance_profile, null)
        evpn_instance_profile_protected = try(vlan.evpn_instance_profile_protected, local.defaults.iosxe.configuration.vlan.vlans.evpn_instance_profile_protected, null)
      }
    ]
  ])
}

resource "iosxe_vlan_configuration" "vlan_configuration" {
  for_each = { for e in local.vlan_config : e.key => e if(e.vni != null || e.access_vfi != null || e.evpn_instance != null || e.evpn_instance_vni != null || e.evpn_instance_protected != null || e.evpn_instance_profile != null || e.evpn_instance_profile_protected != null) }
  device   = each.value.device

  vlan_id                         = each.value.id
  vni                             = each.value.vni
  access_vfi                      = each.value.access_vfi
  evpn_instance                   = each.value.evpn_instance
  evpn_instance_vni               = each.value.evpn_instance_vni
  evpn_instance_protected         = each.value.evpn_instance_protected
  evpn_instance_profile           = each.value.evpn_instance_profile
  evpn_instance_profile_protected = each.value.evpn_instance_profile_protected

  depends_on = [
    iosxe_evpn_instance.evpn_instance,
    iosxe_evpn_profile.evpn_profile
  ]
}

locals {
  vlan_access_maps = flatten([
    for device in local.devices : [
      for amap in try(local.device_config[device.name].vlan.access_maps, []) : {
        key                = format("%s/%s", device.name, amap.name)
        device             = device.name
        name               = try(amap.name, local.defaults.iosxe.configuration.vlan.access_maps.name, null)
        sequence           = try(amap.sequence, local.defaults.iosxe.configuration.vlan.access_maps.sequence, null)
        action             = try(amap.action, local.defaults.iosxe.configuration.vlan.access_maps.action, null)
        match_ip_address   = try(amap.match_ipv4_addresses, local.defaults.iosxe.configuration.vlan.access_maps.match_ipv4_addresses, null)
        match_ipv6_address = try(amap.match_ipv6_addresses, local.defaults.iosxe.configuration.vlan.access_maps.match_ipv6_addresses, null)
      }
    ]
  ])
}

resource "iosxe_vlan_access_map" "vlan_access_map" {
  for_each = { for e in local.vlan_access_maps : e.key => e }
  device   = each.value.device

  name               = each.value.name
  sequence           = each.value.sequence
  action             = each.value.action
  match_ip_address   = each.value.match_ip_address
  match_ipv6_address = each.value.match_ipv6_address

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}

locals {
  vlan_filters = flatten([
    for device in local.devices : [
      for filter in try(local.device_config[device.name].vlan.filters, []) : {
        key        = format("%s/%s", device.name, filter.name)
        device     = device.name
        word       = try(filter.name, local.defaults.iosxe.configuration.vlan.filters.name, null)
        vlan_lists = try(filter.vlan_lists, local.defaults.iosxe.configuration.vlan.filters.vlan_lists, null)
      }
    ]
  ])
}

resource "iosxe_vlan_filter" "vlan_filter" {
  for_each = { for e in local.vlan_filters : e.key => e }
  device   = each.value.device

  word       = each.value.word
  vlan_lists = each.value.vlan_lists
}

locals {
  vlan_groups = flatten([
    for device in local.devices : [
      for group in try(local.device_config[device.name].vlan.groups, []) : {
        key        = format("%s/%s", device.name, group.name)
        device     = device.name
        name       = try(group.name, local.defaults.iosxe.configuration.vlan.groups.name, null)
        vlan_lists = try(group.vlan_lists, local.defaults.iosxe.configuration.vlan.groups.vlan_lists, null)
      }
    ]
  ])
}

resource "iosxe_vlan_group" "vlan_group" {
  for_each = { for e in local.vlan_groups : e.key => e }
  device   = each.value.device

  name       = each.value.name
  vlan_lists = each.value.vlan_lists
}
