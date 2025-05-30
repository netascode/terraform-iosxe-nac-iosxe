resource "iosxe_prefix_list" "prefix_list" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].prefix_lists, null) != null || try(local.defaults.iosxe.configuration.prefix_lists, null) != null }
  device = each.value.name
  
  prefixes = [for e in try(local.device_config[each.value.name].prefix_lists.seqs, []): {
    name = try(local.device_config[each.value.name].prefix_lists.name, local.defaults.iosxe.configuration.prefix_lists.name, null)
    seq = try(e.seq, local.defaults.iosxe.configuration.prefix_lists.seqs.seq, null)
    action = try(e.action, local.defaults.iosxe.configuration.prefix_lists.seqs.action, null)
    ip = try(e.ip, local.defaults.iosxe.configuration.prefix_lists.seqs.ip, null)
    ge = try(e.greater_equal, local.defaults.iosxe.configuration.prefix_lists.seqs.greater_equal, null)
    le = try(e.less_equal, local.defaults.iosxe.configuration.prefix_lists.seqs.less_equal, null)
  }]

  prefix_list_description = [for e in try(local.device_config[each.value.name].prefix_lists.seqs, []): {
    name = try(local.device_config[each.value.name].prefix_lists.name, local.defaults.iosxe.configuration.prefix_lists.name, null)
    description = try(local.device_config[each.value.name].prefix_lists.description, local.defaults.iosxe.configuration.prefix_lists.description, null)
  }]

}