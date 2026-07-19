locals {
  ipv6_local_pools = flatten([
    for device in local.devices : [
      for pool in try(local.device_config[device.name].ipv6_local_pools, []) : {
        key    = format("%s/%s", device.name, pool.name)
        device = device.name

        name          = pool.name
        start_address = try(pool.start_address, null)
        prefix_length = try(pool.prefix_length, null)
        group         = try(pool.group, null)
      }
    ]
  ])
}

resource "iosxe_ipv6_local_pool" "ipv6_local_pool" {
  for_each = { for e in local.ipv6_local_pools : e.key => e }
  device   = each.value.device

  name          = each.value.name
  start_address = each.value.start_address
  prefix_length = each.value.prefix_length
  group         = each.value.group

  depends_on = [
    iosxe_vrf.vrf
  ]
}
