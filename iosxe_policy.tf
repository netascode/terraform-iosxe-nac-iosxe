locals {
  # Flatten class_map entries: device.name + class_map.name → resource input
  # Step 1: Flatten class maps across devices into a list of 1-key maps
  class_map_list = flatten([
    for device in local.devices : [
      for class_map in try(local.device_config[device.name].policy.class_maps, []) : {
        "${device.name}/${class_map.name}" = {
          device                                         = device.name
          name                                           = class_map.name
          type                                           = try(class_map.type, local.defaults.iosxe.configuration.policy.class_maps.type, null)
          subscriber                                     = try(class_map.subscriber, local.defaults.iosxe.configuration.policy.class_maps.subscriber, null)
          prematch                                       = class_map.prematch
          match_authorization_status_authorized          = try(class_map.match_authorization_status_authorized, local.defaults.iosxe.configuration.policy.class_maps.match_authorization_status_authorized, null)
          match_result_type_aaa_timeout                  = try(class_map.match_result_type_aaa_timeout, local.defaults.iosxe.configuration.policy.class_maps.match_result_type_aaa_timeout, null)
          match_authorization_status_unauthorized        = try(class_map.match_authorization_status_unauthorized, local.defaults.iosxe.configuration.policy.class_maps.match_authorization_status_unauthorized, null)
          match_activated_service_templates              = try(class_map.match_activated_service_templates, local.defaults.iosxe.configuration.policy.class_maps.match_activated_service_template, null)
          match_authorizing_method_priority_greater_than = try(class_map.match_authorizing_method_priority_greater_than, local.defaults.iosxe.configuration.policy.class_maps.match_authorizing_method_priority_greater_than, null)
          match_method_dot1x                             = try(class_map.match_method_dot1x, local.defaults.iosxe.configuration.policy.class_maps.match_method_dot1x, null)
          match_result_type_method_dot1x_authoritative   = try(class_map.match_result_type_method_dot1x_authoritative, local.defaults.iosxe.configuration.policy.class_maps.match_result_type_method_dot1x_authoritative, null)
          match_result_type_method_dot1x_agent_not_found = try(class_map.match_result_type_method_dot1x_agent_not_found, local.defaults.iosxe.configuration.policy.class_maps.match_result_type_method_dot1x_agent_not_found, null)
          match_result_type_method_dot1x_method_timeout  = try(class_map.match_result_type_method_dot1x_method_timeout, local.defaults.iosxe.configuration.policy.class_maps.match_result_type_method_dot1x_method_timeout, null)
          match_method_mab                               = try(class_map.match_method_mab, local.defaults.iosxe.configuration.policy.class_maps.match_method_mab, null)
          match_result_type_method_mab_authoritative     = try(class_map.match_result_type_method_mab_authoritative, local.defaults.iosxe.configuration.policy.class_maps.match_result_type_method_mab_authoritative, null)
          match_dscp                                     = try(class_map.match_dscp, local.defaults.iosxe.configuration.policy.class_maps.match_dscp, null)
          description                                    = try(class_map.description, local.defaults.iosxe.configuration.policy.class_maps.description, null)
        }
      }
    ]
    ]
  )
  # Step 2: Merge list of single-key maps into a single flat map 
  class_map_entries = merge(local.class_map_list...)

  policy_maps = flatten([
    for device in local.devices : [
      for policy_map in try(local.device_config[device.name].policy.policy_maps, []) : {
        key         = format("%s/%s", device.name, policy_map.name)
        device      = device.name
        name        = policy_map.name
        type        = try(policy_map.type, local.defaults.iosxe.configuration.policy.policy_maps.type, null)
        subscriber  = try(policy_map.subscriber, local.defaults.iosxe.configuration.policy.policy_maps.subscriber, null)
        description = try(policy_map.description, local.defaults.iosxe.configuration.policy.policy_maps.description, null)
        classes = [
          for class in try(policy_map.classes, local.defaults.iosxe.configuration.policy.policy_maps.classes, []) : {
            name = class.name
            actions = [
              for action in try(class.actions, local.defaults.iosxe.configuration.policy.policy_maps.classes.action, []) : {
                type                                      = try(action.type, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.type, null)
                bandwidth_bits                            = try(action.bandwidth_bits, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.bandwidth_bits, null)
                bandwidth_percent                         = try(action.bandwidth_percent, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.bandwidth_percent, null)
                bandwidth_remaining_option                = try(action.bandwidth_remaining_option, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.bandwidth_remaining_option, null)
                bandwidth_remaining_percent               = try(action.bandwidth_remaining_percent, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.bandwidth_remaining_percent, null)
                bandwidth_remaining_ratio                 = try(action.bandwidth_remaining_ratio, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.bandwidth_remaining_ration, null)
                priority_burst                            = try(action.priority_burst, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.priority_burst, null)
                priority_level                            = try(action.priority_level, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.priority_level, null)
                queue_limit                               = try(action.queue_limit, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.queue_limit, null)
                queue_limit_type                          = try(action.queue_limit_type, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.queue_limit_type, null)
                shape_average_bit_rate                    = try(action.shape_average_bit_rate, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.shape_average_bit_rate, null)
                shape_average_bits_per_interval_excess    = try(action.shape_average_bits_per_interval_excess, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.shape_average_bits_per_interval_excess, null)
                shape_average_bits_per_interval_sustained = try(action.shape_average_bits_per_interval_sustained, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.shape_average_bits_per_interval_sustained, null)
                shape_average_burst_size_sustained        = try(action.shape_average_burst_size_sustained, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.shape_average_burst_size_sustained, null)
                shape_average_ms                          = try(action.shape_average_ms, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.shape_average_ms, null)
                shape_average_percent                     = try(action.shape_average_percent, local.defaults.iosxe.configuration.policy.policy_maps.classes.action.shape_average_percent, null)
              }
            ]
          }
        ]
      }
    ]
  ])
}

resource "iosxe_class_map" "class_map" {
  for_each                                       = local.class_map_entries
  device                                         = each.value.device
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

resource "iosxe_policy_map" "policy_map" {
  for_each = { for e in local.policy_maps : e.key => e }
  device   = each.value.device

  name        = each.value.name
  type        = each.value.type
  subscriber  = each.value.subscriber
  description = each.value.description
  classes     = each.value.classes
  depends_on  = [iosxe_class_map.class_map]
}
