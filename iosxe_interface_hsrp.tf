locals {
  interfaces_hsrp = flatten([
    for device in local.devices : concat(
      [
        for int in try(local.device_config[device.name].interfaces.ethernets, []) : {
          key                           = format("%s/%s%s", device.name, try(int.type, "GigabitEthernet"), trimprefix(int.id, "$string "))
          device                        = device.name
          type                          = try(int.type, "GigabitEthernet")
          name                          = trimprefix(int.id, "$string ")
          managed                       = try(int.managed, true)
          version                       = try(int.hsrp_version, null)
          bfd                           = try(int.hsrp_bfd, null)
          delay_minimum                 = try(int.hsrp_delay_minimum, null)
          delay_reload                  = try(int.hsrp_delay_reload, null)
          mac_refresh                   = try(int.hsrp_mac_refresh, null)
          use_bia                       = try(int.hsrp_use_bia, null)
          use_bia_scope_interface       = try(int.hsrp_use_bia_scope_interface, null)
          redirect_timers_advertisement = try(int.hsrp_redirect_timers_advertisement, null)
          redirect_timers_holddown      = try(int.hsrp_redirect_timers_holddown, null)
          redirect_unknown              = try(int.hsrp_redirect_unknown, null)
          standby_list = try(length(int.hsrp) == 0, true) ? null : [for group in int.hsrp : {
            group_number                  = group.group_number
            ip                            = try(group.ip, null)
            ip_address                    = try(group.ip_address, null)
            ip_secondary_addresses        = try(length(group.ip_secondary_addresses) == 0, true) ? null : [for addr in group.ip_secondary_addresses : { address = addr, secondary = true }]
            ipv6_link_local               = try(group.ipv6_link_local, null)
            ipv6_addresses                = try(length(group.ipv6_addresses) == 0, true) ? null : [for addr in group.ipv6_addresses : { prefix = addr }]
            priority                      = try(group.priority, null)
            preempt                       = try(group.preempt, null)
            preempt_delay_minimum         = try(group.preempt_delay_minimum, null)
            preempt_delay_reload          = try(group.preempt_delay_reload, null)
            preempt_delay_sync            = try(group.preempt_delay_sync, null)
            timers_hello_interval_seconds = try(group.timers_hello_interval_seconds, null)
            timers_hello_interval_msec    = try(group.timers_hello_interval_msec, null)
            timers_hold_time_seconds      = try(group.timers_hold_time_seconds, null)
            timers_hold_time_msec         = try(group.timers_hold_time_msec, null)
            authentication_text           = try(group.authentication_text, null)
            authentication_word           = try(group.authentication_word, null)
            mac_address                   = try(group.mac_address, null)
            name                          = try(group.name, null)
            follow                        = try(group.follow, null)
            tracks                        = try(length(group.tracks) == 0, true) ? null : [for t in group.tracks : { number = t.number, decrement = try(t.decrement, null), shutdown = try(t.shutdown, null) }]
          }]
        } if try(length(int.hsrp), 0) > 0
      ],
      [
        for int in try(local.device_config[device.name].interfaces.vlans, []) : {
          key                           = format("%s/Vlan%s", device.name, int.id)
          device                        = device.name
          type                          = "Vlan"
          name                          = tostring(int.id)
          managed                       = true
          version                       = try(int.hsrp_version, null)
          bfd                           = try(int.hsrp_bfd, null)
          delay_minimum                 = try(int.hsrp_delay_minimum, null)
          delay_reload                  = try(int.hsrp_delay_reload, null)
          mac_refresh                   = try(int.hsrp_mac_refresh, null)
          use_bia                       = try(int.hsrp_use_bia, null)
          use_bia_scope_interface       = try(int.hsrp_use_bia_scope_interface, null)
          redirect_timers_advertisement = try(int.hsrp_redirect_timers_advertisement, null)
          redirect_timers_holddown      = try(int.hsrp_redirect_timers_holddown, null)
          redirect_unknown              = try(int.hsrp_redirect_unknown, null)
          standby_list = try(length(int.hsrp) == 0, true) ? null : [for group in int.hsrp : {
            group_number                  = group.group_number
            ip                            = try(group.ip, null)
            ip_address                    = try(group.ip_address, null)
            ip_secondary_addresses        = try(length(group.ip_secondary_addresses) == 0, true) ? null : [for addr in group.ip_secondary_addresses : { address = addr, secondary = true }]
            ipv6_link_local               = try(group.ipv6_link_local, null)
            ipv6_addresses                = try(length(group.ipv6_addresses) == 0, true) ? null : [for addr in group.ipv6_addresses : { prefix = addr }]
            priority                      = try(group.priority, null)
            preempt                       = try(group.preempt, null)
            preempt_delay_minimum         = try(group.preempt_delay_minimum, null)
            preempt_delay_reload          = try(group.preempt_delay_reload, null)
            preempt_delay_sync            = try(group.preempt_delay_sync, null)
            timers_hello_interval_seconds = try(group.timers_hello_interval_seconds, null)
            timers_hello_interval_msec    = try(group.timers_hello_interval_msec, null)
            timers_hold_time_seconds      = try(group.timers_hold_time_seconds, null)
            timers_hold_time_msec         = try(group.timers_hold_time_msec, null)
            authentication_text           = try(group.authentication_text, null)
            authentication_word           = try(group.authentication_word, null)
            mac_address                   = try(group.mac_address, null)
            name                          = try(group.name, null)
            follow                        = try(group.follow, null)
            tracks                        = try(length(group.tracks) == 0, true) ? null : [for t in group.tracks : { number = t.number, decrement = try(t.decrement, null), shutdown = try(t.shutdown, null) }]
          }]
        } if try(length(int.hsrp), 0) > 0
      ],
      [
        for int in try(local.device_config[device.name].interfaces.port_channels, []) : {
          key                           = format("%s/Port-channel%s", device.name, trimprefix(tostring(int.id), "$string "))
          device                        = device.name
          type                          = "Port-channel"
          name                          = trimprefix(tostring(int.id), "$string ")
          managed                       = true
          version                       = try(int.hsrp_version, null)
          bfd                           = try(int.hsrp_bfd, null)
          delay_minimum                 = try(int.hsrp_delay_minimum, null)
          delay_reload                  = try(int.hsrp_delay_reload, null)
          mac_refresh                   = try(int.hsrp_mac_refresh, null)
          use_bia                       = try(int.hsrp_use_bia, null)
          use_bia_scope_interface       = try(int.hsrp_use_bia_scope_interface, null)
          redirect_timers_advertisement = try(int.hsrp_redirect_timers_advertisement, null)
          redirect_timers_holddown      = try(int.hsrp_redirect_timers_holddown, null)
          redirect_unknown              = try(int.hsrp_redirect_unknown, null)
          standby_list = try(length(int.hsrp) == 0, true) ? null : [for group in int.hsrp : {
            group_number                  = group.group_number
            ip                            = try(group.ip, null)
            ip_address                    = try(group.ip_address, null)
            ip_secondary_addresses        = try(length(group.ip_secondary_addresses) == 0, true) ? null : [for addr in group.ip_secondary_addresses : { address = addr, secondary = true }]
            ipv6_link_local               = try(group.ipv6_link_local, null)
            ipv6_addresses                = try(length(group.ipv6_addresses) == 0, true) ? null : [for addr in group.ipv6_addresses : { prefix = addr }]
            priority                      = try(group.priority, null)
            preempt                       = try(group.preempt, null)
            preempt_delay_minimum         = try(group.preempt_delay_minimum, null)
            preempt_delay_reload          = try(group.preempt_delay_reload, null)
            preempt_delay_sync            = try(group.preempt_delay_sync, null)
            timers_hello_interval_seconds = try(group.timers_hello_interval_seconds, null)
            timers_hello_interval_msec    = try(group.timers_hello_interval_msec, null)
            timers_hold_time_seconds      = try(group.timers_hold_time_seconds, null)
            timers_hold_time_msec         = try(group.timers_hold_time_msec, null)
            authentication_text           = try(group.authentication_text, null)
            authentication_word           = try(group.authentication_word, null)
            mac_address                   = try(group.mac_address, null)
            name                          = try(group.name, null)
            follow                        = try(group.follow, null)
            tracks                        = try(length(group.tracks) == 0, true) ? null : [for t in group.tracks : { number = t.number, decrement = try(t.decrement, null), shutdown = try(t.shutdown, null) }]
          }]
        } if try(length(int.hsrp), 0) > 0
      ],
      [
        for int in try(local.device_config[device.name].interfaces.port_channels, []) : [
          for sub in try(int.subinterfaces, []) : {
            key                           = format("%s/Port-channel%s", device.name, trimprefix(sub.id, "$string "))
            device                        = device.name
            type                          = "Port-channel-subinterface/Port-channel"
            name                          = trimprefix(sub.id, "$string ")
            managed                       = true
            version                       = try(sub.hsrp_version, null)
            bfd                           = try(sub.hsrp_bfd, null)
            delay_minimum                 = try(sub.hsrp_delay_minimum, null)
            delay_reload                  = try(sub.hsrp_delay_reload, null)
            mac_refresh                   = try(sub.hsrp_mac_refresh, null)
            use_bia                       = try(sub.hsrp_use_bia, null)
            use_bia_scope_interface       = try(sub.hsrp_use_bia_scope_interface, null)
            redirect_timers_advertisement = try(sub.hsrp_redirect_timers_advertisement, null)
            redirect_timers_holddown      = try(sub.hsrp_redirect_timers_holddown, null)
            redirect_unknown              = try(sub.hsrp_redirect_unknown, null)
            standby_list = try(length(sub.hsrp) == 0, true) ? null : [for group in sub.hsrp : {
              group_number                  = group.group_number
              ip                            = try(group.ip, null)
              ip_address                    = try(group.ip_address, null)
              ip_secondary_addresses        = try(length(group.ip_secondary_addresses) == 0, true) ? null : [for addr in group.ip_secondary_addresses : { address = addr, secondary = true }]
              ipv6_link_local               = try(group.ipv6_link_local, null)
              ipv6_addresses                = try(length(group.ipv6_addresses) == 0, true) ? null : [for addr in group.ipv6_addresses : { prefix = addr }]
              priority                      = try(group.priority, null)
              preempt                       = try(group.preempt, null)
              preempt_delay_minimum         = try(group.preempt_delay_minimum, null)
              preempt_delay_reload          = try(group.preempt_delay_reload, null)
              preempt_delay_sync            = try(group.preempt_delay_sync, null)
              timers_hello_interval_seconds = try(group.timers_hello_interval_seconds, null)
              timers_hello_interval_msec    = try(group.timers_hello_interval_msec, null)
              timers_hold_time_seconds      = try(group.timers_hold_time_seconds, null)
              timers_hold_time_msec         = try(group.timers_hold_time_msec, null)
              authentication_text           = try(group.authentication_text, null)
              authentication_word           = try(group.authentication_word, null)
              mac_address                   = try(group.mac_address, null)
              name                          = try(group.name, null)
              follow                        = try(group.follow, null)
              tracks                        = try(length(group.tracks) == 0, true) ? null : [for t in group.tracks : { number = t.number, decrement = try(t.decrement, null), shutdown = try(t.shutdown, null) }]
            }]
          } if try(length(sub.hsrp), 0) > 0
        ]
      ],
      [
        for int in try(local.device_config[device.name].interfaces.bdis, []) : {
          key                           = format("%s/BDI%s", device.name, int.id)
          device                        = device.name
          type                          = "BDI"
          name                          = tostring(int.id)
          managed                       = true
          version                       = try(int.hsrp_version, null)
          bfd                           = try(int.hsrp_bfd, null)
          delay_minimum                 = try(int.hsrp_delay_minimum, null)
          delay_reload                  = try(int.hsrp_delay_reload, null)
          mac_refresh                   = try(int.hsrp_mac_refresh, null)
          use_bia                       = try(int.hsrp_use_bia, null)
          use_bia_scope_interface       = try(int.hsrp_use_bia_scope_interface, null)
          redirect_timers_advertisement = try(int.hsrp_redirect_timers_advertisement, null)
          redirect_timers_holddown      = try(int.hsrp_redirect_timers_holddown, null)
          redirect_unknown              = try(int.hsrp_redirect_unknown, null)
          standby_list = try(length(int.hsrp) == 0, true) ? null : [for group in int.hsrp : {
            group_number                  = group.group_number
            ip                            = try(group.ip, null)
            ip_address                    = try(group.ip_address, null)
            ip_secondary_addresses        = try(length(group.ip_secondary_addresses) == 0, true) ? null : [for addr in group.ip_secondary_addresses : { address = addr, secondary = true }]
            ipv6_link_local               = try(group.ipv6_link_local, null)
            ipv6_addresses                = try(length(group.ipv6_addresses) == 0, true) ? null : [for addr in group.ipv6_addresses : { prefix = addr }]
            priority                      = try(group.priority, null)
            preempt                       = try(group.preempt, null)
            preempt_delay_minimum         = try(group.preempt_delay_minimum, null)
            preempt_delay_reload          = try(group.preempt_delay_reload, null)
            preempt_delay_sync            = try(group.preempt_delay_sync, null)
            timers_hello_interval_seconds = try(group.timers_hello_interval_seconds, null)
            timers_hello_interval_msec    = try(group.timers_hello_interval_msec, null)
            timers_hold_time_seconds      = try(group.timers_hold_time_seconds, null)
            timers_hold_time_msec         = try(group.timers_hold_time_msec, null)
            authentication_text           = try(group.authentication_text, null)
            authentication_word           = try(group.authentication_word, null)
            mac_address                   = try(group.mac_address, null)
            name                          = try(group.name, null)
            follow                        = try(group.follow, null)
            tracks                        = try(length(group.tracks) == 0, true) ? null : [for t in group.tracks : { number = t.number, decrement = try(t.decrement, null), shutdown = try(t.shutdown, null) }]
          }]
        } if try(length(int.hsrp), 0) > 0
      ]
    )
  ])
}

