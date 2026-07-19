resource "iosxe_cdp" "cdp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].cdp, null) != null }
  device   = each.value.name

  holdtime        = try(local.device_config[each.value.name].cdp.holdtime, null)
  timer           = try(local.device_config[each.value.name].cdp.timer, null)
  run             = try(local.device_config[each.value.name].cdp.run, null)
  filter_tlv_list = try(local.device_config[each.value.name].cdp.filter_tlv, null)
  tlv_lists = try(length(local.device_config[each.value.name].cdp.tlv_lists) == 0, true) ? null : [for tlv in local.device_config[each.value.name].cdp.tlv_lists : {
    name            = try(tlv.name, null)
    vtp_mgmt_domain = try(tlv.vtp_mgmt_domain, null)
    cos             = try(tlv.cos, null)
    duplex          = try(tlv.duplex, null)
    trust           = try(tlv.trust, null)
    version         = try(tlv.version, null)
  }]
}