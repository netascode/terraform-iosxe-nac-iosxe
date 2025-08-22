resource "iosxe_cdp" "cdp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].cdp, null) != null }
  device   = each.value.name

  holdtime        = try(local.device_config[each.value.name].cdp.holdtime, local.defaults.iosxe.configuration.cdp.holdtime, null)
  timer           = try(local.device_config[each.value.name].cdp.timer, local.defaults.iosxe.configuration.cdp.timer, null)
  run             = try(local.device_config[each.value.name].cdp.run, local.defaults.iosxe.configuration.cdp.run, null)
  filter_tlv_list = try(local.device_config[each.value.name].cdp.filter_tlv, local.defaults.iosxe.configuration.cdp.filter_tlv, null)
  tlv_lists = try(length(local.device_config[each.value.name].cdp.tlv_lists) == 0, true) ? null : [for tlv in local.device_config[each.value.name].cdp.tlv_lists : {
    name            = try(tlv.name, local.defaults.iosxe.configuration.cdp.tlv_lists.name, null)
    vtp_mgmt_domain = try(tlv.vtp_mgmt_domain, local.defaults.iosxe.configuration.cdp.tlv_lists.vtp_mgmt_domain, null)
    cos             = try(tlv.cos, local.defaults.iosxe.configuration.cdp.tlv_lists.cos, null)
    duplex          = try(tlv.duplex, local.defaults.iosxe.configuration.cdp.tlv_lists.duplex, null)
    trust           = try(tlv.trust, local.defaults.iosxe.configuration.cdp.tlv_lists.trust, null)
    version         = try(tlv.version, local.defaults.iosxe.configuration.cdp.tlv_lists.version, null)
  }]
}