resource "iosxe_interface_hsrp" "hsrp" {
  for_each = { for v in local.interfaces_hsrp : v.key => v if v.managed }

  device                        = each.value.device
  type                          = each.value.type
  name                          = each.value.name
  version                       = each.value.version
  bfd                           = each.value.bfd
  delay_minimum                 = each.value.delay_minimum
  delay_reload                  = each.value.delay_reload
  mac_refresh                   = each.value.mac_refresh
  use_bia                       = each.value.use_bia
  use_bia_scope_interface       = each.value.use_bia_scope_interface
  redirect_timers_advertisement = each.value.redirect_timers_advertisement
  redirect_timers_holddown      = each.value.redirect_timers_holddown
  redirect_unknown              = each.value.redirect_unknown
  standby_list                  = each.value.standby_list

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_interface_bdi.bdi
  ]
}

resource "iosxe_interface_hsrp" "hsrp_unmanaged" {
  for_each = { for v in local.interfaces_hsrp : v.key => v if !v.managed }

  device                        = each.value.device
  type                          = each.value.type
  name                          = each.value.name
  version                       = each.value.version
  bfd                           = each.value.bfd
  delay_minimum                 = each.value.delay_minimum
  delay_reload                  = each.value.delay_reload
  mac_refresh                   = each.value.mac_refresh
  use_bia                       = each.value.use_bia
  use_bia_scope_interface       = each.value.use_bia_scope_interface
  redirect_timers_advertisement = each.value.redirect_timers_advertisement
  redirect_timers_holddown      = each.value.redirect_timers_holddown
  redirect_unknown              = each.value.redirect_unknown
  standby_list                  = each.value.standby_list

  depends_on = [
    iosxe_interface_ethernet.ethernet_unmanaged
  ]

  lifecycle {
    ignore_changes = all
  }
}
