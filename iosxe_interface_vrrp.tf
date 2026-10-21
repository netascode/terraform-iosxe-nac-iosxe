locals {
  interfaces_vrrp = flatten([
    for device in local.devices : concat(
      [
        for int in try(local.device_config[device.name].interfaces.ethernets, []) : [
          for vrrp in try(int.vrrp_groups, []) : {
            key                        = format("%s/%s%s/vrrp/%s", device.name, try(int.type, "GigabitEthernet"), trimprefix(int.id, "$string "), vrrp.group_id)
            device                     = device.name
            type                       = try(int.type, "GigabitEthernet")
            name                       = trimprefix(int.id, "$string ")
            managed                    = try(int.managed, true)
            group_id                   = vrrp.group_id
            ipv4_primary_address       = try(vrrp.ipv4.primary_address, null)
            ipv4_secondary_addresses   = try(length(vrrp.ipv4.secondary_addresses) == 0, true) ? null : [for addr in vrrp.ipv4.secondary_addresses : { address = addr }]
            ipv4_priority              = try(vrrp.ipv4.priority, null)
            ipv4_preempt_delay_minimum = try(vrrp.ipv4.preempt_delay_minimum, null)
            ipv4_timers_advertise      = try(vrrp.ipv4.timers_advertise, null)
            ipv4_description           = try(vrrp.ipv4.description, null)
            ipv4_tracks = try(length(vrrp.ipv4.tracks) == 0, true) ? null : [for track in vrrp.ipv4.tracks : {
              object_id = track.object_id
              decrement = try(track.decrement, null)
              shutdown  = try(track.shutdown, null)
            }]
            ipv4_shutdown              = try(vrrp.ipv4.shutdown, null)
            ipv6_primary_address       = try(vrrp.ipv6.primary_address, null)
            ipv6_prefixes              = try(length(vrrp.ipv6.prefixes) == 0, true) ? null : [for prefix in vrrp.ipv6.prefixes : { prefix = prefix }]
            ipv6_priority              = try(vrrp.ipv6.priority, null)
            ipv6_preempt_delay_minimum = try(vrrp.ipv6.preempt_delay_minimum, null)
            ipv6_timers_advertise      = try(vrrp.ipv6.timers_advertise, null)
            ipv6_description           = try(vrrp.ipv6.description, null)
            ipv6_tracks = try(length(vrrp.ipv6.tracks) == 0, true) ? null : [for track in vrrp.ipv6.tracks : {
              object_id = track.object_id
              decrement = try(track.decrement, null)
              shutdown  = try(track.shutdown, null)
            }]
            ipv6_shutdown = try(vrrp.ipv6.shutdown, null)
          }
        ]
      ],
      [
        for int in try(local.device_config[device.name].interfaces.vlans, []) : [
          for vrrp in try(int.vrrp_groups, []) : {
            key                        = format("%s/Vlan%s/vrrp/%s", device.name, int.id, vrrp.group_id)
            device                     = device.name
            type                       = "Vlan"
            name                       = tostring(int.id)
            managed                    = true
            group_id                   = vrrp.group_id
            ipv4_primary_address       = try(vrrp.ipv4.primary_address, null)
            ipv4_secondary_addresses   = try(length(vrrp.ipv4.secondary_addresses) == 0, true) ? null : [for addr in vrrp.ipv4.secondary_addresses : { address = addr }]
            ipv4_priority              = try(vrrp.ipv4.priority, null)
            ipv4_preempt_delay_minimum = try(vrrp.ipv4.preempt_delay_minimum, null)
            ipv4_timers_advertise      = try(vrrp.ipv4.timers_advertise, null)
            ipv4_description           = try(vrrp.ipv4.description, null)
            ipv4_tracks = try(length(vrrp.ipv4.tracks) == 0, true) ? null : [for track in vrrp.ipv4.tracks : {
              object_id = track.object_id
              decrement = try(track.decrement, null)
              shutdown  = try(track.shutdown, null)
            }]
            ipv4_shutdown              = try(vrrp.ipv4.shutdown, null)
            ipv6_primary_address       = try(vrrp.ipv6.primary_address, null)
            ipv6_prefixes              = try(length(vrrp.ipv6.prefixes) == 0, true) ? null : [for prefix in vrrp.ipv6.prefixes : { prefix = prefix }]
            ipv6_priority              = try(vrrp.ipv6.priority, null)
            ipv6_preempt_delay_minimum = try(vrrp.ipv6.preempt_delay_minimum, null)
            ipv6_timers_advertise      = try(vrrp.ipv6.timers_advertise, null)
            ipv6_description           = try(vrrp.ipv6.description, null)
            ipv6_tracks = try(length(vrrp.ipv6.tracks) == 0, true) ? null : [for track in vrrp.ipv6.tracks : {
              object_id = track.object_id
              decrement = try(track.decrement, null)
              shutdown  = try(track.shutdown, null)
            }]
            ipv6_shutdown = try(vrrp.ipv6.shutdown, null)
          }
        ]
      ],
      [
        for int in try(local.device_config[device.name].interfaces.port_channels, []) : [
          for vrrp in try(int.vrrp_groups, []) : {
            key                        = format("%s/Port-channel%s/vrrp/%s", device.name, trimprefix(tostring(int.id), "$string "), vrrp.group_id)
            device                     = device.name
            type                       = "Port-channel"
            name                       = trimprefix(tostring(int.id), "$string ")
            managed                    = true
            group_id                   = vrrp.group_id
            ipv4_primary_address       = try(vrrp.ipv4.primary_address, null)
            ipv4_secondary_addresses   = try(length(vrrp.ipv4.secondary_addresses) == 0, true) ? null : [for addr in vrrp.ipv4.secondary_addresses : { address = addr }]
            ipv4_priority              = try(vrrp.ipv4.priority, null)
            ipv4_preempt_delay_minimum = try(vrrp.ipv4.preempt_delay_minimum, null)
            ipv4_timers_advertise      = try(vrrp.ipv4.timers_advertise, null)
            ipv4_description           = try(vrrp.ipv4.description, null)
            ipv4_tracks = try(length(vrrp.ipv4.tracks) == 0, true) ? null : [for track in vrrp.ipv4.tracks : {
              object_id = track.object_id
              decrement = try(track.decrement, null)
              shutdown  = try(track.shutdown, null)
            }]
            ipv4_shutdown              = try(vrrp.ipv4.shutdown, null)
            ipv6_primary_address       = try(vrrp.ipv6.primary_address, null)
            ipv6_prefixes              = try(length(vrrp.ipv6.prefixes) == 0, true) ? null : [for prefix in vrrp.ipv6.prefixes : { prefix = prefix }]
            ipv6_priority              = try(vrrp.ipv6.priority, null)
            ipv6_preempt_delay_minimum = try(vrrp.ipv6.preempt_delay_minimum, null)
            ipv6_timers_advertise      = try(vrrp.ipv6.timers_advertise, null)
            ipv6_description           = try(vrrp.ipv6.description, null)
            ipv6_tracks = try(length(vrrp.ipv6.tracks) == 0, true) ? null : [for track in vrrp.ipv6.tracks : {
              object_id = track.object_id
              decrement = try(track.decrement, null)
              shutdown  = try(track.shutdown, null)
            }]
            ipv6_shutdown = try(vrrp.ipv6.shutdown, null)
          }
        ]
      ],
      [
        for int in try(local.device_config[device.name].interfaces.port_channels, []) : [
          for sub in try(int.subinterfaces, []) : [
            for vrrp in try(sub.vrrp_groups, []) : {
              key                        = format("%s/Port-channel%s/vrrp/%s", device.name, trimprefix(sub.id, "$string "), vrrp.group_id)
              device                     = device.name
              type                       = "Port-channel-subinterface/Port-channel"
              name                       = trimprefix(sub.id, "$string ")
              managed                    = true
              group_id                   = vrrp.group_id
              ipv4_primary_address       = try(vrrp.ipv4.primary_address, null)
              ipv4_secondary_addresses   = try(length(vrrp.ipv4.secondary_addresses) == 0, true) ? null : [for addr in vrrp.ipv4.secondary_addresses : { address = addr }]
              ipv4_priority              = try(vrrp.ipv4.priority, null)
              ipv4_preempt_delay_minimum = try(vrrp.ipv4.preempt_delay_minimum, null)
              ipv4_timers_advertise      = try(vrrp.ipv4.timers_advertise, null)
              ipv4_description           = try(vrrp.ipv4.description, null)
              ipv4_tracks = try(length(vrrp.ipv4.tracks) == 0, true) ? null : [for track in vrrp.ipv4.tracks : {
                object_id = track.object_id
                decrement = try(track.decrement, null)
                shutdown  = try(track.shutdown, null)
              }]
              ipv4_shutdown              = try(vrrp.ipv4.shutdown, null)
              ipv6_primary_address       = try(vrrp.ipv6.primary_address, null)
              ipv6_prefixes              = try(length(vrrp.ipv6.prefixes) == 0, true) ? null : [for prefix in vrrp.ipv6.prefixes : { prefix = prefix }]
              ipv6_priority              = try(vrrp.ipv6.priority, null)
              ipv6_preempt_delay_minimum = try(vrrp.ipv6.preempt_delay_minimum, null)
              ipv6_timers_advertise      = try(vrrp.ipv6.timers_advertise, null)
              ipv6_description           = try(vrrp.ipv6.description, null)
              ipv6_tracks = try(length(vrrp.ipv6.tracks) == 0, true) ? null : [for track in vrrp.ipv6.tracks : {
                object_id = track.object_id
                decrement = try(track.decrement, null)
                shutdown  = try(track.shutdown, null)
              }]
              ipv6_shutdown = try(vrrp.ipv6.shutdown, null)
            }
          ]
        ]
      ]
    )
  ])
}

