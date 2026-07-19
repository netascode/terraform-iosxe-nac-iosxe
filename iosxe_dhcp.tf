resource "iosxe_dhcp" "dhcp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].dhcp, null) != null || try(length(local.device_config[device.name].dhcp_pools) > 0, false) || try(length(local.device_config[device.name].ipv6_dhcp_pools) > 0, false) }
  device   = each.value.name

  compatibility_suboption_link_selection                = try(local.device_config[each.value.name].dhcp.compatibility_suboption_link_selection, null)
  compatibility_suboption_server_override               = try(local.device_config[each.value.name].dhcp.compatibility_suboption_server_override, null)
  relay_information_trust_all                           = try(local.device_config[each.value.name].dhcp.relay_information_trust_all, null)
  relay_information_option_default                      = try(local.device_config[each.value.name].dhcp.relay_information_option_default, null)
  relay_information_option_vpn                          = try(local.device_config[each.value.name].dhcp.relay_information_option_vpn, null)
  relay_bootp_ignore                                    = try(local.device_config[each.value.name].dhcp.relay_bootp_ignore, null)
  snooping                                              = try(local.device_config[each.value.name].dhcp.snooping, null)
  snooping_information_option                           = try(local.device_config[each.value.name].dhcp.snooping_information_option, null)
  snooping_information_option_allow_untrusted           = try(local.device_config[each.value.name].dhcp.snooping_information_option_allow_untrusted, null)
  snooping_information_option_format_remote_id_hostname = try(local.device_config[each.value.name].dhcp.snooping_information_option_format_remote_id_hostname, null)
  snooping_information_option_format_remote_id_string   = try(local.device_config[each.value.name].dhcp.snooping_information_option_format_remote_id_string, null)
  snooping_vlans = try(length(provider::utils::normalize_vlans(
    try(local.device_config[each.value.name].dhcp.snooping_vlans, null),
    "list"
    )) == 0, true) ? null : [for vlan_id in provider::utils::normalize_vlans(
    try(local.device_config[each.value.name].dhcp.snooping_vlans, null),
    "list"
    ) : {
    vlan_id = vlan_id
  }]

  pools = try(length(local.device_config[each.value.name].dhcp_pools) == 0, true) ? null : [
    for pool in local.device_config[each.value.name].dhcp_pools : {
      name                      = pool.name
      vrf                       = try(pool.vrf, null)
      domain_name               = try(pool.domain_name, null)
      bootfile                  = try(pool.bootfile, null)
      client_name               = try(pool.client_name, null)
      network_number            = try(pool.network_number, null)
      network_mask              = try(pool.network_mask, null)
      host_number               = try(pool.host_number, null)
      host_mask                 = try(pool.host_mask, null)
      default_routers           = try(pool.default_routers, null)
      dns_servers               = try(pool.dns_servers, null)
      next_servers              = try(pool.next_servers, null)
      lease_days                = try(pool.lease_days, null)
      lease_hours               = try(pool.lease_hours, null)
      lease_minutes             = try(pool.lease_minutes, null)
      lease_infinite            = try(pool.lease_infinite, null)
      utilization_mark_high     = try(pool.utilization_mark_high, null)
      utilization_mark_high_log = try(pool.utilization_mark_high_log, null)
      utilization_mark_low      = try(pool.utilization_mark_low, null)
      utilization_mark_low_log  = try(pool.utilization_mark_low_log, null)
      subnet_prefix_length      = try(pool.subnet_prefix_length, null)
      secondary_networks = try(length(pool.secondary_networks) == 0, true) ? null : [
        for sn in pool.secondary_networks : {
          number    = try(sn.number, null)
          mask      = try(sn.mask, null)
          secondary = try(sn.secondary, null)
        }
      ]
      options = try(length(pool.options) == 0, true) ? null : [
        for opt in pool.options : {
          option_code = try(opt.option_code, null)
          ascii       = try(opt.ascii, null)
          hex         = try(opt.hex, null)
          ip          = try(opt.ip, null)
          ip_legacy   = try(opt.ip_legacy, null)
        }
      ]
    }
  ]

  ipv6_pools = try(length(local.device_config[each.value.name].ipv6_dhcp_pools) == 0, true) ? null : [
    for pool in local.device_config[each.value.name].ipv6_dhcp_pools : {
      name = pool.name
      vrf  = try(pool.vrf, null)
      address_prefixes = try(length(pool.address_prefixes) == 0, true) ? null : [for p in pool.address_prefixes : {
        address            = p.address
        valid_lifetime     = try(p.valid_lifetime, null)
        preferred_lifetime = try(p.preferred_lifetime, null)
      }]
      prefix_delegation_pool_name               = try(pool.prefix_delegation_pool_name, null)
      prefix_delegation_pool_valid_lifetime     = try(pool.prefix_delegation_pool_valid_lifetime, null)
      prefix_delegation_pool_preferred_lifetime = try(pool.prefix_delegation_pool_preferred_lifetime, null)
      prefix_delegation_prefixes = try(length(pool.prefix_delegation_prefixes) == 0, true) ? null : [for p in pool.prefix_delegation_prefixes : {
        prefix             = p.prefix
        hex_string         = try(p.hex_string, null)
        iaid               = try(p.iaid, null)
        valid_lifetime     = try(p.valid_lifetime, null)
        preferred_lifetime = try(p.preferred_lifetime, null)
      }]
      dns_servers    = try(pool.dns_servers, null)
      domain_names   = try(pool.domain_names, null)
      bootfile_url   = try(pool.bootfile_url, null)
      sntp_addresses = try(pool.sntp_addresses, null)
      link_addresses = try(length(pool.link_addresses) == 0, true) ? null : [for l in pool.link_addresses : {
        address = l.address
      }]
      option_include_all = try(pool.option_include_all, null)
      vendor_specifics = try(length(pool.vendor_specifics) == 0, true) ? null : [for v in pool.vendor_specifics : {
        enterprise_id = v.enterprise_id
        suboptions = try(length(v.suboptions) == 0, true) ? null : [for s in v.suboptions : {
          number  = s.number
          address = try(s.address, null)
          ascii   = try(s.ascii, null)
          hex     = try(s.hex, null)
        }]
      }]
      import_dns_server            = try(pool.import_dns_server, null)
      import_domain_name           = try(pool.import_domain_name, null)
      information_refresh_days     = try(pool.information_refresh_days, null)
      information_refresh_hours    = try(pool.information_refresh_hours, null)
      information_refresh_minutes  = try(pool.information_refresh_minutes, null)
      information_refresh_infinite = try(pool.information_refresh_infinite, null)
    }
  ]

  depends_on = [
    iosxe_vlan.vlan,
    iosxe_vrf.vrf,
    iosxe_ipv6_local_pool.ipv6_local_pool
  ]
}
