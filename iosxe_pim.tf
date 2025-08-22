resource "iosxe_pim" "pim" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].pim, null) != null }
  device   = each.value.name

  autorp                            = try(local.device_config[each.value.name].pim.autorp, local.defaults.iosxe.configuration.pim.autorp, null)
  autorp_listener                   = try(local.device_config[each.value.name].pim.autorp_listener, local.defaults.iosxe.configuration.pim.autorp_listener, null)
  bsr_candidate_loopback            = try(local.device_config[each.value.name].pim.bsr_candidate_interface_type, local.defaults.iosxe.configuration.pim.bsr_candidate_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].pim.bsr_candidate_interface_id, local.defaults.iosxe.configuration.pim.bsr_candidate_interface_id, null) : null
  bsr_candidate_mask                = try(local.device_config[each.value.name].pim.bsr_candidate_mask, local.defaults.iosxe.configuration.pim.bsr_candidate_mask, null)
  bsr_candidate_priority            = try(local.device_config[each.value.name].pim.bsr_candidate_priority, local.defaults.iosxe.configuration.pim.bsr_candidate_priority, null)
  bsr_candidate_accept_rp_candidate = try(local.device_config[each.value.name].pim.bsr_candidate_accept_rp_candidate, local.defaults.iosxe.configuration.pim.bsr_candidate_accept_rp_candidate, null)
  ssm_range                         = try(local.device_config[each.value.name].pim.ssm_range, local.defaults.iosxe.configuration.pim.ssm_range, null)
  ssm_default                       = try(local.device_config[each.value.name].pim.ssm_default, local.defaults.iosxe.configuration.pim.ssm_default, null)
  rp_address                        = try(local.device_config[each.value.name].pim.rp_address, local.defaults.iosxe.configuration.pim.rp_address, null)
  rp_address_override               = try(local.device_config[each.value.name].pim.rp_address_override, local.defaults.iosxe.configuration.pim.rp_address_override, null)
  rp_address_bidir                  = try(local.device_config[each.value.name].pim.rp_address_bidir, local.defaults.iosxe.configuration.pim.rp_address_bidir, null)

  # Lists
  rp_addresses = try(length(local.device_config[each.value.name].pim.rp_addresses) == 0, true) ? null : [for rp_address in local.device_config[each.value.name].pim.rp_addresses : {
    access_list = try(rp_address.access_list, local.defaults.iosxe.configuration.pim.rp_addresses.access_list, null)
    rp_address  = try(rp_address.rp_address, local.defaults.iosxe.configuration.pim.rp_addresses.rp_address, null)
    override    = try(rp_address.override, local.defaults.iosxe.configuration.pim.rp_addresses.override, null)
    bidir       = try(rp_address.bidir, local.defaults.iosxe.configuration.pim.rp_addresses.bidir, null)
    }
  ]

  rp_candidates = try(length(local.device_config[each.value.name].pim.rp_candidates) == 0, true) ? null : [for rp_candidate in local.device_config[each.value.name].pim.rp_candidates : {
    interface  = try(rp_candidate.interface, local.defaults.iosxe.configuration.pim.rp_candidates.interface, null)
    group_list = try(rp_candidate.group_list, local.defaults.iosxe.configuration.pim.rp_candidates.group_list, null)
    interval   = try(rp_candidate.interval, local.defaults.iosxe.configuration.pim.rp_candidates.interval, null)
    priority   = try(rp_candidate.priority, local.defaults.iosxe.configuration.pim.rp_candidates.priority, null)
    bidir      = try(rp_candidate.bidir, local.defaults.iosxe.configuration.pim.rp_candidates.bidir, null)
    }
  ]
}

