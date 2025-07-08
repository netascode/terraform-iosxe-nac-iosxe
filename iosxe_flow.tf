locals {
  flow_exporter = flatten([
    for device in local.devices : [
      for exporter in try(local.device_config[device.name].flow.exporters, []) : {
        key    = format("%s/%s", device.name, exporter.name)
        device = device.name

        name                  = exporter.name
        description           = try(exporter.description, local.defaults.iosxe.device_config.flow.exporters.description, null)
        destination_ip        = try(exporter.destination_ip, local.defaults.iosxe.device_config.flow.exporters.destination_ip, null)
        source_loopback       = try(exporter.source_loopback, local.defaults.iosxe.device_config.flow.exporters.source_loopback, null)
        transport_udp         = try(exporter.transport_udp, local.defaults.iosxe.device_config.flow.exporters.transport_udp, null)
        template_data_timeout = try(exporter.template_data_timeout, local.defaults.iosexe.device_config.flow.exporters.template_data_timeout, null)
      }
    ]
  ])
}

locals {
  flow_monitor = flatten([
    for device in local.devices : [
      for monitor in try(local.device_config[device.name].flow.monitors, []) : {
        key    = format("%s/%s", device.name, monitor.name)
        device = device.name

        name        = monitor.name
        description = try(monitor.description, local.defaults.iosxe.device_config.flow.monitors.description, null)
        exporters = [for exporter in try(local.device_config.flow.monitors.exporters, []) : {
          name = exporter
        }]
        cache_timeout_active = try(monitor.cache_timeout_active, local.defaults.iosxe.device_config.flow.monitors.cache_timeout_active, null)
        record               = try(monitor.record, local.defaults.iosxe.device_config.flow.monitors.record, null)
      }
    ]
  ])
}

locals {
  flow_record = flatten([
    for device in local.devices : [
      for record in try(local.device_config[device.name].flow.records, []) : {
        key    = format("%s/%s", device.name, record.name)
        device = device.name

        name                             = record.name
        description                      = try(record.description, local.defaults.iosxe.device_config.flow.records.description, null)
        match_ipv4_source_address        = try(record.match_ipv4_source_address, local.defaults.iosxe.device_config.flow.records.match_ipv4_source_address, null)
        match_ipv4_destination_address   = try(record.match_ipv4_destination_address, local.defaults.iosxe.device_config.flow.records.match_ipv4_destination_address, null)
        match_ipv4_protocol              = try(record.match_ipv4_protocol, local.defaults.iosxe.device_config.flow.records.match_ipv4_protocol, null)
        match_ipv4_tos                   = try(record.match_ipv4_tos, local.defaults.iosxe.device_config.flow.records.match_ipv4_tos, null)
        match_transport_source_port      = try(record.match_transport_source_port, local.defaults.iosxe.device_config.flow.records.match_transport_source_port, null)
        match_transport_destination_port = try(record.match_transport_destination_port, local.defaults.iosxe.device_config.flow.records.match_transport_destination_port, null)
        match_interface_input            = try(record.match_interface_input, local.defaults.iosxe.device_config.flow.records.match_interface_input, null)
        match_flow_direction             = try(record.match_flow_direction, local.defaults.iosxe.device_config.flow.records.match_flow_direction, null)
        collect_interface_output         = try(record.collect_interface_output, local.defaults.iosxe.device_config.flow.records.collect_interface_output, null)
        collect_counter_bytes_long       = try(record.collect_counter_bytes_long, local.defaults.iosxe.device_config.flow.records.collect_counter_bytes_long, null)
        collect_counter_packets_long     = try(record.collect_counter_packets_long, local.defaults.iosxe.device_config.flow.records.collect_counter_packets_long, null)
        collect_transport_tcp_flags      = try(record.collect_transport_tcp_flags, local.defaults.iosxe.device_config.flow.records.collect_transport_tcp_flags, null)
        collect_timestamp_absolute_first = try(record.collect_timestamp_absolute_first, local.defaults.iosxe.device_config.flow.collect_timestamp_absolute_first.collect_interface_output, null)
        collect_timestamp_absolute_last  = try(record.collect_timestamp_absolute_last, local.defaults.iosxe.device_config.flow.collect_timestamp_absolute_last.collect_interface_output, null)
      }
    ]
  ])
}

resource "iosxe_flow_exporter" "flow_exporter" {
  for_each = { for e in local.flow_exporter : e.key => e }
  device   = each.value.device

  name                  = each.value.name
  description           = each.value.description
  destination_ip        = each.value.destination_ip
  source_loopback       = each.value.source_loopback
  transport_udp         = each.value.transport_udp
  template_data_timeout = each.value.template_data_timeout
}



resource "iosxe_flow_monitor" "flow_monitors" {
  for_each = { for e in local.flow_monitor : e.key => e }
  device   = each.value.device

  name                 = each.value.name
  description          = each.value.description
  exporters            = each.value.exporters
  cache_timeout_active = each.value.cache_timeout_active
  record               = each.value.record
  depends_on           = [iosxe_flow_exporter.flow_exporter, iosxe_flow_record.flow_records]
}



resource "iosxe_flow_record" "flow_records" {
  for_each = { for e in local.flow_record : e.key => e }
  device   = each.value.device

  name                             = each.value.name
  description                      = each.value.description
  match_ipv4_source_address        = each.value.match_ipv4_source_address
  match_ipv4_destination_address   = each.value.match_ipv4_destination_address
  match_ipv4_protocol              = each.value.match_ipv4_protocol
  match_ipv4_tos                   = each.value.match_ipv4_tos
  match_transport_source_port      = each.value.match_transport_source_port
  match_transport_destination_port = each.value.match_transport_destination_port
  match_interface_input            = each.value.match_interface_input
  match_flow_direction             = each.value.match_flow_direction
  collect_interface_output         = each.value.collect_interface_output
  collect_counter_bytes_long       = each.value.collect_counter_bytes_long
  collect_counter_packets_long     = each.value.collect_counter_packets_long
  collect_transport_tcp_flags      = each.value.collect_transport_tcp_flags
  collect_timestamp_absolute_first = each.value.collect_timestamp_absolute_first
  collect_timestamp_absolute_last  = each.value.collect_timestamp_absolute_last
}