locals {
  prefix_lists = flatten([
    for device in local.devices : [
      for prefix_list in try(local.device_config[device.name].prefix_lists, []) : {
        key    = format("%s/%s", device.name, prefix_list.name)
        device = device.name

        prefixes = [for e in try(prefix_list.seqs, []) : {
          name   = prefix_list.name
          seq    = e.seq
          action = try(e.action, local.defaults.iosxe.configuration.prefix_lists.seqs.action, null)
          ip     = try(e.prefix, local.defaults.iosxe.configuration.prefix_lists.seqs.prefix, null)
          ge     = try(e.greater_equal, local.defaults.iosxe.configuration.prefix_lists.seqs.greater_equal, null)
          le     = try(e.less_equal, local.defaults.iosxe.configuration.prefix_lists.seqs.less_equal, null)
        }]

        prefix_list_description = try(prefix_list.description != null ?
          [{
            name        = prefix_list.name
            description = prefix_list.description
          }] : null, null
        )
      }
    ]
  ])
}



resource "iosxe_prefix_list" "prefix_list" {
  for_each = { for e in local.prefix_lists : e.key => e }
  device   = each.value.device

  prefixes                = each.value.prefixes
  prefix_list_description = each.value.prefix_list_description
}