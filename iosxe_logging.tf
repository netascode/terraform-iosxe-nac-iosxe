locals {
  logging_host_vrf = flatten([
    for device in local.devices : [
      for host in try(local.device_config[device.name].logging.hosts, []) : {
        key    = format("%s/%s", device.name, host.ip)
        device = device.name

        logging_ipv4_hosts     = (can(regex(":", tostring(host.ip))) == false && (try(host.vrf, null) != null) == false) ? { ipv4 = host.ip } : null
        logging_ipv4_vrf_hosts = (can(regex(":", tostring(host.ip))) == false && (try(host.vrf, null) != null) == true) ? { ipv4 = host.ip, vrf = host.vrf } : null
        logging_ipv6_hosts     = (can(regex(":", tostring(host.ip))) == true && (try(host.vrf, null) != null) == false) ? { ipv6 = host.ip } : null
        logging_ipv6_vrf_hosts = (can(regex(":", tostring(host.ip))) == true && (try(host.vrf, null) != null) == true) ? { ipv6 = host.ip, vrf = host.vrf } : null

        transport_udp_ports = [for u in try(host.transport_udp_ports, []) : {
          port_number = u
        }]
        transport_tcp_ports = [for t in try(host.transport_tcp_ports, []) : {
          port_number = t
        }]
        transport_tls_ports = [for l in try(host.transport_tls_ports, []) : {
          port_number = l.port
        }]
      }
    ]
  ])
}

resource "iosxe_logging" "logging" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].logging, null) != null || try(local.defaults.iosxe.configuration.logging, null) != null }
  device   = each.value.name

  monitor_severity  = try(local.device_config[each.value.name].logging.monitor_severity, local.defaults.iosxe.configuration.logging.monitor_severity, null)
  buffered_size     = try(local.device_config[each.value.name].logging.buffered_size, local.defaults.iosxe.configuration.logging.buffered_size, null)
  buffered_severity = try(local.device_config[each.value.name].logging.buffered_severity, local.defaults.iosxe.configuration.logging.buffered_severity, null)
  console_severity  = try(local.device_config[each.value.name].logging.console_severity, local.defaults.iosxe.configuration.logging.console_severity, null)
  facility          = try(local.device_config[each.value.name].logging.facility, local.defaults.iosxe.configuration.logging.facility, null)
  history_size      = try(local.device_config[each.value.name].logging.history_size, local.defaults.iosxe.configuration.logging.history_size, null)
  history_severity  = try(local.device_config[each.value.name].logging.history_severity, local.defaults.iosxe.configuration.logging.history_severity, null)
  trap              = try(local.device_config[each.value.name].logging.trap, local.defaults.iosxe.configuration.logging.trap, null)
  trap_severity     = try(local.device_config[each.value.name].logging.trap_severity, local.defaults.iosxe.configuration.logging.trap_severity, null)
  origin_id_type    = try(local.device_config[each.value.name].logging.origin_id_type, local.defaults.iosxe.configuration.logging.origin_id_type, null)
  origin_id_name    = try(local.device_config[each.value.name].logging.origin_id_name, local.defaults.iosxe.configuration.logging.origin_id_name, null)
  file_name         = try(local.device_config[each.value.name].logging.file_name, local.defaults.iosxe.configuration.logging.file_name, null)
  file_max_size     = try(local.device_config[each.value.name].logging.file_max_size, local.defaults.iosxe.configuration.logging.file_max_size, null)
  file_min_size     = try(local.device_config[each.value.name].logging.file_min_size, local.defaults.iosxe.configuration.logging.file_min_size, null)
  file_severity     = try(local.device_config[each.value.name].logging.file_severity, local.defaults.iosxe.configuration.logging.file_severity, null)
  source_interface  = try("${try(local.device_config[each.value.name].logging.source_interface_type, local.defaults.iosxe.configuration.logging.source_interface_type)}${try(local.device_config[each.value.name].logging.source_interface_id, local.defaults.iosxe.configuration.logging.source_interface_id)}", null)
  source_interfaces_vrf = [for s in try(local.device_config[each.value.name].logging.source_interfaces_vrf, []) : {
    vrf       = s.vrf
    interface = try("${try(s.interface_type, local.defaults.iosxe.configuration.logging.source_interfaces_vrf.interface_type)}${try(s.interface_id, local.defaults.iosxe.configuration.logging.source_interfaces_vrf.interface_id)}", null)
  }]

  ipv4_hosts = try([for h in try(local.logging_host_vrf, []) : {
    ipv4_host = h.logging_ipv4_hosts.ipv4
  } if h.device == each.value.name], null)
  ipv4_vrf_hosts = try([for h in try(local.logging_host_vrf, []) : {
    ipv4_host = h.logging_ipv4_vrf_hosts.ipv4
    vrf       = h.logging_ipv4_vrf_hosts.vrf
  } if h.device == each.value.name], null)
  ipv6_hosts = try([for h in try(local.logging_host_vrf, []) : {
    ipv6_host = h.logging_ipv6_hosts.ipv6
  } if h.device == each.value.name], null)
  ipv6_vrf_hosts = try([for h in try(local.logging_host_vrf, []) : {
    ipv6_host = h.logging_ipv6_vrf_hosts.ipv6
    vrf       = h.logging_ipv6_vrf_hosts.vrf
  } if h.device == each.value.name], null)

}

