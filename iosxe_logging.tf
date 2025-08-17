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
    vrf            = try(s.vrf, local.defaults.iosxe.configuration.logging.source_interfaces_vrf.vrf, null)
    interface_name = try("${try(s.interface_type, local.defaults.iosxe.configuration.logging.source_interfaces_vrf.interface_type)}${try(s.interface_id, local.defaults.iosxe.configuration.logging.source_interfaces_vrf.interface_id)}", null)
  }]

  # IPv4 hosts without VRF and without transport
  ipv4_hosts = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv4_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == false && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) == null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) == 0 &&
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) == 0 &&
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) == 0
  )]

  # IPv4 hosts without VRF but with transport
  ipv4_hosts_transport = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv4_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    transport_udp_ports = [for u in try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, []) : {
      port_number = try(u, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports_port, null)
    }]
    transport_tcp_ports = [for t in try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, []) : {
      port_number = try(t, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports_port, null)
    }]
    transport_tls_ports = [for l in try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, []) : {
      port_number = try(l.port, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_port, null)
      profile     = try(l.profile, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_profile, null)
    }]
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == false && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) == null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) > 0 ||
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) > 0 ||
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) > 0
  )]

  # IPv4 VRF hosts without transport
  ipv4_vrf_hosts = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv4_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    vrf       = try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null)
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == false && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) != null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) == 0 &&
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) == 0 &&
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) == 0
  )]

  # IPv4 VRF hosts with transport
  ipv4_vrf_hosts_transport = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv4_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    vrf       = try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null)
    transport_udp_ports = [for u in try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, []) : {
      port_number = try(u, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports_port, null)
    }]
    transport_tcp_ports = [for t in try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, []) : {
      port_number = try(t, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports_port, null)
    }]
    transport_tls_ports = [for l in try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, []) : {
      port_number = try(l.port, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_port, null)
      profile     = try(l.profile, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_profile, null)
    }]
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == false && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) != null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) > 0 ||
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) > 0 ||
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) > 0
  )]

  # IPv6 hosts without VRF and without transport
  ipv6_hosts = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv6_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == true && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) == null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) == 0 &&
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) == 0 &&
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) == 0
  )]

  # IPv6 hosts without VRF but with transport
  ipv6_hosts_transport = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv6_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    transport_udp_ports = [for u in try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, []) : {
      port_number = try(u, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports_port, null)
    }]
    transport_tcp_ports = [for t in try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, []) : {
      port_number = try(t, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports_port, null)
    }]
    transport_tls_ports = [for l in try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, []) : {
      port_number = try(l.port, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_port, null)
      profile     = try(l.profile, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_profile, null)
    }]
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == true && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) == null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) > 0 ||
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) > 0 ||
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) > 0
  )]

  # IPv6 VRF hosts without transport
  ipv6_vrf_hosts = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv6_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    vrf       = try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null)
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == true && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) != null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) == 0 &&
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) == 0 &&
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) == 0
  )]

  # IPv6 VRF hosts with transport
  ipv6_vrf_hosts_transport = [for host in try(local.device_config[each.value.name].logging.hosts, []) : {
    ipv6_host = try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, null)
    vrf       = try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null)
    transport_udp_ports = [for u in try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, []) : {
      port_number = try(u, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports_port, null)
    }]
    transport_tcp_ports = [for t in try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, []) : {
      port_number = try(t, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports_port, null)
    }]
    transport_tls_ports = [for l in try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, []) : {
      port_number = try(l.port, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_port, null)
      profile     = try(l.profile, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports_profile, null)
    }]
    } if can(regex(":", tostring(try(host.ip, local.defaults.iosxe.configuration.logging.hosts.ip, "")))) == true && try(host.vrf, local.defaults.iosxe.configuration.logging.hosts.vrf, null) != null && (
    length(try(host.transport_udp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_udp_ports, [])) > 0 ||
    length(try(host.transport_tcp_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tcp_ports, [])) > 0 ||
    length(try(host.transport_tls_ports, local.defaults.iosxe.configuration.logging.hosts.transport_tls_ports, [])) > 0
  )]
}