locals {
  pim_vrfs = flatten([
    for device in local.devices : [
      for vrf in try(local.device_config[device.name].pim.vrfs, []) : {
        key                               = format("%s/%s", device.name, vrf.vrf)
        device                            = device.name
        vrf                               = try(vrf.vrf, local.defaults.iosxe.configuration.pim.vrfs.vrf, null)
        autorp                            = try(vrf.autorp, local.defaults.iosxe.configuration.pim.vrfs.autorp, null)
        autorp_listener                   = try(vrf.autorp_listener, local.defaults.iosxe.configuration.pim.vrfs.autorp_listener, null)
        bsr_candidate_loopback            = try(vrf.bsr_candidate_interface_type, local.defaults.iosxe.configuration.pim.vrfs.bsr_candidate_interface_type, null) == "Loopback" ? try(vrf.bsr_candidate_interface_id, local.defaults.iosxe.configuration.pim.vrfs.bsr_candidate_interface_id, null) : null
        bsr_candidate_mask                = try(vrf.bsr_candidate_mask, local.defaults.iosxe.configuration.pim.vrfs.bsr_candidate_mask, null)
        bsr_candidate_priority            = try(vrf.bsr_candidate_priority, local.defaults.iosxe.configuration.pim.vrfs.bsr_candidate_priority, null)
        bsr_candidate_accept_rp_candidate = try(vrf.bsr_candidate_accept_rp_candidate, local.defaults.iosxe.configuration.pim.vrfs.bsr_candidate_accept_rp_candidate, null)
        cache_rpf_oif                     = try(vrf.cache_rpf_oif, local.defaults.iosxe.configuration.pim.vrfs.cache_rpf_oif, null)
        ssm_range                         = try(vrf.ssm_range, local.defaults.iosxe.configuration.pim.vrfs.ssm_range, null)
        ssm_default                       = try(vrf.ssm_default, local.defaults.iosxe.configuration.pim.vrfs.ssm_default, null)
        rp_address                        = try(vrf.rp_address, local.defaults.iosxe.configuration.pim.vrfs.rp_address, null)
        rp_address_override               = try(vrf.rp_address_override, local.defaults.iosxe.configuration.pim.vrfs.rp_address_override, null)
        rp_address_bidir                  = try(vrf.rp_address_bidir, local.defaults.iosxe.configuration.pim.vrfs.rp_address_bidir, null)
        rp_addresses = try(length(vrf.rp_addresses) == 0, true) ? null : [for rp_address in vrf.rp_addresses : {
          access_list = try(rp_address.access_list, local.defaults.iosxe.configuration.pim.vrfs.rp_addresses.access_list, null)
          rp_address  = try(rp_address.rp_address, local.defaults.iosxe.configuration.pim.vrfs.rp_addresses.rp_address, null)
          override    = try(rp_address.override, local.defaults.iosxe.configuration.pim.vrfs.rp_addresses.override, null)
          bidir       = try(rp_address.bidir, local.defaults.iosxe.configuration.pim.vrfs.rp_addresses.bidir, null)
        }]
        rp_candidates = try(length(vrf.rp_candidates) == 0, true) ? null : [for rp_candidate in vrf.rp_candidates : {
          interface  = try(rp_candidate.interface, local.defaults.iosxe.configuration.pim.vrfs.rp_candidates.interface, null)
          group_list = try(rp_candidate.group_list, local.defaults.iosxe.configuration.pim.vrfs.rp_candidates.group_list, null)
          interval   = try(rp_candidate.interval, local.defaults.iosxe.configuration.pim.vrfs.rp_candidates.interval, null)
          priority   = try(rp_candidate.priority, local.defaults.iosxe.configuration.pim.vrfs.rp_candidates.priority, null)
          bidir      = try(rp_candidate.bidir, local.defaults.iosxe.configuration.pim.vrfs.rp_candidates.bidir, null)
        }]
      }
    ]
  ])
}

resource "iosxe_pim_vrf" "pim_vrf" {
  for_each = { for e in local.pim_vrfs : e.key => e }
  device   = each.value.device

  vrf                               = each.value.vrf
  autorp                            = each.value.autorp
  autorp_listener                   = each.value.autorp_listener
  bsr_candidate_loopback            = each.value.bsr_candidate_loopback
  bsr_candidate_mask                = each.value.bsr_candidate_mask
  bsr_candidate_priority            = each.value.bsr_candidate_priority
  bsr_candidate_accept_rp_candidate = each.value.bsr_candidate_accept_rp_candidate
  cache_rpf_oif                     = each.value.cache_rpf_oif
  ssm_range                         = each.value.ssm_range
  ssm_default                       = each.value.ssm_default
  rp_address                        = each.value.rp_address
  rp_address_override               = each.value.rp_address_override
  rp_address_bidir                  = each.value.rp_address_bidir
  rp_addresses                      = each.value.rp_addresses
  rp_candidates                     = each.value.rp_candidates
}