locals {
  flow_exporter = flatten([
    for device in local.devices : [
      for exporter in try(local.device_config[device.name].flow.exporters, []) : {
        key    = format("%s/%s", device.name, exporter.name)
        device = device.name

        name                                  = exporter.name
        description                           = try(exporter.description, local.defaults.iosxe.device_config.flow.exporters.description, null)
        destination_ip                        = try(exporter.destination_ip, local.defaults.iosxe.device_config.flow.exporters.destination_ip, null)
        export_protocol                       = try(exporter.export_protocol, local.defaults.iosxe.device_config.flow.exporters.export_protocol, null)
        option_application_attributes_timeout = try(exporter.option_application_attributes_timeout, local.defaults.iosxe.device_config.flow.exporters.option_application_attributes_timeout, null)
        option_application_table_timeout      = try(exporter.option_application_table_timeout, local.defaults.iosxe.device_config.flow.exporters.option_application_table_timeout, null)
        option_interface_table_timeout        = try(exporter.option_interface_table_timeout, local.defaults.iosxe.device_config.flow.exporters.option_interface_table_timeout, null)
        option_sampler_table                  = try(exporter.option_sampler_table, local.defaults.iosxe.device_config.flow.exporters.option_sampler_table, null)
        option_vrf_table_timeout              = try(exporter.option_vrf_table_timeout, local.defaults.iosxe.device_config.flow.exporters.option_vrf_table_timeout, null)
        source_loopback                       = try(exporter.source_loopback, local.defaults.iosxe.device_config.flow.exporters.source_loopback, null)
        transport_udp                         = try(exporter.transport_udp, local.defaults.iosxe.device_config.flow.exporters.transport_udp, null)
        template_data_timeout                 = try(exporter.template_data_timeout, local.defaults.iosxe.device_config.flow.exporters.template_data_timeout, null)
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
        exporters = [for exporter in try(monitor.exporters, local.defaults.iosxe.device_config.flow.monitors.exporters, []) : {
          name = exporter
        }]
        cache_timeout_active   = try(monitor.cache_timeout_active, local.defaults.iosxe.device_config.flow.monitors.cache_timeout_active, null)
        cache_timeout_inactive = try(monitor.cache_timeout_inactive, local.defaults.iosxe.device_config.flow.monitors.cache_timeout_inactive, null)
        record                 = try(monitor.record, local.defaults.iosxe.device_config.flow.monitors.record, null)
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

        name                                                 = record.name
        description                                          = try(record.description, local.defaults.iosxe.device_config.flow.records.description, null)
        match_application_name                               = try(record.match.application_name, local.defaults.iosxe.device_config.flow.records.match.application_name, null)
        match_connection_client_ipv4_address                 = try(record.match.connection_client_ipv4_address, local.defaults.iosxe.device_config.flow.records.match.connection_client_ipv4_address, null)
        match_connection_client_ipv6_address                 = try(record.match.connection_client_ipv6_address, local.defaults.iosxe.device_config.flow.records.match.connection_client_ipv6_address, null)
        match_connection_server_ipv4_address                 = try(record.match.connection_server_ipv4_address, local.defaults.iosxe.device_config.flow.records.match.connection_server_ipv4_address, null)
        match_connection_server_ipv6_address                 = try(record.match.connection_server_ipv6_address, local.defaults.iosxe.device_config.flow.records.match.connection_server_ipv6_address, null)
        match_connection_server_transport_port               = try(record.match.connection_server_transport_port, local.defaults.iosxe.device_config.flow.records.match.connection_server_transport_port, null)
        match_flow_direction                                 = try(record.match.flow_direction, local.defaults.iosxe.device_config.flow.records.match.flow_direction, null)
        match_flow_observation_point                         = try(record.match.flow_observation_point, local.defaults.iosxe.device_config.flow.records.match.flow_observation_point, null)
        match_interface_input                                = try(record.match.interface_input, local.defaults.iosxe.device_config.flow.records.match.interface_input, null)
        match_ipv4_destination_address                       = try(record.match.ipv4_destination_address, local.defaults.iosxe.device_config.flow.records.match.ipv4_destination_address, null)
        match_ipv4_protocol                                  = try(record.match.ipv4_protocol, local.defaults.iosxe.device_config.flow.records.match.ipv4_protocol, null)
        match_ipv4_source_address                            = try(record.match.ipv4_source_address, local.defaults.iosxe.device_config.flow.records.match.ipv4_source_address, null)
        match_ipv4_tos                                       = try(record.match.ipv4_tos, local.defaults.iosxe.device_config.flow.records.match.ipv4_tos, null)
        match_ipv4_version                                   = try(record.match.ipv4_version, local.defaults.iosxe.device_config.flow.records.match.ipv4_version, null)
        match_ipv6_destination_address                       = try(record.match.ipv6_destination_address, local.defaults.iosxe.device_config.flow.records.match.ipv6_destination_address, null)
        match_ipv6_protocol                                  = try(record.match.ipv6_protocol, local.defaults.iosxe.device_config.flow.records.match.ipv6_protocol, null)
        match_ipv6_source_address                            = try(record.match.ipv6_source_address, local.defaults.iosxe.device_config.flow.records.match.ipv6_source_address, null)
        match_ipv6_version                                   = try(record.match.ipv6_version, local.defaults.iosxe.device_config.flow.records.match.ipv6_version, null)
        match_transport_destination_port                     = try(record.match.transport_destination_port, local.defaults.iosxe.device_config.flow.records.match.transport_destination_port, null)
        match_transport_source_port                          = try(record.match.transport_source_port, local.defaults.iosxe.device_config.flow.records.match.transport_source_port, null)
        collect_connection_initiator                         = try(record.collect.connection_initiator, local.defaults.iosxe.device_config.flow.records.collect.connection_initiator, null)
        collect_connection_new_connections                   = try(record.collect.connection_new_connections, local.defaults.iosxe.device_config.flow.records.collect.connection_new_connections, null)
        collect_connection_server_counter_bytes_network_long = try(record.collect.connection_server_counter_bytes_network_long, local.defaults.iosxe.device_config.flow.records.collect.connection_server_counter_bytes_network_long, null)
        collect_connection_server_counter_packets_long       = try(record.collect.connection_server_counter_packets_long, local.defaults.iosxe.device_config.flow.records.collect.connection_server_counter_packets_long, null)
        collect_counter_bytes_long                           = try(record.collect.counter_bytes_long, local.defaults.iosxe.device_config.flow.records.collect.counter_bytes_long, null)
        collect_counter_packets_long                         = try(record.collect.counter_packets_long, local.defaults.iosxe.device_config.flow.records.collect.counter_packets_long, null)
        collect_datalink_mac_source_address_input            = try(record.collect.datalink_mac_source_address_input, local.defaults.iosxe.device_config.flow.records.collect.datalink_mac_source_address_input, null)
        collect_flow_direction                               = try(record.collect.flow_direction, local.defaults.iosxe.device_config.flow.records.collect.flow_direction, null)
        collect_interface_output                             = try(record.collect.interface_output, local.defaults.iosxe.device_config.flow.records.collect.interface_output, null)
        collect_timestamp_absolute_first                     = try(record.collect.timestamp_absolute_first, local.defaults.iosxe.device_config.flow.records.collect.timestamp_absolute_first, null)
        collect_timestamp_absolute_last                      = try(record.collect.timestamp_absolute_last, local.defaults.iosxe.device_config.flow.records.collect.timestamp_absolute_last, null)
        collect_transport_tcp_flags                          = try(record.collect.transport_tcp_flags, local.defaults.iosxe.device_config.flow.records.collect.transport_tcp_flags, null)
      }
    ]
  ])
}