resource "iosxe_logging_ipv4_host_transport" "logging_ipv4_host_transport" {
  for_each = { for host_entry in local.logging_host_vrf : host_entry.key => host_entry if host_entry.logging_ipv4_hosts != null }
  device   = each.value.device

  ipv4_host           = each.value.logging_ipv4_hosts.ipv4
  transport_udp_ports = try(each.value.transport_udp_ports, [])
  transport_tcp_ports = try(each.value.transport_tcp_ports, [])
  transport_tls_ports = try(each.value.transport_tls_ports, [])
}

resource "iosxe_logging_ipv4_host_vrf_transport" "logging_ipv4_host_vrf_transport" {
  for_each = { for host_entry in local.logging_host_vrf : host_entry.key => host_entry if host_entry.logging_ipv4_vrf_hosts != null }
  device   = each.value.device

  ipv4_host           = each.value.logging_ipv4_vrf_hosts.ipv4
  vrf                 = each.value.logging_ipv4_vrf_hosts.vrf
  transport_udp_ports = try(each.value.transport_udp_ports, [])
  transport_tcp_ports = try(each.value.transport_tcp_ports, [])
  transport_tls_ports = try(each.value.transport_tls_ports, [])
}

resource "iosxe_logging_ipv6_host_transport" "logging_ipv6_host_transport" {
  for_each = { for host_entry in local.logging_host_vrf : host_entry.key => host_entry if host_entry.logging_ipv6_hosts != null }
  device   = each.value.device

  ipv6_host           = each.value.logging_ipv6_hosts.ipv6
  transport_udp_ports = try(each.value.transport_udp_ports, [])
  transport_tcp_ports = try(each.value.transport_tcp_ports, [])
  transport_tls_ports = try(each.value.transport_tls_ports, [])
}

resource "iosxe_logging_ipv6_host_vrf_transport" "logging_ipv6_host_vrf_transport" {
  for_each = { for host_entry in local.logging_host_vrf : host_entry.key => host_entry if host_entry.logging_ipv6_vrf_hosts != null }
  device   = each.value.device

  ipv6_host           = each.value.logging_ipv6_vrf_hosts.ipv6
  vrf                 = each.value.logging_ipv6_vrf_hosts.vrf
  transport_udp_ports = try(each.value.transport_udp_ports, [])
  transport_tcp_ports = try(each.value.transport_tcp_ports, [])
  transport_tls_ports = try(each.value.transport_tls_ports, [])
}
