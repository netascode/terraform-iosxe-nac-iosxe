locals {
  interfaces_vrrp_v2 = flatten([
    for device in local.devices : concat(
      [
        for int in try(local.device_config[device.name].interfaces.ethernets, []) : [
          for vrrp in try(int.vrrp_v2, []) : {
            key                       = format("%s/%s%s/vrrp_v2/%s", device.name, try(int.type, "GigabitEthernet"), trimprefix(int.id, "$string "), vrrp.group_id)
            device                    = device.name
            type                      = try(int.type, "GigabitEthernet")
            name                      = trimprefix(int.id, "$string ")
            managed                   = try(int.managed, true)
            group_id                  = vrrp.group_id
            ip_primary_address        = try(vrrp.ip_primary_address, null)
            ip_secondary_addresses    = try(length(vrrp.ip_secondary_addresses) == 0, true) ? null : [for addr in vrrp.ip_secondary_addresses : { address = addr }]
            priority                  = try(vrrp.priority, null)
            preempt                   = try(vrrp.preempt, null)
            preempt_delay_minimum     = try(vrrp.preempt_delay_minimum, null)
            timers_advertise_interval = try(vrrp.timers_advertise_interval, null)
            authentication_text       = try(vrrp.authentication_text, null)
            description               = try(vrrp.description, null)
            tracks                    = try(length(vrrp.tracks) == 0, true) ? null : [for t in vrrp.tracks : { object_id = t.object_id, decrement = try(t.decrement, null) }]
            shutdown                  = try(vrrp.shutdown, null)
          }
        ]
      ],
      [
        for int in try(local.device_config[device.name].interfaces.vlans, []) : [
          for vrrp in try(int.vrrp_v2, []) : {
            key                       = format("%s/Vlan%s/vrrp_v2/%s", device.name, int.id, vrrp.group_id)
            device                    = device.name
            type                      = "Vlan"
            name                      = tostring(int.id)
            managed                   = true
            group_id                  = vrrp.group_id
            ip_primary_address        = try(vrrp.ip_primary_address, null)
            ip_secondary_addresses    = try(length(vrrp.ip_secondary_addresses) == 0, true) ? null : [for addr in vrrp.ip_secondary_addresses : { address = addr }]
            priority                  = try(vrrp.priority, null)
            preempt                   = try(vrrp.preempt, null)
            preempt_delay_minimum     = try(vrrp.preempt_delay_minimum, null)
            timers_advertise_interval = try(vrrp.timers_advertise_interval, null)
            authentication_text       = try(vrrp.authentication_text, null)
            description               = try(vrrp.description, null)
            tracks                    = try(length(vrrp.tracks) == 0, true) ? null : [for t in vrrp.tracks : { object_id = t.object_id, decrement = try(t.decrement, null) }]
            shutdown                  = try(vrrp.shutdown, null)
          }
        ]
      ],
      [
        for int in try(local.device_config[device.name].interfaces.port_channels, []) : [
          for vrrp in try(int.vrrp_v2, []) : {
            key                       = format("%s/Port-channel%s/vrrp_v2/%s", device.name, int.id, vrrp.group_id)
            device                    = device.name
            type                      = "Port-channel"
            name                      = tostring(int.id)
            managed                   = true
            group_id                  = vrrp.group_id
            ip_primary_address        = try(vrrp.ip_primary_address, null)
            ip_secondary_addresses    = try(length(vrrp.ip_secondary_addresses) == 0, true) ? null : [for addr in vrrp.ip_secondary_addresses : { address = addr }]
            priority                  = try(vrrp.priority, null)
            preempt                   = try(vrrp.preempt, null)
            preempt_delay_minimum     = try(vrrp.preempt_delay_minimum, null)
            timers_advertise_interval = try(vrrp.timers_advertise_interval, null)
            authentication_text       = try(vrrp.authentication_text, null)
            description               = try(vrrp.description, null)
            tracks                    = try(length(vrrp.tracks) == 0, true) ? null : [for t in vrrp.tracks : { object_id = t.object_id, decrement = try(t.decrement, null) }]
            shutdown                  = try(vrrp.shutdown, null)
          }
        ]
      ]
    )
  ])
}

resource "iosxe_interface_vrrp_v2" "vrrp_v2" {
  for_each = { for v in local.interfaces_vrrp_v2 : v.key => v if v.managed }

  device                    = each.value.device
  type                      = each.value.type
  name                      = each.value.name
  group_id                  = each.value.group_id
  ip_primary_address        = each.value.ip_primary_address
  ip_secondary_addresses    = each.value.ip_secondary_addresses
  priority                  = each.value.priority
  preempt                   = each.value.preempt
  preempt_delay_minimum     = each.value.preempt_delay_minimum
  timers_advertise_interval = each.value.timers_advertise_interval
  authentication_text       = each.value.authentication_text
  description               = each.value.description
  tracks                    = each.value.tracks
  shutdown                  = each.value.shutdown

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel
  ]
}

resource "iosxe_interface_vrrp_v2" "vrrp_v2_unmanaged" {
  for_each = { for v in local.interfaces_vrrp_v2 : v.key => v if !v.managed }

  device                    = each.value.device
  type                      = each.value.type
  name                      = each.value.name
  group_id                  = each.value.group_id
  ip_primary_address        = each.value.ip_primary_address
  ip_secondary_addresses    = each.value.ip_secondary_addresses
  priority                  = each.value.priority
  preempt                   = each.value.preempt
  preempt_delay_minimum     = each.value.preempt_delay_minimum
  timers_advertise_interval = each.value.timers_advertise_interval
  authentication_text       = each.value.authentication_text
  description               = each.value.description
  tracks                    = each.value.tracks
  shutdown                  = each.value.shutdown

  depends_on = [
    iosxe_interface_ethernet.ethernet_unmanaged
  ]

  lifecycle {
    ignore_changes = all
  }
}
