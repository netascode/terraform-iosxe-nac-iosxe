locals {
  class_maps = flatten([
    for device in local.devices : [
      for class_map in try(local.device_config[device.name].class_maps, []) : {
        key                                     = format("%s/%s", device.name, class_map.name)
        device                                  = device.name
        name                                    = try(class_map.name, null)
        type                                    = try(class_map.type, local.defaults.iosxe.configuration.class_maps.type, null)
        subscriber                              = try(class_map.subscriber, local.defaults.iosxe.configuration.class_maps.subscriber, null)
        prematch                                = try(class_map.prematch, local.defaults.iosxe.configuration.class_maps.prematch, null)
        match_authorization_status_authorized   = try(class_map.match.authorization_status_authorized, local.defaults.iosxe.configuration.class_maps.match.authorization_status_authorized, null)
        match_result_type_aaa_timeout           = try(class_map.match.result_type_aaa_timeout, local.defaults.iosxe.configuration.class_maps.match.result_type_aaa_timeout, null)
        match_authorization_status_unauthorized = try(class_map.match.authorization_status_unauthorized, local.defaults.iosxe.configuration.class_maps.match.authorization_status_unauthorized, null)
        match_activated_service_templates = [for template in try(class_map.match.activated_service_templates, local.defaults.iosxe.configuration.class_maps.match.activated_service_templates, []) : {
          service_name = try(template.service_name, local.defaults.iosxe.configuration.class_maps.match.activated_service_templates.service_name, null)
        }]
        match_authorizing_method_priority_greater_than = try(class_map.match.authorizing_method_priority_greater_than, local.defaults.iosxe.configuration.class_maps.match.authorizing_method_priority_greater_than, null)
        match_method_dot1x                             = try(class_map.match.method_dot1x, local.defaults.iosxe.configuration.class_maps.match.method_dot1x, null)
        match_result_type_method_dot1x_authoritative   = try(class_map.match.result_type_method_dot1x_authoritative, local.defaults.iosxe.configuration.class_maps.match.result_type_method_dot1x_authoritative, null)
        match_result_type_method_dot1x_agent_not_found = try(class_map.match.result_type_method_dot1x_agent_not_found, local.defaults.iosxe.configuration.class_maps.match.result_type_method_dot1x_agent_not_found, null)
        match_result_type_method_dot1x_method_timeout  = try(class_map.match.result_type_method_dot1x_method_timeout, local.defaults.iosxe.configuration.class_maps.match.result_type_method_dot1x_method_timeout, null)
        match_method_mab                               = try(class_map.match.method_mab, local.defaults.iosxe.configuration.class_maps.match.method_mab, null)
        match_result_type_method_mab_authoritative     = try(class_map.match.result_type_method_mab_authoritative, local.defaults.iosxe.configuration.class_maps.match.result_type_method_mab_authoritative, null)
        match_dscp                                     = try(class_map.match.dscp, local.defaults.iosxe.configuration.class_maps.match.dscp, null)
        description                                    = try(class_map.description, local.defaults.iosxe.configuration.class_maps.description, null)
      }
    ]
  ])
}

resource "iosxe_class_map" "class_map" {
  for_each = { for e in local.class_maps : e.key => e }
  device   = each.value.device

  name                                           = each.value.name
  type                                           = each.value.type
  subscriber                                     = each.value.subscriber
  prematch                                       = each.value.prematch
  match_authorization_status_authorized          = each.value.match_authorization_status_authorized
  match_result_type_aaa_timeout                  = each.value.match_result_type_aaa_timeout
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
  description                                    = each.value.description
}

