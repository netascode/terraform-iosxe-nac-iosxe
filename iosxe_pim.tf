resource "iosxe_pim" "pim" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].pim, null) != null }
  device   = each.value.name

  autorp                             = try(local.device_config[each.value.name].pim.autorp, null)
  autorp_listener                    = try(local.device_config[each.value.name].pim.autorp_listener, null)
  bsr_candidate_loopback             = try(local.device_config[each.value.name].pim.bsr_candidate_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].pim.bsr_candidate_interface_id, null) : null
  bsr_candidate_mask                 = try(local.device_config[each.value.name].pim.bsr_candidate_mask, null)
  bsr_candidate_priority             = try(local.device_config[each.value.name].pim.bsr_candidate_priority, null)
  bsr_candidate_accept_rp_candidate  = try(local.device_config[each.value.name].pim.bsr_candidate_accept_rp_candidate, null)
  register_source_interface_loopback = try(local.device_config[each.value.name].pim.register_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].pim.register_source_interface_id, null) : null
  ssm_range                          = try(local.device_config[each.value.name].pim.ssm_range, null)
  ssm_default                        = try(local.device_config[each.value.name].pim.ssm_default, null)
  rp_address                         = try(local.device_config[each.value.name].pim.rp_address, null)
  rp_address_override                = try(local.device_config[each.value.name].pim.rp_address_override, null)
  rp_address_bidir                   = try(local.device_config[each.value.name].pim.rp_address_bidir, null)

  # Lists
  rp_addresses = try(length(local.device_config[each.value.name].pim.rp_addresses) == 0, true) ? null : [for rp_address in local.device_config[each.value.name].pim.rp_addresses : {
    access_list = try(rp_address.access_list, null)
    rp_address  = try(rp_address.rp_address, null)
    override    = try(rp_address.override, null)
    bidir       = try(rp_address.bidir, null)
    }
  ]

  rp_candidates = try(length(local.device_config[each.value.name].pim.rp_candidates) == 0, true) ? null : [for rp_candidate in local.device_config[each.value.name].pim.rp_candidates : {
    interface  = try(rp_candidate.interface, null)
    group_list = try(rp_candidate.group_list, null)
    interval   = try(rp_candidate.interval, null)
    priority   = try(rp_candidate.priority, null)
    bidir      = try(rp_candidate.bidir, null)
    }
  ]

  vrfs = try(length(local.device_config[each.value.name].pim.vrfs) == 0, true) ? null : [for vrf in local.device_config[each.value.name].pim.vrfs : {
    vrf                                = try(vrf.vrf, null)
    autorp                             = try(vrf.autorp, null)
    autorp_listener                    = try(vrf.autorp_listener, null)
    bsr_candidate_loopback             = try(vrf.bsr_candidate_interface_type, null) == "Loopback" ? try(vrf.bsr_candidate_interface_id, null) : null
    bsr_candidate_mask                 = try(vrf.bsr_candidate_mask, null)
    bsr_candidate_priority             = try(vrf.bsr_candidate_priority, null)
    bsr_candidate_accept_rp_candidate  = try(vrf.bsr_candidate_accept_rp_candidate, null)
    register_source_interface_loopback = try(vrf.register_source_interface_type, null) == "Loopback" ? try(vrf.register_source_interface_id, null) : null
    cache_rpf_oif                      = try(vrf.cache_rpf_oif, null)
    ssm_range                          = try(vrf.ssm_range, null)
    ssm_default                        = try(vrf.ssm_default, null)
    rp_address                         = try(vrf.rp_address, null)
    rp_address_override                = try(vrf.rp_address_override, null)
    rp_address_bidir                   = try(vrf.rp_address_bidir, null)
    rp_addresses = try(length(vrf.rp_addresses) == 0, true) ? null : [for rp_address in vrf.rp_addresses : {
      access_list = try(rp_address.access_list, null)
      rp_address  = try(rp_address.rp_address, null)
      override    = try(rp_address.override, null)
      bidir       = try(rp_address.bidir, null)
    }]
    rp_candidates = try(length(vrf.rp_candidates) == 0, true) ? null : [for rp_candidate in vrf.rp_candidates : {
      interface  = try(rp_candidate.interface, null)
      group_list = try(rp_candidate.group_list, null)
      interval   = try(rp_candidate.interval, null)
      priority   = try(rp_candidate.priority, null)
      bidir      = try(rp_candidate.bidir, null)
    }]
  }]

  depends_on = [
    iosxe_system.system,
    iosxe_interface_pim.loopback_pim,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}
