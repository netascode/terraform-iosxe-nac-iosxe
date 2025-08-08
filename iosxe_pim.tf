resource "iosxe_pim" "pim" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].pim, null) != null }
  device   = each.value.name

  autorp                 = try(local.device_config[each.value.name].pim.autorp, local.defaults.iosxe.configuration.pim.autorp, null)
  autorp_listener        = try(local.device_config[each.value.name].pim.autorp_listener, local.defaults.iosxe.configuration.pim.autorp_listener, null)
  bsr_candidate_loopback = try(local.device_config[each.value.name].pim.bsr_candidate_loopback, local.defaults.iosxe.configuration.pim.bsr_candidate_loopback, null)
  bsr_candidate_mask     = try(local.device_config[each.value.name].pim.bsr_candidate_mask, local.defaults.iosxe.configuration.pim.bsr_candidate_mask, null)
  bsr_candidate_priority = try(local.device_config[each.value.name].pim.bsr_candidate_priority, local.defaults.iosxe.configuration.pim.bsr_candidate_priority, null)
  ssm_range              = try(local.device_config[each.value.name].pim.ssm_range, local.defaults.iosxe.configuration.pim.ssm_range, null)
  ssm_default            = try(local.device_config[each.value.name].pim.ssm_default, local.defaults.iosxe.configuration.pim.ssm_default, null)
  rp_address             = try(local.device_config[each.value.name].pim.rp_address, local.defaults.iosxe.configuration.pim.rp_address, null)
  rp_address_override    = try(local.device_config[each.value.name].pim.rp_address_override, local.defaults.iosxe.configuration.pim.rp_address_override, null)
  rp_address_bidir       = try(local.device_config[each.value.name].pim.rp_address_bidir, local.defaults.iosxe.configuration.pim.rp_address_bidir, null)

  # Lists
  rp_addresses = [for rp_address in try(local.device_config[each.value.name].pim.rp_addresses, []) : {
    access_list = try(rp_address.access_list, local.defaults.iosxe.configuration.pim.rp_addresses.access_list, null)
    rp_address  = try(rp_address.rp_address, local.defaults.iosxe.configuration.pim.rp_addresses.rp_address, null)
    override    = try(rp_address.override, local.defaults.iosxe.configuration.pim.rp_addresses.override, null)
    bidir       = try(rp_address.bidir, local.defaults.iosxe.configuration.pim.rp_addresses.bidir, null)
    }
  ]

  rp_candidates = [for rp_candidate in try(local.device_config[each.value.name].pim.rp_candidates, []) : {
    interface = try(rp_candidate.interface, local.defaults.iosxe.configuration.pim.rp_candidates.interface, null)
    interval  = try(rp_candidate.interval, local.defaults.iosxe.configuration.pim.rp_candidates.interval, null)
    priority  = try(rp_candidate.priority, local.defaults.iosxe.configuration.pim.rp_candidates.priority, null)
    bidir     = try(rp_candidate.bidir, local.defaults.iosxe.configuration.pim.rp_candidates.bidir, null)
    }
  ]
}