resource "iosxe_flow_exporter" "flow_exporter" {
  for_each = { for e in local.flow_exporter : e.key => e }
  device   = each.value.device

  name                                  = each.value.name
  description                           = each.value.description
  destination_ip                        = each.value.destination_ip
  export_protocol                       = each.value.export_protocol
  option_application_attributes_timeout = each.value.option_application_attributes_timeout
  option_application_table_timeout      = each.value.option_application_table_timeout
  option_interface_table_timeout        = each.value.option_interface_table_timeout
  option_sampler_table                  = each.value.option_sampler_table
  option_vrf_table_timeout              = each.value.option_vrf_table_timeout
  source_loopback                       = each.value.source_loopback
  transport_udp                         = each.value.transport_udp
  template_data_timeout                 = each.value.template_data_timeout
}



resource "iosxe_flow_monitor" "flow_monitors" {
  for_each = { for e in local.flow_monitor : e.key => e }
  device   = each.value.device

  name                   = each.value.name
  description            = each.value.description
  exporters              = each.value.exporters
  cache_timeout_active   = each.value.cache_timeout_active
  cache_timeout_inactive = each.value.cache_timeout_inactive
  record                 = each.value.record
  depends_on             = [iosxe_flow_exporter.flow_exporter, iosxe_flow_record.flow_records]
}



