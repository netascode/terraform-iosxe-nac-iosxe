locals {
  class_maps = flatten([
    for device in local.devices : [
      for class_map in try(local.device_config[device.name].policy.class_maps, []) : {
        key                                     = format("%s/%s", device.name, class_map.name)
        device                                  = device.name
        name                                    = try(class_map.name, null)
        type                                    = try(class_map.type, null)
        subscriber                              = try(class_map.subscriber, null)
        prematch                                = try(class_map.prematch, null)
        match_authorization_status_authorized   = try(class_map.match.authorization_status_authorized, null)
        match_result_type_aaa_timeout           = try(class_map.match.result_type_aaa_timeout, null)
        match_result_type_success               = try(class_map.match.result_type_success, null)
        match_authorization_status_unauthorized = try(class_map.match.authorization_status_unauthorized, null)
        match_activated_service_templates = try(length(class_map.match.activated_service_templates) == 0, true) ? null : [for template in class_map.match.activated_service_templates : {
          service_name = try(template.service_name, null)
        }]
        match_authorizing_method_priority_greater_than = can(class_map.match.authorizing_method_priority_greater_than) ? sort(class_map.match.authorizing_method_priority_greater_than) : null
        match_method_dot1x                             = try(class_map.match.method_dot1x, null)
        match_result_type_method_dot1x_authoritative   = try(class_map.match.result_type_method_dot1x_authoritative, null)
        match_result_type_method_dot1x_agent_not_found = try(class_map.match.result_type_method_dot1x_agent_not_found, null)
        match_result_type_method_dot1x_method_timeout  = try(class_map.match.result_type_method_dot1x_method_timeout, null)
        match_method_mab                               = try(class_map.match.method_mab, null)
        match_result_type_method_mab_authoritative     = try(class_map.match.result_type_method_mab_authoritative, null)
        match_dscp                                     = can(class_map.match.dscp) ? sort(class_map.match.dscp) : null
        match_access_group_index_legacy                = try(tostring([for v in class_map.match.access_groups_legacy : v if can(tonumber(v))][0]), null)
        match_access_group_index_list = try(
          (length([for x in class_map.match.access_groups : x if can(tonumber(x))]) > 0
            ? [for v in sort([for x in class_map.match.access_groups : format("%05d", tonumber(x)) if can(tonumber(x))]) : tostring(tonumber(v))]
          : null),
          null
        )
        match_access_group_name = try(
          (length([for v in class_map.match.access_groups : v if !can(tonumber(v))]) > 0
            ? sort([for v in class_map.match.access_groups : tostring(v) if !can(tonumber(v))])
          : null),
          (length([for v in class_map.match.access_groups_legacy : v if !can(tonumber(v))]) > 0
            ? sort([for v in class_map.match.access_groups_legacy : tostring(v) if !can(tonumber(v))])
          : null),
          null
        )
        match_ip_dscp       = can(class_map.match.ip_dscp) ? sort(class_map.match.ip_dscp) : null
        match_ip_precedence = can(class_map.match.ip_precedence) ? sort(class_map.match.ip_precedence) : null
        match_protocol = try(length(class_map.match.protocols) == 0, true) ? null : [for protocol in class_map.match.protocols : {
          protocols = protocol
        }]
        match_class_map = can(class_map.match.class_maps) ? sort(class_map.match.class_maps) : null
        description     = try(class_map.description, null)
      }
    ]
  ])
}

resource "iosxe_class_map" "class_map" {
  for_each = { for e in local.class_maps : e.key => e if e.match_class_map == null }
  device   = each.value.device

  name                                           = each.value.name
  type                                           = each.value.type
  subscriber                                     = each.value.subscriber
  prematch                                       = each.value.prematch
  match_authorization_status_authorized          = each.value.match_authorization_status_authorized
  match_result_type_aaa_timeout                  = each.value.match_result_type_aaa_timeout
  match_result_type_success                      = each.value.match_result_type_success
  match_authorization_status_unauthorized        = each.value.match_authorization_status_unauthorized
  match_activated_service_templates              = each.value.match_activated_service_templates
  match_authorizing_method_priority_greater_than = each.value.match_authorizing_method_priority_greater_than
  match_method_dot1x                             = each.value.match_method_dot1x
  match_result_type_method_dot1x_authoritative   = each.value.match_result_type_method_dot1x_authoritative
  match_result_type_method_dot1x_agent_not_found = each.value.match_result_type_method_dot1x_agent_not_found
  match_result_type_method_dot1x_method_timeout  = each.value.match_result_type_method_dot1x_method_timeout
  match_method_mab                               = each.value.match_method_mab
  match_result_type_method_mab_authoritative     = each.value.match_result_type_method_mab_authoritative
  match_dscp                                     = each.value.match_dscp
  match_access_group_index_legacy                = each.value.match_access_group_index_legacy
  match_access_group_index_list                  = each.value.match_access_group_index_list
  match_access_group_name                        = each.value.match_access_group_name
  match_ip_dscp                                  = each.value.match_ip_dscp
  match_ip_precedence                            = each.value.match_ip_precedence
  match_protocol                                 = each.value.match_protocol
  match_class_map                                = each.value.match_class_map
  description                                    = each.value.description
}

