locals {
  monitor_sessions = flatten([
    for device in local.devices : [
      for session in try(local.device_config[device.name].monitor_sessions, []) : {
        key        = format("%s/%s", device.name, session.session_id)
        device     = device.name
        session_id = session.session_id

        source_interface = try(length(session.source_interfaces) == 0, true) ? null : [
          for src in session.source_interfaces : {
            name      = try(src.name, null)
            direction = try(src.direction, null)
          }
        ]

        destination_interface = try(length(session.destination_interfaces) == 0, true) ? null : [
          for dst in session.destination_interfaces : {
            name          = try(dst.name, null)
            encapsulation = try(dst.encapsulation, null)
          }
        ]
      }
    ]
  ])
}
resource "iosxe_monitor_session" "monitor_session" {
  for_each = { for e in local.monitor_sessions : e.key => e }

  device                = each.value.device
  session_id            = each.value.session_id
  source_interface      = each.value.source_interface
  destination_interface = each.value.destination_interface

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_ethernet.ethernet_sub,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface
  ]
}