resource "iosxe_flow_record" "flow_records" {
  for_each = { for e in local.flow_record : e.key => e }
  device   = each.value.device

  name                                                 = each.value.name
  description                                          = each.value.description
  match_application_name                               = each.value.match_application_name
  match_connection_client_ipv4_address                 = each.value.match_connection_client_ipv4_address
  match_connection_client_ipv6_address                 = each.value.match_connection_client_ipv6_address
  match_connection_server_ipv4_address                 = each.value.match_connection_server_ipv4_address
  match_connection_server_ipv6_address                 = each.value.match_connection_server_ipv6_address
  match_connection_server_transport_port               = each.value.match_connection_server_transport_port
  match_flow_direction                                 = each.value.match_flow_direction
  match_flow_observation_point                         = each.value.match_flow_observation_point
  match_interface_input                                = each.value.match_interface_input
  match_ipv4_destination_address                       = each.value.match_ipv4_destination_address
  match_ipv4_protocol                                  = each.value.match_ipv4_protocol
  match_ipv4_source_address                            = each.value.match_ipv4_source_address
  match_ipv4_tos                                       = each.value.match_ipv4_tos
  match_ipv4_version                                   = each.value.match_ipv4_version
  match_ipv6_destination_address                       = each.value.match_ipv6_destination_address
  match_ipv6_protocol                                  = each.value.match_ipv6_protocol
  match_ipv6_source_address                            = each.value.match_ipv6_source_address
  match_ipv6_version                                   = each.value.match_ipv6_version
  match_transport_destination_port                     = each.value.match_transport_destination_port
  match_transport_source_port                          = each.value.match_transport_source_port
  collect_connection_initiator                         = each.value.collect_connection_initiator
  collect_connection_new_connections                   = each.value.collect_connection_new_connections
  collect_connection_server_counter_bytes_network_long = each.value.collect_connection_server_counter_bytes_network_long
  collect_connection_server_counter_packets_long       = each.value.collect_connection_server_counter_packets_long
  collect_counter_bytes_long                           = each.value.collect_counter_bytes_long
  collect_counter_packets_long                         = each.value.collect_counter_packets_long
  collect_datalink_mac_source_address_input            = each.value.collect_datalink_mac_source_address_input
  collect_flow_direction                               = each.value.collect_flow_direction
  collect_interface_output                             = each.value.collect_interface_output
  collect_timestamp_absolute_first                     = each.value.collect_timestamp_absolute_first
  collect_timestamp_absolute_last                      = each.value.collect_timestamp_absolute_last
  collect_transport_tcp_flags                          = each.value.collect_transport_tcp_flags
}