resource "iosxe_class_map" "class_map_nested" {
  for_each = { for e in local.class_maps : e.key => e if e.match_class_map != null }
  device   = each.value.device

  name                                           = each.value.name
  type                                           = each.value.type
  subscriber                                     = each.value.subscriber
  prematch                                       = each.value.prematch
  match_authorization_status_authorized          = each.value.match_authorization_status_authorized
  match_result_type_aaa_timeout                  = each.value.match_result_type_aaa_timeout
  match_result_type_success                      = each.value.match_result_type_success
  match_authorization_status_unauthorized        = each.value.match_authorization_status_unauthorized
  match_activated_service_templates              = each.value.match_activated_service_templates
  match_authorizing_method_priority_greater_than = each.value.match_authorizing_method_priority_greater_than
  match_method_dot1x                             = each.value.match_method_dot1x
  match_result_type_method_dot1x_authoritative   = each.value.match_result_type_method_dot1x_authoritative
  match_result_type_method_dot1x_agent_not_found = each.value.match_result_type_method_dot1x_agent_not_found
  match_result_type_method_dot1x_method_timeout  = each.value.match_result_type_method_dot1x_method_timeout
  match_method_mab                               = each.value.match_method_mab
  match_result_type_method_mab_authoritative     = each.value.match_result_type_method_mab_authoritative
  match_dscp                                     = each.value.match_dscp
  match_access_group_index_legacy                = each.value.match_access_group_index_legacy
  match_access_group_index_list                  = each.value.match_access_group_index_list
  match_access_group_name                        = each.value.match_access_group_name
  match_ip_dscp                                  = each.value.match_ip_dscp
  match_ip_precedence                            = each.value.match_ip_precedence
  match_protocol                                 = each.value.match_protocol
  match_class_map                                = each.value.match_class_map
  description                                    = each.value.description

  depends_on = [
    iosxe_class_map.class_map
  ]
}

locals {
  policy_maps = flatten([
    for device in local.devices : [
      for policy_map in try(local.device_config[device.name].policy.policy_maps, []) : {
        key         = format("%s/%s", device.name, policy_map.name)
        device      = device.name
        name        = try(policy_map.name, null)
        type        = try(policy_map.type, null)
        subscriber  = try(policy_map.subscriber, null)
        description = try(policy_map.description, null)
        classes = try(length(policy_map.classes) == 0, true) ? null : [for class in policy_map.classes : {
          name                 = try(class.name, null)
          class_type           = try(class.type, null)
          policy_action        = try(class.action, null)
          policy_log           = try(class.log, null)
          policy_parameter_map = try(class.parameter_map, null)
          actions = try(length(class.actions) == 0, true) ? null : [for action in class.actions : {
            type                                      = try(action.type, null)
            bandwidth_bits                            = try(action.bandwidth_bits, null)
            bandwidth_percent                         = try(action.bandwidth_percent, null)
            bandwidth_remaining_option                = try(action.bandwidth_remaining_option, null)
            bandwidth_remaining_percent               = try(action.bandwidth_remaining_percent, null)
            bandwidth_remaining_ratio                 = try(action.bandwidth_remaining_ratio, null)
            priority_level                            = try(action.priority_level, null)
            priority_burst                            = try(action.priority_burst, null)
            queue_limit                               = try(action.queue_limit, null)
            queue_limit_type                          = try(action.queue_limit_type, null)
            shape_average_bit_rate                    = try(action.shape_average_bit_rate, null)
            shape_average_bits_per_interval_excess    = try(action.shape_average_bits_per_interval_excess, null)
            shape_average_bits_per_interval_sustained = try(action.shape_average_bits_per_interval_sustained, null)
            shape_average_burst_size_sustained        = try(action.shape_average_burst_size_sustained, null)
            shape_average_ms                          = try(action.shape_average_ms, null)
            shape_average_percent                     = try(action.shape_average_percent, null)
            police_target_bitrate_conform_transmit    = try(action.police_target_bitrate_conform_transmit, null)
            police_target_bitrate_exceed_transmit     = try(action.police_target_bitrate_exceed_transmit, null)
            police_target_bitrate                     = try(action.police_target_bitrate, null)
            police_target_bitrate_conform_burst_byte  = try(action.police_target_bitrate_conform_burst_byte, null)
            police_target_bitrate_excess_burst_byte   = try(action.police_target_bitrate_excess_burst_byte, null)
            police_target_bitrate_exceed_drop         = try(action.police_target_bitrate_exceed_drop, null)
            police_cir                                = try(action.police_cir, null)
            police_bc                                 = try(action.police_bc, null)
            police_be                                 = try(action.police_be, null)
            police_pir                                = try(action.police_pir, null)
            police_pir_be                             = try(action.police_pir_be, null)
            police_cir_conform_transmit               = try(action.police_cir_conform_transmit, null)
            police_cir_exceed_drop                    = try(action.police_cir_exceed_drop, null)
            police_rate_percent                       = try(action.police_rate_percent, null)
            queue_buffers_ratio                       = try(action.queue_buffers_ratio, null)
            set_dscp                                  = try(action.set_dscp, null)
            service_policy                            = try(action.service_policy, null)
          }]
        }]
      }
    ]
  ])
}