locals {
  policy_maps = flatten([
    for device in local.devices : [
      for policy_map in try(local.device_config[device.name].policy_maps, []) : {
        key         = format("%s/%s", device.name, policy_map.name)
        device      = device.name
        name        = try(policy_map.name, null)
        type        = try(policy_map.type, local.defaults.iosxe.configuration.policy_maps.type, null)
        subscriber  = try(policy_map.subscriber, local.defaults.iosxe.configuration.policy_maps.subscriber, null)
        description = try(policy_map.description, local.defaults.iosxe.configuration.policy_maps.description, null)
        classes = [for class in try(policy_map.classes, local.defaults.iosxe.configuration.policy_maps.classes, []) : {
          name = try(class.name, local.defaults.iosxe.configuration.policy_maps.classes.name, null)
          actions = [for action in try(class.actions, local.defaults.iosxe.configuration.policy_maps.classes.actions, []) : {
            type                                      = try(action.type, local.defaults.iosxe.configuration.policy_maps.classes.actions.type, null)
            bandwidth_bits                            = try(action.bandwidth_bits, local.defaults.iosxe.configuration.policy_maps.classes.actions.bandwidth_bits, null)
            bandwidth_percent                         = try(action.bandwidth_percent, local.defaults.iosxe.configuration.policy_maps.classes.actions.bandwidth_percent, null)
            bandwidth_remaining_option                = try(action.bandwidth_remaining_option, local.defaults.iosxe.configuration.policy_maps.classes.actions.bandwidth_remaining_option, null)
            bandwidth_remaining_percent               = try(action.bandwidth_remaining_percent, local.defaults.iosxe.configuration.policy_maps.classes.actions.bandwidth_remaining_percent, null)
            bandwidth_remaining_ratio                 = try(action.bandwidth_remaining_ratio, local.defaults.iosxe.configuration.policy_maps.classes.actions.bandwidth_remaining_ratio, null)
            priority_level                            = try(action.priority_level, local.defaults.iosxe.configuration.policy_maps.classes.actions.priority_level, null)
            priority_burst                            = try(action.priority_burst, local.defaults.iosxe.configuration.policy_maps.classes.actions.priority_burst, null)
            queue_limit                               = try(action.queue_limit, local.defaults.iosxe.configuration.policy_maps.classes.actions.queue_limit, null)
            queue_limit_type                          = try(action.queue_limit_type, local.defaults.iosxe.configuration.policy_maps.classes.actions.queue_limit_type, null)
            shape_average_bit_rate                    = try(action.shape_average_bit_rate, local.defaults.iosxe.configuration.policy_maps.classes.actions.shape_average_bit_rate, null)
            shape_average_bits_per_interval_excess    = try(action.shape_average_bits_per_interval_excess, local.defaults.iosxe.configuration.policy_maps.classes.actions.shape_average_bits_per_interval_excess, null)
            shape_average_bits_per_interval_sustained = try(action.shape_average_bits_per_interval_sustained, local.defaults.iosxe.configuration.policy_maps.classes.actions.shape_average_bits_per_interval_sustained, null)
            shape_average_burst_size_sustained        = try(action.shape_average_burst_size_sustained, local.defaults.iosxe.configuration.policy_maps.classes.actions.shape_average_burst_size_sustained, null)
            shape_average_ms                          = try(action.shape_average_ms, local.defaults.iosxe.configuration.policy_maps.classes.actions.shape_average_ms, null)
            shape_average_percent                     = try(action.shape_average_percent, local.defaults.iosxe.configuration.policy_maps.classes.actions.shape_average_percent, null)
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
}

locals {
  policy_map_events = flatten([
    for device in local.devices : [
      for policy_map in try(local.device_config[device.name].policy_maps, []) : [
        for event in try(policy_map.events, []) : {
          key        = format("%s/%s/%s", device.name, policy_map.name, event.event_type)
          device     = device.name
          name       = try(policy_map.name, null)
          event_type = try(event.event_type, null)
          match_type = try(event.match_type, local.defaults.iosxe.configuration.policy_maps.events.match_type, null)
          class_numbers = [for class in try(event.classes, local.defaults.iosxe.configuration.policy_maps.events.classes, []) : {
            number         = try(class.number, local.defaults.iosxe.configuration.policy_maps.events.classes.number, null)
            class          = try(class.class, local.defaults.iosxe.configuration.policy_maps.events.classes.class, null)
            execution_type = try(class.execution_type, local.defaults.iosxe.configuration.policy_maps.events.classes.execution_type, null)
            action_numbers = [for action in try(class.actions, local.defaults.iosxe.configuration.policy_maps.events.classes.actions, []) : {
              number                                            = try(action.number, local.defaults.iosxe.configuration.policy_maps.events.actions.number, null)
              pause_reauthentication                            = try(action.pause_reauthentication, local.defaults.iosxe.configuration.policy_maps.events.actions.pause_reauthentication, null)
              authorize                                         = try(action.authorize, local.defaults.iosxe.configuration.policy_maps.events.actions.authorize, null)
              terminate_config                                  = try(action.terminate_config, local.defaults.iosxe.configuration.policy_maps.events.actions.terminate_config, null)
              activate_service_template_config_service_template = try(action.activate_service_template_config_service_template, local.defaults.iosxe.configuration.policy_maps.events.actions.activate_service_template_config_service_template, null)
              activate_service_template_config_aaa_list         = try(action.activate_service_template_config_aaa_list, local.defaults.iosxe.configuration.policy_maps.events.actions.activate_service_template_config_aaa_list, null)
              activate_service_template_config_precedence       = try(action.activate_service_template_config_precedence, local.defaults.iosxe.configuration.policy_maps.events.actions.activate_service_template_config_precedence, null)
              activate_service_template_config_replace_all      = try(action.activate_service_template_config_replace_all, local.defaults.iosxe.configuration.policy_maps.events.actions.activate_service_template_config_replace_all, null)
              activate_interface_template                       = try(action.activate_interface_template, local.defaults.iosxe.configuration.policy_maps.events.actions.activate_interface_template, null)
              activate_policy_type_control_subscriber           = try(action.activate_policy_type_control_subscriber, local.defaults.iosxe.configuration.policy_maps.events.actions.activate_policy_type_control_subscriber, null)
              deactivate_interface_template                     = try(action.deactivate_interface_template, local.defaults.iosxe.configuration.policy_maps.events.actions.deactivate_interface_template, null)
              deactivate_service_template                       = try(action.deactivate_service_template, local.defaults.iosxe.configuration.policy_maps.events.actions.deactivate_service_template, null)
              deactivate_policy_type_control_subscriber         = try(action.deactivate_policy_type_control_subscriber, local.defaults.iosxe.configuration.policy_maps.events.actions.deactivate_policy_type_control_subscriber, null)
              authenticate_using_method                         = try(action.authenticate_using_method, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_method, null)
              authenticate_using_retries                        = try(action.authenticate_using_retries, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_retries, null)
              authenticate_using_retry_time                     = try(action.authenticate_using_retry_time, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_retry_time, null)
              authenticate_using_priority                       = try(action.authenticate_using_priority, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_priority, null)
              authenticate_using_aaa_authc_list                 = try(action.authenticate_using_aaa_authc_list, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_aaa_authc_list, null)
              authenticate_using_aaa_authz_list                 = try(action.authenticate_using_aaa_authz_list, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_aaa_authz_list, null)
              authenticate_using_both                           = try(action.authenticate_using_both, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_both, null)
              authenticate_using_parameter_map                  = try(action.authenticate_using_parameter_map, local.defaults.iosxe.configuration.policy_maps.events.actions.authenticate_using_parameter_map, null)
              replace                                           = try(action.replace, local.defaults.iosxe.configuration.policy_maps.events.actions.replace, null)
              restrict                                          = try(action.restrict, local.defaults.iosxe.configuration.policy_maps.events.actions.restrict, null)
              clear_session                                     = try(action.clear_session, local.defaults.iosxe.configuration.policy_maps.events.actions.clear_session, null)
              clear_authenticated_data_hosts_on_port            = try(action.clear_authenticated_data_hosts_on_port, local.defaults.iosxe.configuration.policy_maps.events.actions.clear_authenticated_data_hosts_on_port, null)
              protect                                           = try(action.protect, local.defaults.iosxe.configuration.policy_maps.events.actions.protect, null)
              err_disable                                       = try(action.err_disable, local.defaults.iosxe.configuration.policy_maps.events.actions.err_disable, null)
              resume_reauthentication                           = try(action.resume_reauthentication, local.defaults.iosxe.configuration.policy_maps.events.actions.resume_reauthentication, null)
              authentication_restart                            = try(action.authentication_restart, local.defaults.iosxe.configuration.policy_maps.events.actions.authentication_restart, null)
              set_domain                                        = try(action.set_domain, local.defaults.iosxe.configuration.policy_maps.events.actions.set_domain, null)
              unauthorize                                       = try(action.unauthorize, local.defaults.iosxe.configuration.policy_maps.events.actions.unauthorize, null)
              notify                                            = try(action.notify, local.defaults.iosxe.configuration.policy_maps.events.actions.notify, null)
              set_timer_name                                    = try(action.set_timer_name, local.defaults.iosxe.configuration.policy_maps.events.actions.set_timer_name, null)
              set_timer_value                                   = try(action.set_timer_value, local.defaults.iosxe.configuration.policy_maps.events.actions.set_timer_value, null)
              map_attribute_to_service_table                    = try(action.map_attribute_to_service_table, local.defaults.iosxe.configuration.policy_maps.events.actions.map_attribute_to_service_table, null)
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
}
