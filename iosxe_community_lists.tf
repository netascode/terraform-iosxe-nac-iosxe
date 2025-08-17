locals {
  community_lists_standard = flatten([
    for device in local.devices : [
      for community_list in try(local.device_config[device.name].community_lists.standard, []) : {
        key    = format("%s/%s", device.name, community_list.name)
        device = device.name

        name           = community_list.name
        deny_entries   = [for e in try(community_list.entries, []) : try(e.communities, local.defaults.iosxe.configuration.community_lists.standard.entries.communities, null) if e.action == "deny"]
        permit_entries = [for e in try(community_list.entries, []) : try(e.communities, local.defaults.iosxe.configuration.community_lists.standard.entries.communities, null) if e.action == "permit"]
      }
    ]
  ])
}

resource "iosxe_community_list_standard" "community_list_standard" {
  for_each = { for e in local.community_lists_standard : e.key => e }
  device   = each.value.device

  name           = each.value.name
  deny_entries   = each.value.deny_entries
  permit_entries = each.value.permit_entries
}

locals {
  community_lists_expanded = flatten([
    for device in local.devices : [
      for community_list in try(local.device_config[device.name].community_lists.expanded, []) : {
        key    = format("%s/%s", device.name, community_list.name)
        device = device.name

        name = community_list.name
        entries = [for e in try(community_list.entries, []) : {
          action = try(e.action, local.defaults.iosxe.configuration.community_lists.expanded.entries.action, null)
          regex  = try(e.regex, local.defaults.iosxe.configuration.community_lists.expanded.entries.regex, null)
        }]
      }
    ]
  ])
}

resource "iosxe_community_list_expanded" "community_list_expanded" {
  for_each = { for e in local.community_lists_expanded : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries
}
