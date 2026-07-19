resource "iosxe_arp" "arp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].arp, null) != null }
  device   = each.value.name

  incomplete_entries = try(local.device_config[each.value.name].arp.incomplete_entries, null)
  proxy_disable      = try(local.device_config[each.value.name].arp.proxy_disable, null)
  entry_learn        = try(local.device_config[each.value.name].arp.entry_learn, null)

  inspection_filters = try(length(local.device_config[each.value.name].arp.inspection_filters) == 0, true) ? null : [for e in local.device_config[each.value.name].arp.inspection_filters : {
    name = try(e.name, null)
    vlans = try(length(e.vlans) == 0, true) ? null : [for v in e.vlans : {
      vlan_range = try(
        provider::utils::normalize_vlans(
          {
            ids    = try(v.ids, [])
            ranges = try(v.ranges, [])
          },
          "string"
        ),
        null
      )
      static = try(v.static, null)
    }]
  }]

  inspection_validate_src_mac         = try(local.device_config[each.value.name].arp.inspection_validate_src_mac, null)
  inspection_validate_dst_mac         = try(local.device_config[each.value.name].arp.inspection_validate_dst_mac, null)
  inspection_validate_ip              = try(local.device_config[each.value.name].arp.inspection_validate_ip, null)
  inspection_validate_allow_zeros     = try(local.device_config[each.value.name].arp.inspection_validate_allow_zeros, null)
  inspection_log_buffer_entries       = try(local.device_config[each.value.name].arp.inspection_log_buffer_entries, null)
  inspection_log_buffer_logs_entries  = try(local.device_config[each.value.name].arp.inspection_log_buffer_logs_entries, null)
  inspection_log_buffer_logs_interval = try(local.device_config[each.value.name].arp.inspection_log_buffer_logs_interval, null)
  inspection_vlan                     = try(local.device_config[each.value.name].arp.inspection_vlan, null)

  depends_on = [
    iosxe_vlan.vlan,
  ]
}