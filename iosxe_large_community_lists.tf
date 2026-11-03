locals {
  large_community_lists_expanded = flatten([
    for device in local.devices : [
      for community_list in try(local.device_config[device.name].large_community_lists.expanded, []) : {
        key    = format("%s/%s", device.name, community_list.name)
        device = device.name

        name = community_list.name
        entries = try(length(community_list.entries) == 0, true) ? null : [for e in community_list.entries : {
          action = try(e.action, null)
          regex  = try(e.regex, null)
        }]
      }
    ]
  ])
}

resource "iosxe_large_community_list_expanded" "large_community_list_expanded" {
  for_each = { for e in local.large_community_lists_expanded : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries
}
