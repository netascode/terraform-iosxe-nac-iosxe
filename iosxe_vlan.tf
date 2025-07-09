locals {
  vlans = flatten([
    for device in local.devices : [
      for vlan in try(local.device_config[device.name].vlan.vlans, []) : {
        key                      = format("%s/%s", device.name, vlan.id)
        device                   = device.name
        id                       = try(vlan.id, null)
        name                     = try(vlan.name, null)
        private_vlan_association = try(vlan.private_vlan_association, null)
        private_vlan_community   = try(vlan.private_vlan_community, null)
        private_vlan_isolated    = try(vlan.private_vlan_isolated, null)
        private_vlan_primary     = try(vlan.private_vlan_primary, null)
        remote_span              = try(vlan.remote_span, null)
        shutdown                 = try(vlan.shutdown, null)
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
        key               = format("%s/%s", device.name, vlan.id)
        device            = device.name
        id                = try(vlan.id, null)
        vni               = try(vlan.vni, null)
        access_vfi        = try(vlan.access_vfi, null)
        evpn_instance     = try(vlan.evpn_instance, null)
        evpn_instance_vni = try(vlan.evpn_instance_vni, null)
      }
    ]
  ])
}

resource "iosxe_vlan_configuration" "vlan_vn_config" {
  for_each = { for e in local.vlan_config : e.key => e }
  device   = each.value.device

  vlan_id           = each.value.id
  vni               = each.value.vni
  access_vfi        = each.value.access_vfi
  evpn_instance     = each.value.evpn_instance
  evpn_instance_vni = each.value.evpn_instance_vni

}

locals {
  vlan_access_maps = flatten([
    for device in local.devices : [
      for amap in try(local.device_config[device.name].vlan.access_maps, []) : {
        key                = format("%s/%s", device.name, amap.name)
        device             = device.name
        name               = try(amap.name, null)
        sequence           = try(amap.sequence, null)
        action             = try(amap.action, null)
        match_ip_address   = try(amap.match_ip_addresses, null)
        match_ipv6_address = try(amap.match_ipv6_addresses, null)
      }
    ]
  ])
}

resource "iosxe_vlan_access_map" "vlan_access_maps" {
  for_each = { for e in local.vlan_access_maps : e.key => e }
  device   = each.value.device

  name               = each.value.name
  sequence           = each.value.sequence
  action             = each.value.action
  match_ip_address   = each.value.match_ip_address
  match_ipv6_address = each.value.match_ipv6_address
}

locals {
  vlan_filters = flatten([
    for device in local.devices : [
      for filter in try(local.device_config[device.name].vlan.filters, []) : {
        key        = format("%s/%s", device.name, filter.word)
        device     = device.name
        word       = try(filter.word, null)
        vlan_lists = try(filter.vlan_lists, null)
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
        name       = try(group.name, null)
        vlan_lists = try(group.vlan_lists, null)
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