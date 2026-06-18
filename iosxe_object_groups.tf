locals {
  object_groups = {
    for device in local.devices : device.name => {
      device = device.name
      fqdn = try(length(local.device_config[device.name].object_groups_fqdn) == 0, true) ? null : [for og in local.device_config[device.name].object_groups_fqdn : {
        name        = og.name
        description = try(og.description, local.defaults.iosxe.configuration.object_groups_fqdn.description, null)
        group_objects = try(length(og.group_objects) == 0, true) ? null : [for g in og.group_objects : {
          group_name = g
        }]
        patterns = try(length(og.patterns) == 0, true) ? null : [for p in og.patterns : {
          fqdn_pattern = p
        }]
      }]
      network = try(length(local.device_config[device.name].object_groups_network) == 0, true) ? null : [for og in local.device_config[device.name].object_groups_network : {
        name        = og.name
        description = try(og.description, local.defaults.iosxe.configuration.object_groups_network.description, null)
        hosts = try(length(og.hosts) == 0, true) ? null : [for h in og.hosts : {
          ipv4_host = h
        }]
        network_addresses = try(length(og.network_addresses) == 0, true) ? null : [for n in og.network_addresses : {
          ipv4_address = n.address
          ipv4_mask    = n.mask
        }]
        address_ranges = try(length(og.address_ranges) == 0, true) ? null : [for r in og.address_ranges : {
          start = r.start
          end   = r.end
        }]
        group_objects = try(length(og.group_objects) == 0, true) ? null : [for g in og.group_objects : {
          group_name = g
        }]
      }]
      service = try(length(local.device_config[device.name].object_groups_service) == 0, true) ? null : [for og in local.device_config[device.name].object_groups_service : {
        name        = og.name
        description = try(og.description, local.defaults.iosxe.configuration.object_groups_service.description, null)
        group_objects = try(length(og.group_objects) == 0, true) ? null : [for g in og.group_objects : {
          group_name = g
        }]
        protocol_numbers = try(length(og.protocol_numbers) == 0, true) ? null : [for n in og.protocol_numbers : {
          number = n
        }]
        ahp                       = try(og.ahp, null)
        eigrp                     = try(og.eigrp, null)
        esp                       = try(og.esp, null)
        gre                       = try(og.gre, null)
        icmp                      = try(og.icmp, null)
        igmp                      = try(og.igmp, null)
        ip                        = try(og.ip, null)
        ipinip                    = try(og.ipinip, null)
        nos                       = try(og.nos, null)
        ospf                      = try(og.ospf, null)
        pcp                       = try(og.pcp, null)
        pim                       = try(og.pim, null)
        tcp                       = try(og.tcp_protocol, null)
        udp                       = try(og.udp_protocol, null)
        icmp_port_number          = try(og.icmp_port_number, null)
        icmp_alternate_address    = try(og.icmp_alternate_address, null)
        icmp_conversion_error     = try(og.icmp_conversion_error, null)
        icmp_echo                 = try(og.icmp_echo, null)
        icmp_echo_reply           = try(og.icmp_echo_reply, null)
        icmp_information_reply    = try(og.icmp_information_reply, null)
        icmp_information_request  = try(og.icmp_information_request, null)
        icmp_mask_reply           = try(og.icmp_mask_reply, null)
        icmp_mask_request         = try(og.icmp_mask_request, null)
        icmp_mobile_redirect      = try(og.icmp_mobile_redirect, null)
        icmp_parameter_problem    = try(og.icmp_parameter_problem, null)
        icmp_redirect             = try(og.icmp_redirect, null)
        icmp_router_advertisement = try(og.icmp_router_advertisement, null)
        icmp_router_solicitation  = try(og.icmp_router_solicitation, null)
        icmp_source_quench        = try(og.icmp_source_quench, null)
        icmp_time_exceeded        = try(og.icmp_time_exceeded, null)
        icmp_timestamp_reply      = try(og.icmp_timestamp_reply, null)
        icmp_timestamp_request    = try(og.icmp_timestamp_request, null)
        icmp_traceroute           = try(og.icmp_traceroute, null)
        icmp_unreachable          = try(og.icmp_unreachable, null)
        tcp_dst_port_list_op = try(length(og.tcp_dst_ports) == 0, true) ? null : [for p in og.tcp_dst_ports : {
          operator = p.operator
          port     = tostring(p.port)
        }]
        tcp_dst_port_list = try(length(og.tcp_dst_port_list) == 0, true) ? null : [for p in og.tcp_dst_port_list : {
          port = tostring(p)
        }]
        tcp_dst_port_ranges = try(length(og.tcp_dst_port_ranges) == 0, true) ? null : [for r in og.tcp_dst_port_ranges : {
          min_port = tostring(r.min_port)
          max_port = tostring(r.max_port)
        }]
        tcp_src_port_list_op = try(length(og.tcp_src_ports) == 0, true) ? null : [for p in og.tcp_src_ports : {
          operator = p.operator
          port     = tostring(p.port)
        }]
        tcp_src_port_list = try(length(og.tcp_src_port_list) == 0, true) ? null : [for p in og.tcp_src_port_list : {
          port = tostring(p)
        }]
        tcp_src_port_ranges = try(length(og.tcp_src_port_ranges) == 0, true) ? null : [for r in og.tcp_src_port_ranges : {
          min_port = tostring(r.min_port)
          max_port = tostring(r.max_port)
        }]
        tcp_src_dst_port_list_op = try(length(og.tcp_src_dst_ports_op) == 0, true) ? null : [for p in og.tcp_src_dst_ports_op : {
          src_operator = p.src_operator
          src_port     = tostring(p.src_port)
          dst_operator = p.dst_operator
          dst_port     = tostring(p.dst_port)
        }]
        tcp_src_dst_port_list = try(length(og.tcp_src_dst_port_list) == 0, true) ? null : [for p in og.tcp_src_dst_port_list : {
          src_port = tostring(p.src_port)
          dst_port = tostring(p.dst_port)
        }]
        tcp_src_dst_port_list_src_op = try(length(og.tcp_src_dst_ports_src_op) == 0, true) ? null : [for p in og.tcp_src_dst_ports_src_op : {
          src_operator = p.src_operator
          src_port     = tostring(p.src_port)
          dst_port     = tostring(p.dst_port)
        }]
        tcp_src_dst_port_list_dst_op = try(length(og.tcp_src_dst_ports_dst_op) == 0, true) ? null : [for p in og.tcp_src_dst_ports_dst_op : {
          src_port     = tostring(p.src_port)
          dst_operator = p.dst_operator
          dst_port     = tostring(p.dst_port)
        }]
        tcp_src_range_dst_port_list_op = try(length(og.tcp_src_range_dst_ports_op) == 0, true) ? null : [for p in og.tcp_src_range_dst_ports_op : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          operator     = p.operator
          dst_port     = tostring(p.dst_port)
        }]
        tcp_src_range_dst_port_list = try(length(og.tcp_src_range_dst_port_list) == 0, true) ? null : [for p in og.tcp_src_range_dst_port_list : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          dst_port     = tostring(p.dst_port)
        }]
        tcp_src_dst_range_port_list_op = try(length(og.tcp_src_dst_range_ports_op) == 0, true) ? null : [for p in og.tcp_src_dst_range_ports_op : {
          operator     = p.operator
          src_port     = tostring(p.src_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        tcp_src_dst_range_port_list = try(length(og.tcp_src_dst_range_port_list) == 0, true) ? null : [for p in og.tcp_src_dst_range_port_list : {
          src_port     = tostring(p.src_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        tcp_src_range_dst_range_port_list = try(length(og.tcp_src_range_dst_range_port_list) == 0, true) ? null : [for p in og.tcp_src_range_dst_range_port_list : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        udp_dst_port_list_op = try(length(og.udp_dst_ports) == 0, true) ? null : [for p in og.udp_dst_ports : {
          operator = p.operator
          port     = tostring(p.port)
        }]
        udp_dst_port_list = try(length(og.udp_dst_port_list) == 0, true) ? null : [for p in og.udp_dst_port_list : {
          port = tostring(p)
        }]
        udp_dst_port_ranges = try(length(og.udp_dst_port_ranges) == 0, true) ? null : [for r in og.udp_dst_port_ranges : {
          min_port = tostring(r.min_port)
          max_port = tostring(r.max_port)
        }]
        udp_src_port_list_op = try(length(og.udp_src_ports) == 0, true) ? null : [for p in og.udp_src_ports : {
          operator = p.operator
          port     = tostring(p.port)
        }]
        udp_src_port_list = try(length(og.udp_src_port_list) == 0, true) ? null : [for p in og.udp_src_port_list : {
          port = tostring(p)
        }]
        udp_src_port_ranges = try(length(og.udp_src_port_ranges) == 0, true) ? null : [for r in og.udp_src_port_ranges : {
          min_port = tostring(r.min_port)
          max_port = tostring(r.max_port)
        }]
        udp_src_dst_port_list_op = try(length(og.udp_src_dst_ports_op) == 0, true) ? null : [for p in og.udp_src_dst_ports_op : {
          src_operator = p.src_operator
          src_port     = tostring(p.src_port)
          dst_operator = p.dst_operator
          dst_port     = tostring(p.dst_port)
        }]
        udp_src_dst_port_list = try(length(og.udp_src_dst_port_list) == 0, true) ? null : [for p in og.udp_src_dst_port_list : {
          src_port = tostring(p.src_port)
          dst_port = tostring(p.dst_port)
        }]
        udp_src_dst_port_list_src_op = try(length(og.udp_src_dst_ports_src_op) == 0, true) ? null : [for p in og.udp_src_dst_ports_src_op : {
          src_operator = p.src_operator
          src_port     = tostring(p.src_port)
          dst_port     = tostring(p.dst_port)
        }]
        udp_src_dst_port_list_dst_op = try(length(og.udp_src_dst_ports_dst_op) == 0, true) ? null : [for p in og.udp_src_dst_ports_dst_op : {
          src_port     = tostring(p.src_port)
          dst_operator = p.dst_operator
          dst_port     = tostring(p.dst_port)
        }]
        udp_src_range_dst_port_list_op = try(length(og.udp_src_range_dst_ports_op) == 0, true) ? null : [for p in og.udp_src_range_dst_ports_op : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          operator     = p.operator
          dst_port     = tostring(p.dst_port)
        }]
        udp_src_range_dst_port_list = try(length(og.udp_src_range_dst_port_list) == 0, true) ? null : [for p in og.udp_src_range_dst_port_list : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          dst_port     = tostring(p.dst_port)
        }]
        udp_src_dst_range_port_list_op = try(length(og.udp_src_dst_range_ports_op) == 0, true) ? null : [for p in og.udp_src_dst_range_ports_op : {
          operator     = p.operator
          src_port     = tostring(p.src_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        udp_src_dst_range_port_list = try(length(og.udp_src_dst_range_port_list) == 0, true) ? null : [for p in og.udp_src_dst_range_port_list : {
          src_port     = tostring(p.src_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        udp_src_range_dst_range_port_list = try(length(og.udp_src_range_dst_range_port_list) == 0, true) ? null : [for p in og.udp_src_range_dst_range_port_list : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        tcp_udp_dst_port_list_op = try(length(og.tcp_udp_dst_ports) == 0, true) ? null : [for p in og.tcp_udp_dst_ports : {
          operator = p.operator
          port     = tostring(p.port)
        }]
        tcp_udp_dst_port_list = try(length(og.tcp_udp_dst_port_list) == 0, true) ? null : [for p in og.tcp_udp_dst_port_list : {
          port = tostring(p)
        }]
        tcp_udp_dst_port_ranges = try(length(og.tcp_udp_dst_port_ranges) == 0, true) ? null : [for r in og.tcp_udp_dst_port_ranges : {
          min_port = tostring(r.min_port)
          max_port = tostring(r.max_port)
        }]
        tcp_udp_src_port_list_op = try(length(og.tcp_udp_src_ports) == 0, true) ? null : [for p in og.tcp_udp_src_ports : {
          operator = p.operator
          port     = tostring(p.port)
        }]
        tcp_udp_src_port_list = try(length(og.tcp_udp_src_port_list) == 0, true) ? null : [for p in og.tcp_udp_src_port_list : {
          port = tostring(p)
        }]
        tcp_udp_src_port_ranges = try(length(og.tcp_udp_src_port_ranges) == 0, true) ? null : [for r in og.tcp_udp_src_port_ranges : {
          min_port = tostring(r.min_port)
          max_port = tostring(r.max_port)
        }]
        tcp_udp_src_dst_port_list_op = try(length(og.tcp_udp_src_dst_ports_op) == 0, true) ? null : [for p in og.tcp_udp_src_dst_ports_op : {
          src_operator = p.src_operator
          src_port     = tostring(p.src_port)
          dst_operator = p.dst_operator
          dst_port     = tostring(p.dst_port)
        }]
        tcp_udp_src_dst_port_list = try(length(og.tcp_udp_src_dst_port_list) == 0, true) ? null : [for p in og.tcp_udp_src_dst_port_list : {
          src_port = tostring(p.src_port)
          dst_port = tostring(p.dst_port)
        }]
        tcp_udp_src_dst_port_list_src_op = try(length(og.tcp_udp_src_dst_ports_src_op) == 0, true) ? null : [for p in og.tcp_udp_src_dst_ports_src_op : {
          src_operator = p.src_operator
          src_port     = tostring(p.src_port)
          dst_port     = tostring(p.dst_port)
        }]
        tcp_udp_src_dst_port_list_dst_op = try(length(og.tcp_udp_src_dst_ports_dst_op) == 0, true) ? null : [for p in og.tcp_udp_src_dst_ports_dst_op : {
          src_port     = tostring(p.src_port)
          dst_operator = p.dst_operator
          dst_port     = tostring(p.dst_port)
        }]
        tcp_udp_src_range_dst_port_list_op = try(length(og.tcp_udp_src_range_dst_ports_op) == 0, true) ? null : [for p in og.tcp_udp_src_range_dst_ports_op : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          operator     = p.operator
          dst_port     = tostring(p.dst_port)
        }]
        tcp_udp_src_range_dst_port_list = try(length(og.tcp_udp_src_range_dst_port_list) == 0, true) ? null : [for p in og.tcp_udp_src_range_dst_port_list : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          dst_port     = tostring(p.dst_port)
        }]
        tcp_udp_src_dst_range_port_list_op = try(length(og.tcp_udp_src_dst_range_ports_op) == 0, true) ? null : [for p in og.tcp_udp_src_dst_range_ports_op : {
          operator     = p.operator
          src_port     = tostring(p.src_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        tcp_udp_src_dst_range_port_list = try(length(og.tcp_udp_src_dst_range_port_list) == 0, true) ? null : [for p in og.tcp_udp_src_dst_range_port_list : {
          src_port     = tostring(p.src_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
        tcp_udp_src_range_dst_range_port_list = try(length(og.tcp_udp_src_range_dst_range_port_list) == 0, true) ? null : [for p in og.tcp_udp_src_range_dst_range_port_list : {
          src_min_port = tostring(p.src_min_port)
          src_max_port = tostring(p.src_max_port)
          dst_min_port = tostring(p.dst_min_port)
          dst_max_port = tostring(p.dst_max_port)
        }]
      }]
    } if try(length(local.device_config[device.name].object_groups_fqdn) > 0, false) || try(length(local.device_config[device.name].object_groups_network) > 0, false) || try(length(local.device_config[device.name].object_groups_service) > 0, false)
  }
}

resource "iosxe_object_group" "object_group" {
  for_each = local.object_groups
  device   = each.value.device

  fqdn    = each.value.fqdn
  network = each.value.network
  service = each.value.service
}
