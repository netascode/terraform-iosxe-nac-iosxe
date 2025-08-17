locals {
  access_lists_standard = flatten([
    for device in local.devices : [
      for acl in try(local.device_config[device.name].access_lists.standard, []) : {
        key    = format("%s/%s", device.name, acl.name)
        device = device.name
        name   = try(acl.name, null)
        entries = [for e in try(acl.entries, []) : {
          sequence           = try(e.sequence, local.defaults.iosxe.configuration.access_lists.standard.entries.sequence, null)
          remark             = try(e.remark, local.defaults.iosxe.configuration.access_lists.standard.entries.remark, null)
          deny_prefix        = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "deny" ? try(e.prefix, null) : null
          deny_prefix_mask   = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "deny" ? try(e.prefix_mask, null) : null
          deny_any           = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "deny" ? try(e.any, false) : null
          deny_host          = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "deny" ? try(e.host, null) : null
          deny_log           = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "deny" ? try(e.log, false) : null
          permit_prefix      = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "permit" ? try(e.prefix, null) : null
          permit_prefix_mask = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "permit" ? try(e.prefix_mask, null) : null
          permit_any         = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "permit" ? try(e.any, false) : null
          permit_host        = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "permit" ? try(e.host, null) : null
          permit_log         = try(e.action, local.defaults.iosxe.configuration.access_lists.standard.entries.action) == "permit" ? try(e.log, false) : null
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
        entries = [for e in try(acl.entries, []) : {
          sequence                      = try(e.sequence, local.defaults.iosxe.configuration.access_lists.extended.entries.sequence, null)
          remark                        = try(e.remark, local.defaults.iosxe.configuration.access_lists.extended.entries.remark, null)
          ace_rule_action               = try(e.action, local.defaults.iosxe.configuration.access_lists.extended.entries.action)
          ace_rule_protocol             = try(e.protocol, local.defaults.iosxe.configuration.access_lists.extended.entries.protocol)
          service_object_group          = try(e.service_object_group, local.defaults.iosxe.configuration.access_lists.extended.entries.service_object_group, null)
          source_prefix                 = try(e.source.prefix, local.defaults.iosxe.configuration.access_lists.extended.entries.source.prefix, null)
          source_prefix_mask            = try(e.source.prefix_mask, local.defaults.iosxe.configuration.access_lists.extended.entries.source.prefix_mask, null)
          source_any                    = try(e.source.any, local.defaults.iosxe.configuration.access_lists.extended.entries.source.any, null)
          source_host                   = try(e.source.host, local.defaults.iosxe.configuration.access_lists.extended.entries.source.host, null)
          source_object_group           = try(e.source.object_group, local.defaults.iosxe.configuration.access_lists.extended.entries.source.object_group, null)
          source_port_equal             = try(e.source.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.source.port_type, null) == "equal" ? try(e.source.port, null) : null
          source_port_greater_than      = try(e.source.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.source.port_type, null) == "greater_than" ? try(e.source.port, null) : null
          source_port_lesser_than       = try(e.source.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.source.port_type, null) == "lesser_than" ? try(e.source.port, null) : null
          source_port_range_from        = try(e.source.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.source.port_type, null) == "range" ? try(e.source.port_range_from, null) : null
          source_port_range_to          = try(e.source.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.source.port_type, null) == "range" ? try(e.source.port_range_to, null) : null
          destination_prefix            = try(e.destination.prefix, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.prefix, null)
          destination_prefix_mask       = try(e.destination.prefix_mask, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.prefix_mask, null)
          destination_any               = try(e.destination.any, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.any, null)
          destination_host              = try(e.destination.host, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.host, null)
          destination_object_group      = try(e.destination.object_group, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.object_group, null)
          destination_port_equal        = try(e.destination.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.port_type, null) == "equal" ? try(e.destination.port, null) : null
          destination_port_greater_than = try(e.destination.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.port_type, null) == "greater_than" ? try(e.destination.port, null) : null
          destination_port_lesser_than  = try(e.destination.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.port_type, null) == "lesser_than" ? try(e.destination.port, null) : null
          destination_port_range_from   = try(e.destination.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.port_type, null) == "range" ? try(e.destination.port_range_from, null) : null
          destination_port_range_to     = try(e.destination.port_type, local.defaults.iosxe.configuration.access_lists.extended.entries.destination.port_type, null) == "range" ? try(e.destination.port_range_to, null) : null
          ack                           = try(e.ack, local.defaults.iosxe.configuration.access_lists.extended.entries.ack, null)
          fin                           = try(e.fin, local.defaults.iosxe.configuration.access_lists.extended.entries.fin, null)
          psh                           = try(e.psh, local.defaults.iosxe.configuration.access_lists.extended.entries.psh, null)
          rst                           = try(e.rst, local.defaults.iosxe.configuration.access_lists.extended.entries.rst, null)
          syn                           = try(e.syn, local.defaults.iosxe.configuration.access_lists.extended.entries.syn, null)
          urg                           = try(e.urg, local.defaults.iosxe.configuration.access_lists.extended.entries.urg, null)
          established                   = try(e.established, local.defaults.iosxe.configuration.access_lists.extended.entries.established, null)
          dscp                          = try(e.dscp, local.defaults.iosxe.configuration.access_lists.extended.entries.dscp, null)
          fragments                     = try(e.fragments, local.defaults.iosxe.configuration.access_lists.extended.entries.fragments, null)
          precedence                    = try(e.precedence, local.defaults.iosxe.configuration.access_lists.extended.entries.precedence, null)
          tos                           = try(e.tos, local.defaults.iosxe.configuration.access_lists.extended.entries.tos, null)
          log                           = try(e.log, local.defaults.iosxe.configuration.access_lists.extended.entries.log, null)
          log_input                     = try(e.log_input, local.defaults.iosxe.configuration.access_lists.extended.entries.log_input, null)
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
        entries = [for e in try(acl.entries, []) : {
          action = try(e.action, local.defaults.iosxe.configuration.access_lists.as_path.entries.action, null)
          regex  = try(e.regex, local.defaults.iosxe.configuration.access_lists.as_path.entries.regex, null)
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
