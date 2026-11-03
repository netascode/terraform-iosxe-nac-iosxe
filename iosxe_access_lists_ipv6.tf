locals {
  access_lists_ipv6 = flatten([
    for device in local.devices : [
      for acl in try(local.device_config[device.name].access_lists.ipv6, []) : {
        key    = format("%s/%s", device.name, acl.name)
        device = device.name
        name   = try(acl.name, null)
        entries = try(length(acl.entries) == 0, true) ? null : [for e in acl.entries : {
          sequence                      = try(e.sequence, null)
          remark                        = try(e.remark, null)
          ace_rule_action               = try(e.action, null)
          ace_rule_protocol             = try(e.protocol, null)
          service_object_group          = try(e.service_object_group, null)
          source_any                    = try(e.source.any, null)
          source_host                   = try(e.source.host, null)
          source_prefix                 = try(e.source.prefix, null)
          source_address                = try(e.source.address, null)
          source_wildcard_bits          = try(e.source.wildcard_bits, null)
          source_object_group           = try(e.source.object_group, null)
          source_fqdn_group             = try(e.source.fqdn_group, null)
          source_port_equal             = try(e.source.port_type, null) == "equal" ? try(e.source.port, null) : null
          source_port_equal_2           = try(e.source.additional_equal_ports[0], null)
          source_port_equal_3           = try(e.source.additional_equal_ports[1], null)
          source_port_equal_4           = try(e.source.additional_equal_ports[2], null)
          source_port_equal_5           = try(e.source.additional_equal_ports[3], null)
          source_port_equal_6           = try(e.source.additional_equal_ports[4], null)
          source_port_equal_7           = try(e.source.additional_equal_ports[5], null)
          source_port_equal_8           = try(e.source.additional_equal_ports[6], null)
          source_port_equal_9           = try(e.source.additional_equal_ports[7], null)
          source_port_equal_10          = try(e.source.additional_equal_ports[8], null)
          source_port_greater_than      = try(e.source.port_type, null) == "greater_than" ? try(e.source.port, null) : null
          source_port_lesser_than       = try(e.source.port_type, null) == "lesser_than" ? try(e.source.port, null) : null
          source_port_range_from        = try(e.source.port_type, null) == "range" ? try(e.source.port_range_from, null) : null
          source_port_range_to          = try(e.source.port_type, null) == "range" ? try(e.source.port_range_to, null) : null
          destination_any               = try(e.destination.any, null)
          destination_host              = try(e.destination.host, null)
          destination_prefix            = try(e.destination.prefix, null)
          destination_address           = try(e.destination.address, null)
          destination_wildcard_bits     = try(e.destination.wildcard_bits, null)
          destination_object_group      = try(e.destination.object_group, null)
          destination_fqdn_group        = try(e.destination.fqdn_group, null)
          destination_port_equal        = try(e.destination.port_type, null) == "equal" ? try(e.destination.port, null) : null
          destination_port_equal_2      = try(e.destination.additional_equal_ports[0], null)
          destination_port_equal_3      = try(e.destination.additional_equal_ports[1], null)
          destination_port_equal_4      = try(e.destination.additional_equal_ports[2], null)
          destination_port_equal_5      = try(e.destination.additional_equal_ports[3], null)
          destination_port_equal_6      = try(e.destination.additional_equal_ports[4], null)
          destination_port_equal_7      = try(e.destination.additional_equal_ports[5], null)
          destination_port_equal_8      = try(e.destination.additional_equal_ports[6], null)
          destination_port_equal_9      = try(e.destination.additional_equal_ports[7], null)
          destination_port_equal_10     = try(e.destination.additional_equal_ports[8], null)
          destination_port_greater_than = try(e.destination.port_type, null) == "greater_than" ? try(e.destination.port, null) : null
          destination_port_lesser_than  = try(e.destination.port_type, null) == "lesser_than" ? try(e.destination.port, null) : null
          destination_port_range_from   = try(e.destination.port_type, null) == "range" ? try(e.destination.port_range_from, null) : null
          destination_port_range_to     = try(e.destination.port_type, null) == "range" ? try(e.destination.port_range_to, null) : null
          ack                           = contains(try(e.tcp_flags, []), "ack") ? true : try(e.ack, null)
          fin                           = contains(try(e.tcp_flags, []), "fin") ? true : try(e.fin, null)
          psh                           = contains(try(e.tcp_flags, []), "psh") ? true : try(e.psh, null)
          rst                           = contains(try(e.tcp_flags, []), "rst") ? true : try(e.rst, null)
          syn                           = contains(try(e.tcp_flags, []), "syn") ? true : try(e.syn, null)
          urg                           = contains(try(e.tcp_flags, []), "urg") ? true : try(e.urg, null)
          established                   = try(e.established, null)
          dscp                          = try(e.dscp, null)
          fragments                     = try(e.fragments, null)
          icmp_named_msg_type           = can(tonumber(try(e.icmp_message_type, ""))) ? null : try(e.icmp_message_type, null)
          icmp_msg_type                 = can(tonumber(try(e.icmp_message_type, ""))) ? try(e.icmp_message_type, null) : null
          icmp_msg_code                 = can(tonumber(try(e.icmp_message_type, ""))) ? try(e.icmp_message_code, null) : null
          log                           = try(e.log, null)
          log_input                     = try(e.log_input, null)
        }]
      }
    ]
  ])
}

resource "iosxe_access_list_ipv6" "access_list_ipv6" {
  for_each = { for e in local.access_lists_ipv6 : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries

  depends_on = [iosxe_object_group.object_group]
}