resource "iosxe_policy_map" "policy_map" {
  for_each = { for e in local.policy_maps : e.key => e }
  device   = each.value.device

  name        = each.value.name
  type        = each.value.type
  subscriber  = each.value.subscriber
  description = each.value.description
  classes     = each.value.classes

  depends_on = [
    iosxe_class_map.class_map,
    iosxe_class_map.class_map_nested,
    iosxe_parameter_map.parameter_map
  ]
}

locals {
  policy_map_events = flatten([
    for device in local.devices : [
      for policy_map in try(local.device_config[device.name].policy.policy_maps, []) : [
        for event in try(policy_map.events, []) : {
          key        = format("%s/%s/%s", device.name, policy_map.name, event.event_type)
          device     = device.name
          name       = try(policy_map.name, null)
          event_type = try(event.event_type, null)
          match_type = try(event.match_type, null)
          class_numbers = try(length(event.classes) == 0, true) ? null : [for class in event.classes : {
            number         = try(class.number, null)
            class          = try(class.class, null)
            execution_type = try(class.execution_type, null)
            action_numbers = try(length(class.actions) == 0, true) ? null : [for action in class.actions : {
              number                                            = try(action.number, null)
              pause_reauthentication                            = try(action.pause_reauthentication, null)
              authorize                                         = try(action.authorize, null)
              terminate_config                                  = try(action.terminate_config, null)
              activate_service_template_config_service_template = try(action.activate_service_template_config_service_template, null)
              activate_service_template_config_aaa_list         = try(action.activate_service_template_config_aaa_list, null)
              activate_service_template_config_precedence       = try(action.activate_service_template_config_precedence, null)
              activate_service_template_config_replace_all      = try(action.activate_service_template_config_replace_all, null)
              activate_interface_template                       = try(action.activate_interface_template, null)
              activate_policy_type_control_subscriber           = try(action.activate_policy_type_control_subscriber, null)
              deactivate_interface_template                     = try(action.deactivate_interface_template, null)
              deactivate_service_template                       = try(action.deactivate_service_template, null)
              deactivate_policy_type_control_subscriber         = try(action.deactivate_policy_type_control_subscriber, null)
              authenticate_using_method                         = try(action.authenticate_using_method, null)
              authenticate_using_retries                        = try(action.authenticate_using_retries, null)
              authenticate_using_retry_time                     = try(action.authenticate_using_retry_time, null)
              authenticate_using_priority                       = try(action.authenticate_using_priority, null)
              authenticate_using_aaa_config                     = try(action.authenticate_using_aaa_config, null)
              authenticate_using_authc_list                     = try(action.authenticate_using_authc_list, null)
              authenticate_using_authz_list                     = try(action.authenticate_using_authz_list, null)
              authenticate_using_aaa_authc_list_legacy          = try(action.authenticate_using_aaa_authc_list_legacy, null)
              authenticate_using_aaa_authz_list_legacy          = try(action.authenticate_using_aaa_authz_list_legacy, null)
              authenticate_using_both                           = try(action.authenticate_using_both, null)
              authenticate_using_parameter_map                  = try(action.authenticate_using_parameter_map, null)
              replace                                           = try(action.replace, null)
              restrict                                          = try(action.restrict, null)
              clear_session                                     = try(action.clear_session, null)
              clear_authenticated_data_hosts_on_port            = try(action.clear_authenticated_data_hosts_on_port, null)
              protect                                           = try(action.protect, null)
              err_disable                                       = try(action.err_disable, null)
              resume_reauthentication                           = try(action.resume_reauthentication, null)
              authentication_restart                            = try(action.authentication_restart, null)
              set_domain                                        = try(action.set_domain, null)
              unauthorize                                       = try(action.unauthorize, null)
              notify                                            = try(action.notify, null)
              set_timer_name                                    = try(action.set_timer_name, null)
              set_timer_value                                   = try(action.set_timer_value, null)
              map_attribute_to_service_table                    = try(action.map_attribute_to_service_table, null)
            }]
          }]
        }
      ]
    ]
  ])
}

resource "iosxe_policy_map_event" "policy_map_event" {
  for_each = { for e in local.policy_map_events : e.key => e }
  device   = each.value.device

  name          = each.value.name
  event_type    = each.value.event_type
  match_type    = each.value.match_type
  class_numbers = each.value.class_numbers

  depends_on = [
    iosxe_policy_map.policy_map
  ]
}