resource "iosxe_interface_vrrp" "vrrp" {
  for_each = { for v in local.interfaces_vrrp : v.key => v if v.managed }

  device                     = each.value.device
  type                       = each.value.type
  name                       = each.value.name
  group_id                   = each.value.group_id
  ipv4_primary_address       = each.value.ipv4_primary_address
  ipv4_secondary_addresses   = each.value.ipv4_secondary_addresses
  ipv4_priority              = each.value.ipv4_priority
  ipv4_preempt_delay_minimum = each.value.ipv4_preempt_delay_minimum
  ipv4_timers_advertise      = each.value.ipv4_timers_advertise
  ipv4_description           = each.value.ipv4_description
  ipv4_tracks                = each.value.ipv4_tracks
  ipv4_shutdown              = each.value.ipv4_shutdown
  ipv6_primary_address       = each.value.ipv6_primary_address
  ipv6_prefixes              = each.value.ipv6_prefixes
  ipv6_priority              = each.value.ipv6_priority
  ipv6_preempt_delay_minimum = each.value.ipv6_preempt_delay_minimum
  ipv6_timers_advertise      = each.value.ipv6_timers_advertise
  ipv6_description           = each.value.ipv6_description
  ipv6_tracks                = each.value.ipv6_tracks
  ipv6_shutdown              = each.value.ipv6_shutdown

  depends_on = [
    iosxe_fhrp.fhrp,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}

resource "iosxe_interface_vrrp" "vrrp_unmanaged" {
  for_each = { for v in local.interfaces_vrrp : v.key => v if !v.managed }

  device                     = each.value.device
  type                       = each.value.type
  name                       = each.value.name
  group_id                   = each.value.group_id
  ipv4_primary_address       = each.value.ipv4_primary_address
  ipv4_secondary_addresses   = each.value.ipv4_secondary_addresses
  ipv4_priority              = each.value.ipv4_priority
  ipv4_preempt_delay_minimum = each.value.ipv4_preempt_delay_minimum
  ipv4_timers_advertise      = each.value.ipv4_timers_advertise
  ipv4_description           = each.value.ipv4_description
  ipv4_tracks                = each.value.ipv4_tracks
  ipv4_shutdown              = each.value.ipv4_shutdown
  ipv6_primary_address       = each.value.ipv6_primary_address
  ipv6_prefixes              = each.value.ipv6_prefixes
  ipv6_priority              = each.value.ipv6_priority
  ipv6_preempt_delay_minimum = each.value.ipv6_preempt_delay_minimum
  ipv6_timers_advertise      = each.value.ipv6_timers_advertise
  ipv6_description           = each.value.ipv6_description
  ipv6_tracks                = each.value.ipv6_tracks
  ipv6_shutdown              = each.value.ipv6_shutdown

  depends_on = [
    iosxe_fhrp.fhrp,
    iosxe_interface_ethernet.ethernet_unmanaged
  ]

  lifecycle {
    ignore_changes = all
  }
}
