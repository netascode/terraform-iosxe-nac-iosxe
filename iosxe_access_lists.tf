locals {
  access_lists_standard = flatten([
    for device in local.devices : [
      for acl in try(local.device_config[device.name].access_lists.standard, []) : {
        key    = format("%s/%s", device.name, acl.name)
        device = device.name
        name   = try(acl.name, null)
        entries = try(length(acl.entries) == 0, true) ? null : [for e in acl.entries : {
          sequence           = try(e.sequence, null)
          remark             = try(e.remark, null)
          deny_prefix        = try(e.action, null) == "deny" ? try(e.prefix, null) : null
          deny_prefix_mask   = try(e.action, null) == "deny" ? try(e.prefix_mask, null) : null
          deny_any           = try(e.action, null) == "deny" ? try(e.any, false) : null
          deny_host          = try(e.action, null) == "deny" ? try(e.host, null) : null
          deny_log           = try(e.action, null) == "deny" ? try(e.log, false) : null
          permit_prefix      = try(e.action, null) == "permit" ? try(e.prefix, null) : null
          permit_prefix_mask = try(e.action, null) == "permit" ? try(e.prefix_mask, null) : null
          permit_any         = try(e.action, null) == "permit" ? try(e.any, false) : null
          permit_host        = try(e.action, null) == "permit" ? try(e.host, null) : null
          permit_log         = try(e.action, null) == "permit" ? try(e.log, false) : null
        }]
      }
    ]
  ])
}

resource "iosxe_access_list_standard" "access_list_standard" {
  for_each = { for e in local.access_lists_standard : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries
}

locals {
  access_lists_extended = flatten([
    for device in local.devices : [
      for acl in try(local.device_config[device.name].access_lists.extended, []) : {
        key    = format("%s/%s", device.name, acl.name)
        device = device.name
        name   = try(acl.name, null)
        entries = try(length(acl.entries) == 0, true) ? null : [for e in acl.entries : {
          sequence                      = try(e.sequence, null)
          remark                        = try(e.remark, null)
          ace_rule_action               = try(e.action, null)
          ace_rule_protocol             = try(e.protocol, null)
          service_object_group          = try(e.service_object_group, null)
          source_prefix                 = try(e.source.prefix, null)
          source_prefix_mask            = try(e.source.prefix_mask, null)
          source_any                    = try(e.source.any, null)
          source_host                   = try(e.source.host, null)
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
          destination_prefix            = try(e.destination.prefix, null)
          destination_prefix_mask       = try(e.destination.prefix_mask, null)
          destination_any               = try(e.destination.any, null)
          destination_host              = try(e.destination.host, null)
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
          precedence                    = try(e.precedence, null)
          tos                           = try(e.tos, null)
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

resource "iosxe_access_list_extended" "access_list_extended" {
  for_each = { for e in local.access_lists_extended : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries
}

locals {
  as_path_access_lists = flatten([
    for device in local.devices : [
      for acl in try(local.device_config[device.name].access_lists.as_path, []) : {
        key    = format("%s/%s", device.name, acl.number)
        device = device.name
        name   = try(acl.number, null)
        entries = try(length(acl.entries) == 0, true) ? null : [for e in acl.entries : {
          action = try(e.action, null)
          regex  = try(e.regex, null)
        }]
      }
    ]
  ])
}

resource "iosxe_as_path_access_list" "as_path_access_list" {
  for_each = { for e in local.as_path_access_lists : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries
}

locals {
  role_based_access_lists = flatten([
    for device in local.devices : [
      for acl in try(local.device_config[device.name].access_lists.role_based, []) : {
        key    = format("%s/%s", device.name, acl.name)
        device = device.name
        name   = try(acl.name, null)
        entries = try(length(acl.entries) == 0, true) ? null : [for e in acl.entries : {
          sequence           = try(e.sequence, null)
          remark             = try(e.remark, null)
          ace_rule_action    = try(e.action, null)
          ace_rule_protocol  = try(e.protocol, null)
          ack                = contains(try(e.tcp_flags, []), "ack") ? true : try(e.ack, null)
          fin                = contains(try(e.tcp_flags, []), "fin") ? true : try(e.fin, null)
          psh                = contains(try(e.tcp_flags, []), "psh") ? true : try(e.psh, null)
          rst                = contains(try(e.tcp_flags, []), "rst") ? true : try(e.rst, null)
          syn                = contains(try(e.tcp_flags, []), "syn") ? true : try(e.syn, null)
          urg                = contains(try(e.tcp_flags, []), "urg") ? true : try(e.urg, null)
          established        = try(e.established, null)
          fragments          = try(e.fragments, null)
          dscp               = try(e.dscp, null)
          precedence         = try(e.precedence, null)
          tos                = try(e.tos, null)
          option             = try(e.option, null)
          time_range         = try(e.time_range, null)
          log                = try(e.log, null)
          log_input          = try(e.log_input, null)
          match_all_plusack  = contains(try(e.match_all, []), "+ack") ? true : null
          match_all_plusfin  = contains(try(e.match_all, []), "+fin") ? true : null
          match_all_pluspsh  = contains(try(e.match_all, []), "+psh") ? true : null
          match_all_plusrst  = contains(try(e.match_all, []), "+rst") ? true : null
          match_all_plussyn  = contains(try(e.match_all, []), "+syn") ? true : null
          match_all_plusurg  = contains(try(e.match_all, []), "+urg") ? true : null
          match_all_minusack = contains(try(e.match_all, []), "-ack") ? true : null
          match_all_minusfin = contains(try(e.match_all, []), "-fin") ? true : null
          match_all_minuspsh = contains(try(e.match_all, []), "-psh") ? true : null
          match_all_minusrst = contains(try(e.match_all, []), "-rst") ? true : null
          match_all_minussyn = contains(try(e.match_all, []), "-syn") ? true : null
          match_all_minusurg = contains(try(e.match_all, []), "-urg") ? true : null
          match_any_plusack  = contains(try(e.match_any, []), "+ack") ? true : null
          match_any_plusfin  = contains(try(e.match_any, []), "+fin") ? true : null
          match_any_pluspsh  = contains(try(e.match_any, []), "+psh") ? true : null
          match_any_plusrst  = contains(try(e.match_any, []), "+rst") ? true : null
          match_any_plussyn  = contains(try(e.match_any, []), "+syn") ? true : null
          match_any_plusurg  = contains(try(e.match_any, []), "+urg") ? true : null
          match_any_minusack = contains(try(e.match_any, []), "-ack") ? true : null
          match_any_minusfin = contains(try(e.match_any, []), "-fin") ? true : null
          match_any_minuspsh = contains(try(e.match_any, []), "-psh") ? true : null
          match_any_minusrst = contains(try(e.match_any, []), "-rst") ? true : null
          match_any_minussyn = contains(try(e.match_any, []), "-syn") ? true : null
          match_any_minusurg = contains(try(e.match_any, []), "-urg") ? true : null
        }]
      }
    ]
  ])
}

resource "iosxe_access_list_role_based" "access_list_role_based" {
  for_each = { for e in local.role_based_access_lists : e.key => e }
  device   = each.value.device

  name    = each.value.name
  entries = each.value.entries
}
