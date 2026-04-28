locals {
  dhcp_pool_configurations = flatten([
    for device in local.devices : [
      for pool in try(local.device_config[device.name].dhcp_pools, []) : {
        key                       = format("%s/%s", device.name, pool.name)
        device                    = device.name
        name                      = pool.name
        vrf                       = try(pool.vrf, local.defaults.iosxe.configuration.dhcp_pools.vrf, null)
        domain_name               = try(pool.domain_name, local.defaults.iosxe.configuration.dhcp_pools.domain_name, null)
        bootfile                  = try(pool.bootfile, local.defaults.iosxe.configuration.dhcp_pools.bootfile, null)
        client_name               = try(pool.client_name, local.defaults.iosxe.configuration.dhcp_pools.client_name, null)
        network_number            = try(pool.network_number, local.defaults.iosxe.configuration.dhcp_pools.network_number, null)
        network_mask              = try(pool.network_mask, local.defaults.iosxe.configuration.dhcp_pools.network_mask, null)
        host_number               = try(pool.host_number, local.defaults.iosxe.configuration.dhcp_pools.host_number, null)
        host_mask                 = try(pool.host_mask, local.defaults.iosxe.configuration.dhcp_pools.host_mask, null)
        default_routers           = try(pool.default_routers, local.defaults.iosxe.configuration.dhcp_pools.default_routers, null)
        dns_servers               = try(pool.dns_servers, local.defaults.iosxe.configuration.dhcp_pools.dns_servers, null)
        next_servers              = try(pool.next_servers, local.defaults.iosxe.configuration.dhcp_pools.next_servers, null)
        lease_days                = try(pool.lease_days, local.defaults.iosxe.configuration.dhcp_pools.lease_days, null)
        lease_hours               = try(pool.lease_hours, local.defaults.iosxe.configuration.dhcp_pools.lease_hours, null)
        lease_minutes             = try(pool.lease_minutes, local.defaults.iosxe.configuration.dhcp_pools.lease_minutes, null)
        lease_infinite            = try(pool.lease_infinite, local.defaults.iosxe.configuration.dhcp_pools.lease_infinite, null)
        utilization_mark_high     = try(pool.utilization_mark_high, local.defaults.iosxe.configuration.dhcp_pools.utilization_mark_high, null)
        utilization_mark_high_log = try(pool.utilization_mark_high_log, local.defaults.iosxe.configuration.dhcp_pools.utilization_mark_high_log, null)
        utilization_mark_low      = try(pool.utilization_mark_low, local.defaults.iosxe.configuration.dhcp_pools.utilization_mark_low, null)
        utilization_mark_low_log  = try(pool.utilization_mark_low_log, local.defaults.iosxe.configuration.dhcp_pools.utilization_mark_low_log, null)
        subnet_prefix_length      = try(pool.subnet_prefix_length, local.defaults.iosxe.configuration.dhcp_pools.subnet_prefix_length, null)

        secondary_networks = try(length(pool.secondary_networks) == 0, true) ? null : [
          for sn in pool.secondary_networks : {
            number    = try(sn.number, local.defaults.iosxe.configuration.dhcp_pools.secondary_networks.number, null)
            mask      = try(sn.mask, local.defaults.iosxe.configuration.dhcp_pools.secondary_networks.mask, null)
            secondary = try(sn.secondary, local.defaults.iosxe.configuration.dhcp_pools.secondary_networks.secondary, null)
          }
        ]

        options = try(length(pool.options) == 0, true) ? null : [
          for opt in pool.options : {
            option_code = try(opt.option_code, local.defaults.iosxe.configuration.dhcp_pools.options.option_code, null)
            ascii       = try(opt.ascii, local.defaults.iosxe.configuration.dhcp_pools.options.ascii, null)
            hex         = try(opt.hex, local.defaults.iosxe.configuration.dhcp_pools.options.hex, null)
            ip          = try(opt.ip, local.defaults.iosxe.configuration.dhcp_pools.options.ip, null)
          }
        ]
      }
    ]
  ])
}

resource "iosxe_dhcp_pool" "dhcp_pool" {
  for_each = { for pool in local.dhcp_pool_configurations : pool.key => pool }

  device                    = each.value.device
  name                      = each.value.name
  vrf                       = each.value.vrf
  domain_name               = each.value.domain_name
  bootfile                  = each.value.bootfile
  client_name               = each.value.client_name
  network_number            = each.value.network_number
  network_mask              = each.value.network_mask
  secondary_networks        = each.value.secondary_networks
  host_number               = each.value.host_number
  host_mask                 = each.value.host_mask
  default_routers           = each.value.default_routers
  dns_servers               = each.value.dns_servers
  next_servers              = each.value.next_servers
  lease_days                = each.value.lease_days
  lease_hours               = each.value.lease_hours
  lease_minutes             = each.value.lease_minutes
  lease_infinite            = each.value.lease_infinite
  utilization_mark_high     = each.value.utilization_mark_high
  utilization_mark_high_log = each.value.utilization_mark_high_log
  utilization_mark_low      = each.value.utilization_mark_low
  utilization_mark_low_log  = each.value.utilization_mark_low_log
  subnet_prefix_length      = each.value.subnet_prefix_length
  options                   = each.value.options
}
