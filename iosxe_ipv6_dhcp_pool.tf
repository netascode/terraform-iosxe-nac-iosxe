locals {
  ipv6_dhcp_pools = flatten([
    for device in local.devices : [
      for pool in try(local.device_config[device.name].ipv6_dhcp_pools, []) : {
        key    = format("%s/%s", device.name, pool.name)
        device = device.name

        name = pool.name
        vrf  = try(pool.vrf, local.defaults.iosxe.configuration.ipv6_dhcp_pools.vrf, null)

        address_prefixes = try(length(pool.address_prefixes) == 0, true) ? null : [for p in pool.address_prefixes : {
          address            = p.address
          valid_lifetime     = try(p.valid_lifetime, local.defaults.iosxe.configuration.ipv6_dhcp_pools.address_prefixes.valid_lifetime, null)
          preferred_lifetime = try(p.preferred_lifetime, local.defaults.iosxe.configuration.ipv6_dhcp_pools.address_prefixes.preferred_lifetime, null)
        }]

        prefix_delegation_pool_name               = try(pool.prefix_delegation_pool_name, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_pool_name, null)
        prefix_delegation_pool_valid_lifetime     = try(pool.prefix_delegation_pool_valid_lifetime, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_pool_valid_lifetime, null)
        prefix_delegation_pool_preferred_lifetime = try(pool.prefix_delegation_pool_preferred_lifetime, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_pool_preferred_lifetime, null)

        prefix_delegation_prefixes = try(length(pool.prefix_delegation_prefixes) == 0, true) ? null : [for p in pool.prefix_delegation_prefixes : {
          prefix             = p.prefix
          hex_string         = try(p.hex_string, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_prefixes.hex_string, null)
          iaid               = try(p.iaid, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_prefixes.iaid, null)
          valid_lifetime     = try(p.valid_lifetime, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_prefixes.valid_lifetime, null)
          preferred_lifetime = try(p.preferred_lifetime, local.defaults.iosxe.configuration.ipv6_dhcp_pools.prefix_delegation_prefixes.preferred_lifetime, null)
        }]

        dns_servers    = try(pool.dns_servers, local.defaults.iosxe.configuration.ipv6_dhcp_pools.dns_servers, null)
        domain_names   = try(pool.domain_names, local.defaults.iosxe.configuration.ipv6_dhcp_pools.domain_names, null)
        bootfile_url   = try(pool.bootfile_url, local.defaults.iosxe.configuration.ipv6_dhcp_pools.bootfile_url, null)
        sntp_addresses = try(pool.sntp_addresses, local.defaults.iosxe.configuration.ipv6_dhcp_pools.sntp_addresses, null)

        link_addresses = try(length(pool.link_addresses) == 0, true) ? null : [for l in pool.link_addresses : {
          address = l.address
        }]

        option_include_all = try(pool.option_include_all, local.defaults.iosxe.configuration.ipv6_dhcp_pools.option_include_all, null)

        vendor_specifics = try(length(pool.vendor_specifics) == 0, true) ? null : [for v in pool.vendor_specifics : {
          enterprise_id = v.enterprise_id
          suboptions = try(length(v.suboptions) == 0, true) ? null : [for s in v.suboptions : {
            number  = s.number
            address = try(s.address, null)
            ascii   = try(s.ascii, null)
            hex     = try(s.hex, null)
          }]
        }]

        import_dns_server  = try(pool.import_dns_server, local.defaults.iosxe.configuration.ipv6_dhcp_pools.import_dns_server, null)
        import_domain_name = try(pool.import_domain_name, local.defaults.iosxe.configuration.ipv6_dhcp_pools.import_domain_name, null)

        information_refresh_days     = try(pool.information_refresh_days, local.defaults.iosxe.configuration.ipv6_dhcp_pools.information_refresh_days, null)
        information_refresh_hours    = try(pool.information_refresh_hours, local.defaults.iosxe.configuration.ipv6_dhcp_pools.information_refresh_hours, null)
        information_refresh_minutes  = try(pool.information_refresh_minutes, local.defaults.iosxe.configuration.ipv6_dhcp_pools.information_refresh_minutes, null)
        information_refresh_infinite = try(pool.information_refresh_infinite, local.defaults.iosxe.configuration.ipv6_dhcp_pools.information_refresh_infinite, null)
      }
    ]
  ])
}

resource "iosxe_ipv6_dhcp_pool" "ipv6_dhcp_pool" {
  for_each = { for e in local.ipv6_dhcp_pools : e.key => e }
  device   = each.value.device

  name = each.value.name
  vrf  = each.value.vrf

  address_prefixes = each.value.address_prefixes

  prefix_delegation_pool_name               = each.value.prefix_delegation_pool_name
  prefix_delegation_pool_valid_lifetime     = each.value.prefix_delegation_pool_valid_lifetime
  prefix_delegation_pool_preferred_lifetime = each.value.prefix_delegation_pool_preferred_lifetime
  prefix_delegation_prefixes                = each.value.prefix_delegation_prefixes

  dns_servers    = each.value.dns_servers
  domain_names   = each.value.domain_names
  bootfile_url   = each.value.bootfile_url
  sntp_addresses = each.value.sntp_addresses

  link_addresses     = each.value.link_addresses
  option_include_all = each.value.option_include_all
  vendor_specifics   = each.value.vendor_specifics

  import_dns_server  = each.value.import_dns_server
  import_domain_name = each.value.import_domain_name

  information_refresh_days     = each.value.information_refresh_days
  information_refresh_hours    = each.value.information_refresh_hours
  information_refresh_minutes  = each.value.information_refresh_minutes
  information_refresh_infinite = each.value.information_refresh_infinite

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_ipv6_local_pool.ipv6_local_pool
  ]
}
