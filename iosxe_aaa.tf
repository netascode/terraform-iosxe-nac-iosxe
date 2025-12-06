resource "iosxe_aaa" "aaa" {
  for_each                               = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa, null) != null || try(local.defaults.iosxe.configuration.aaa, null) != null }
  device                                 = each.value.name
  new_model                              = try(local.device_config[each.value.name].aaa.new_model, local.defaults.iosxe.configuration.aaa.new_model, null)
  session_id                             = try(local.device_config[each.value.name].aaa.session_id, local.defaults.iosxe.configuration.aaa.session_id, null)
  local_authentication_type              = try(local.device_config[each.value.name].aaa.local_authentication_type, local.defaults.iosxe.configuration.aaa.local_authentication_type, null)
  local_authorization                    = try(local.device_config[each.value.name].aaa.local_authorization, local.defaults.iosxe.configuration.aaa.local_authorization, null)
  local_authentication_max_fail_attempts = try(local.device_config[each.value.name].aaa.local_authentication_max_fail_attempts, local.defaults.iosxe.configuration.aaa.local_authentication_max_fail_attempts, null)
  server_radius_dynamic_author           = try(local.device_config[each.value.name].aaa.radius_dynamic_author, local.defaults.iosxe.configuration.aaa.radius_dynamic_author, null)
  server_radius_dynamic_author_clients = try(length(local.device_config[each.value.name].aaa.radius_dynamic_author_clients) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.radius_dynamic_author_clients : {
    ip              = try(e.ip, local.defaults.iosxe.configuration.aaa.radius_dynamic_author_clients.ip, null)
    server_key_type = try(e.key_type, local.defaults.iosxe.configuration.aaa.radius_dynamic_author_clients.server_key_type, null)
    server_key      = try(e.key, local.defaults.iosxe.configuration.aaa.radius_dynamic_author_clients.server_key, null)
  }]
  group_server_radius = try(length(local.device_config[each.value.name].aaa.radius_groups) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.radius_groups : {
    name = try(e.name, local.defaults.iosxe.configuration.aaa.radius_groups.name, null)

    deadtime                                                = try(e.deadtime, local.defaults.iosxe.configuration.aaa.radius_groups.deadtime, null)
    ip_radius_source_interface_loopback                     = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "Loopback" ? try(e.source_interface_id, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_vlan                         = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "Vlan" ? try(e.source_interface_id, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_gigabit_ethernet             = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_two_gigabit_ethernet         = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_five_gigabit_ethernet        = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_ten_gigabit_ethernet         = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_twenty_five_gigabit_ethernet = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_forty_gigabit_ethernet       = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    ip_radius_source_interface_hundred_gigabit_ethernet     = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.radius_groups.source_interface_id, null) : null
    server_names = try(length(e.server_names) == 0, true) ? null : [for s in e.server_names : {
      name = s
    }]
  }]
  group_server_tacacsplus = try(length(local.device_config[each.value.name].aaa.tacacs_groups) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.tacacs_groups : {
    name                                                    = try(e.name, local.defaults.iosxe.configuration.aaa.tacacs_groups.name, null)
    vrf                                                     = try(e.vrf, local.defaults.iosxe.configuration.aaa.tacacs_groups.vrf, null)
    ip_tacacs_source_interface_loopback                     = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "Loopback" ? try(e.source_interface_id, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_vlan                         = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "Vlan" ? try(e.source_interface_id, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_gigabit_ethernet             = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_two_gigabit_ethernet         = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_five_gigabit_ethernet        = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_ten_gigabit_ethernet         = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_twenty_five_gigabit_ethernet = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_forty_gigabit_ethernet       = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    ip_tacacs_source_interface_hundred_gigabit_ethernet     = try(e.source_interface_type, local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.aaa.tacacs_groups.source_interface_id, null) : null
    server_names = try(length(e.server_names) == 0, true) ? null : [for s in e.server_names : {
      name = s
    }]
  }]

  depends_on = [
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_loopback.loopback,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_interface_vlan.vlan,
    iosxe_radius.radius,
    iosxe_tacacs_server.tacacs_server
  ]
}

resource "iosxe_aaa_accounting" "aaa_accounting" {
  for_each                = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.accounting, null) != null || try(local.defaults.iosxe.configuration.aaa.accounting, null) != null }
  device                  = each.value.name
  update_newinfo_periodic = try(local.device_config[each.value.name].aaa.accounting.update_newinfo_periodic, local.defaults.iosxe.configuration.aaa.accounting.update_newinfo_periodic, null)
  identities = try(length(local.device_config[each.value.name].aaa.accounting.identities) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.identities : {
    name                       = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.identities.name, null)
    start_stop_broadcast       = try(e.start_stop_broadcast, local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_broadcast, null)
    start_stop_group_broadcast = try(e.start_stop_group_broadcast, local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_group_broadcast, null)
    start_stop_group_logger    = try(e.start_stop_group_logger, local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_group_logger, null)
    start_stop_group1          = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_groups[0], null)
    start_stop_group2          = try(e.start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_groups[1], null)
    start_stop_group3          = try(e.start_stop_groups[2], local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_groups[2], null)
    start_stop_group4          = try(e.start_stop_groups[3], local.defaults.iosxe.configuration.aaa.accounting.identities.start_stop_groups[3], null)
  }]
  identity_default_start_stop_group1 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.identity_default_start_stop_groups[0], null)
  identity_default_start_stop_group2 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.identity_default_start_stop_groups[1], null)
  identity_default_start_stop_group3 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[2], local.defaults.iosxe.configuration.aaa.accounting.identity_default_start_stop_groups[2], null)
  identity_default_start_stop_group4 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[3], local.defaults.iosxe.configuration.aaa.accounting.identity_default_start_stop_groups[3], null)
  commands = try(length(local.device_config[each.value.name].aaa.accounting.commands) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.commands : {
    level           = try(e.level, local.defaults.iosxe.configuration.aaa.accounting.commands.level, null)
    list_name       = try(e.list_name, local.defaults.iosxe.configuration.aaa.accounting.commands.list_name, null)
    action_type     = try(e.action_type, local.defaults.iosxe.configuration.aaa.accounting.commands.action_type, null)
    broadcast       = try(e.broadcast, local.defaults.iosxe.configuration.aaa.accounting.commands.broadcast, null)
    group_broadcast = try(e.group_broadcast, local.defaults.iosxe.configuration.aaa.accounting.commands.group_broadcast, null)
    group_logger    = try(e.group_logger, local.defaults.iosxe.configuration.aaa.accounting.commands.group_logger, null)
    group1_group    = try(e.groups[0], local.defaults.iosxe.configuration.aaa.accounting.commands.groups[0], null)
    group2_group    = try(e.groups[1], local.defaults.iosxe.configuration.aaa.accounting.commands.groups[1], null)
    group3_group    = try(e.groups[2], local.defaults.iosxe.configuration.aaa.accounting.commands.groups[2], null)
    group4_group    = try(e.groups[3], local.defaults.iosxe.configuration.aaa.accounting.commands.groups[3], null)
  }]
  connections = try(length(local.device_config[each.value.name].aaa.accounting.connections) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.connections : {
    name                 = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.connections.name, null)
    default              = try(e.default, local.defaults.iosxe.configuration.aaa.accounting.connections.default, null)
    none                 = try(e.none, local.defaults.iosxe.configuration.aaa.accounting.connections.none, null)
    start_stop_broadcast = try(e.start_stop_broadcast, local.defaults.iosxe.configuration.aaa.accounting.connections.start_stop_broadcast, null)
    start_stop_logger    = try(e.start_stop_group_logger, local.defaults.iosxe.configuration.aaa.accounting.connections.start_stop_group_logger, null)
    start_stop_group1    = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.connections.start_stop_groups[0], null)
    start_stop_group2    = try(e.start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.connections.start_stop_groups[1], null)
    start_stop_group3    = try(e.start_stop_groups[2], local.defaults.iosxe.configuration.aaa.accounting.connections.start_stop_groups[2], null)
    start_stop_group4    = try(e.start_stop_groups[3], local.defaults.iosxe.configuration.aaa.accounting.connections.start_stop_groups[3], null)
    stop_only_broadcast  = try(e.stop_only_broadcast, local.defaults.iosxe.configuration.aaa.accounting.connections.stop_only_broadcast, null)
    stop_only_logger     = try(e.stop_only_group_logger, local.defaults.iosxe.configuration.aaa.accounting.connections.stop_only_group_logger, null)
    stop_only_group1     = try(e.stop_only_groups[0], local.defaults.iosxe.configuration.aaa.accounting.connections.stop_only_groups[0], null)
    stop_only_group2     = try(e.stop_only_groups[1], local.defaults.iosxe.configuration.aaa.accounting.connections.stop_only_groups[1], null)
    stop_only_group3     = try(e.stop_only_groups[2], local.defaults.iosxe.configuration.aaa.accounting.connections.stop_only_groups[2], null)
    stop_only_group4     = try(e.stop_only_groups[3], local.defaults.iosxe.configuration.aaa.accounting.connections.stop_only_groups[3], null)
    wait_start_broadcast = try(e.wait_start_broadcast, local.defaults.iosxe.configuration.aaa.accounting.connections.wait_start_broadcast, null)
    wait_start_logger    = try(e.wait_start_group_logger, local.defaults.iosxe.configuration.aaa.accounting.connections.wait_start_group_logger, null)
    wait_start_group1    = try(e.wait_start_groups[0], local.defaults.iosxe.configuration.aaa.accounting.connections.wait_start_groups[0], null)
    wait_start_group2    = try(e.wait_start_groups[1], local.defaults.iosxe.configuration.aaa.accounting.connections.wait_start_groups[1], null)
    wait_start_group3    = try(e.wait_start_groups[2], local.defaults.iosxe.configuration.aaa.accounting.connections.wait_start_groups[2], null)
    wait_start_group4    = try(e.wait_start_groups[3], local.defaults.iosxe.configuration.aaa.accounting.connections.wait_start_groups[3], null)
  }]
  execs = try(length(local.device_config[each.value.name].aaa.accounting.execs) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.execs : {
    name                 = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.execs.name, null)
    none                 = try(e.none, local.defaults.iosxe.configuration.aaa.accounting.execs.none, null)
    start_stop_broadcast = try(e.start_stop_broadcast, local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_broadcast, null)
    start_stop_logger    = try(e.start_stop_group_logger, local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_group_logger, null)
    start_stop_group1    = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_groups[0], null)
    start_stop_group2    = try(e.start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_groups[1], null)
    start_stop_group3    = try(e.start_stop_groups[2], local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_groups[2], null)
    start_stop_group4    = try(e.start_stop_groups[3], local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_groups[3], null)
    stop_only_broadcast  = try(e.stop_only_broadcast, local.defaults.iosxe.configuration.aaa.accounting.execs.stop_only_broadcast, null)
    stop_only_logger     = try(e.stop_only_group_logger, local.defaults.iosxe.configuration.aaa.accounting.execs.stop_only_group_logger, null)
    stop_only_group1     = try(e.stop_only_groups[0], local.defaults.iosxe.configuration.aaa.accounting.execs.stop_only_groups[0], null)
    stop_only_group2     = try(e.stop_only_groups[1], local.defaults.iosxe.configuration.aaa.accounting.execs.stop_only_groups[1], null)
    stop_only_group3     = try(e.stop_only_groups[2], local.defaults.iosxe.configuration.aaa.accounting.execs.stop_only_groups[2], null)
    stop_only_group4     = try(e.stop_only_groups[3], local.defaults.iosxe.configuration.aaa.accounting.execs.stop_only_groups[3], null)
    wait_start_broadcast = try(e.wait_start_broadcast, local.defaults.iosxe.configuration.aaa.accounting.execs.wait_start_broadcast, null)
    wait_start_logger    = try(e.wait_start_group_logger, local.defaults.iosxe.configuration.aaa.accounting.execs.wait_start_group_logger, null)
    wait_start_group1    = try(e.wait_start_groups[0], local.defaults.iosxe.configuration.aaa.accounting.execs.wait_start_groups[0], null)
    wait_start_group2    = try(e.wait_start_groups[1], local.defaults.iosxe.configuration.aaa.accounting.execs.wait_start_groups[1], null)
    wait_start_group3    = try(e.wait_start_groups[2], local.defaults.iosxe.configuration.aaa.accounting.execs.wait_start_groups[2], null)
    wait_start_group4    = try(e.wait_start_groups[3], local.defaults.iosxe.configuration.aaa.accounting.execs.wait_start_groups[3], null)
  }]
  networks = try(length(local.device_config[each.value.name].aaa.accounting.networks) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.networks : {
    id                = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.networks.name, null)
    start_stop_group1 = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.networks.start_stop_groups[0], null)
    start_stop_group2 = try(e.start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.networks.start_stop_groups[1], null)
  }]
  system_guarantee_first = try(local.device_config[each.value.name].aaa.accounting.system_guarantee_first, local.defaults.iosxe.configuration.aaa.accounting.system_guarantee_first, null)
  dot1x = try(length(local.device_config[each.value.name].aaa.accounting.dot1x) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.dot1x : {
    name                       = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.dot1x.name, null)
    start_stop_broadcast       = try(e.start_stop_broadcast, local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_broadcast, null)
    start_stop_group_broadcast = try(e.start_stop_group_broadcast, local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_group_broadcast, null)
    start_stop_group_logger    = try(e.start_stop_group_logger, local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_group_logger, null)
    start_stop_group1          = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_groups[0], null)
    start_stop_group2          = try(e.start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_groups[1], null)
    start_stop_group3          = try(e.start_stop_groups[2], local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_groups[2], null)
    start_stop_group4          = try(e.start_stop_groups[3], local.defaults.iosxe.configuration.aaa.accounting.dot1x.start_stop_groups[3], null)
  }]

  dot1x_default_start_stop_group1          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[0], local.defaults.iosxe.configuration.aaa.accounting.dot1x_defaults[0], null)
  dot1x_default_start_stop_group2          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[1], local.defaults.iosxe.configuration.aaa.accounting.dot1x_defaults[1], null)
  dot1x_default_start_stop_group3          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[2], local.defaults.iosxe.configuration.aaa.accounting.dot1x_defaults[2], null)
  dot1x_default_start_stop_group4          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[3], local.defaults.iosxe.configuration.aaa.accounting.dot1x_defaults[3], null)
  dot1x_default_start_stop_broadcast       = try(local.device_config[each.value.name].aaa.accounting.dot1x_default_start_stop_broadcast, local.defaults.iosxe.configuration.aaa.accounting.dot1x_default_start_stop_broadcast, null)
  dot1x_default_start_stop_group_broadcast = try(local.device_config[each.value.name].aaa.accounting.dot1x_default_start_stop_group_broadcast, local.defaults.iosxe.configuration.aaa.accounting.dot1x_default_start_stop_group_broadcast, null)
  dot1x_default_start_stop_group_logger    = try(local.device_config[each.value.name].aaa.accounting.dot1x_default_start_stop_group_logger, local.defaults.iosxe.configuration.aaa.accounting.dot1x_default_start_stop_group_logger, null)

  depends_on = [
    iosxe_aaa.aaa,
  ]
}

resource "iosxe_aaa_authentication" "aaa_authentication" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.authentication, null) != null || try(local.defaults.iosxe.configuration.aaa.authentication, null) != null }
  device   = each.value.name

  logins = try(length(local.device_config[each.value.name].aaa.authentication.logins) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authentication.logins : {
    name      = try(e.name, local.defaults.iosxe.configuration.aaa.authentication.logins.name, null)
    a1_none   = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0], null) == "none" ? true : false
    a1_line   = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0], null) == "line" ? true : false
    a1_enable = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0], null) == "enable" ? true : false
    a1_local  = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0], null) == "local" ? true : false
    a1_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0])), false) ? try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0]) : null
    a2_none   = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1], null) == "none" ? true : false
    a2_line   = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1], null) == "line" ? true : false
    a2_enable = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1], null) == "enable" ? true : false
    a2_local  = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1], null) == "local" ? true : false
    a2_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1])), false) ? try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1]) : null
    a3_none   = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2], null) == "none" ? true : false
    a3_line   = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2], null) == "line" ? true : false
    a3_enable = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2], null) == "enable" ? true : false
    a3_local  = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2], null) == "local" ? true : false
    a3_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2])), false) ? try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2]) : null
    a4_none   = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3], null) == "none" ? true : false
    a4_line   = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3], null) == "line" ? true : false
    a4_enable = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3], null) == "enable" ? true : false
    a4_local  = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3], null) == "local" ? true : false
    a4_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3]) : null
  }]

  dot1x = try(length(local.device_config[each.value.name].aaa.authentication.dot1xs) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authentication.dot1xs : {
    name      = try(e.name, local.defaults.iosxe.configuration.aaa.authentication.dot1xs.name, null)
    a1_group  = try(!contains(["local", "cache", "radius"], try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[0])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[0]) : null
    a1_local  = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[0], null) == "local" ? true : false
    a1_cache  = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[0], null) == "cache" ? true : false
    a1_radius = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[0], null) == "radius" ? true : false
    a2_group  = try(!contains(["local", "cache", "radius"], try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[1])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[1]) : null
    a2_local  = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[1], null) == "local" ? true : false
    a2_cache  = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[1], null) == "cache" ? true : false
    a2_radius = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[1], null) == "radius" ? true : false
    a3_group  = try(!contains(["local", "cache", "radius"], try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[2])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[2]) : null
    a3_local  = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[2], null) == "local" ? true : false
    a3_cache  = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[2], null) == "cache" ? true : false
    a3_radius = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[2], null) == "radius" ? true : false
    a4_group  = try(!contains(["local", "cache", "radius"], try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[3])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.logins.methods[3]) : null
    a4_local  = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[3], null) == "local" ? true : false
    a4_cache  = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[3], null) == "cache" ? true : false
    a4_radius = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authentication.dot1xs.methods[3], null) == "radius" ? true : false
  }]

  dot1x_default_a1_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[0], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[0])), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[0], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[0]) : null
  dot1x_default_a1_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[0], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[0], null) == "local" ? true : false
  dot1x_default_a2_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[1], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[1])), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[1], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[1]) : null
  dot1x_default_a2_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[1], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[1], null) == "local" ? true : false
  dot1x_default_a3_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[2], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[2])), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[2], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[2]) : null
  dot1x_default_a3_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[2], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[2], null) == "local" ? true : false
  dot1x_default_a4_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[3], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[3])), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[3], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[3]) : null
  dot1x_default_a4_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[3], local.defaults.iosxe.configuration.aaa.authentication.dot1x_defaults[3], null) == "local" ? true : false

  enable_default_group_legacy  = !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults_legacy, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults_legacy, null) : null
  enable_default_enable_legacy = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults_legacy, null) == "enable" ? true : false
  enable_default_line_legacy   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults_legacy, null) == "line" ? true : false
  enable_default_none_legacy   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults_legacy, null) == "none" ? true : false

  enable_default_group1_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].method, null) : null
  enable_default_group1_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].method, null) == "enable" ? true : false
  enable_default_group1_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].method, null) : null
  enable_default_group1_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].method, null) == "line" ? true : false
  enable_default_group1_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[0].method, null) == "none" ? true : false
  enable_default_group2_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].method, null) : null
  enable_default_group2_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].method, null) == "enable" ? true : false
  enable_default_group2_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].method, null) : null
  enable_default_group2_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].method, null) == "line" ? true : false
  enable_default_group2_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[1].method, null) == "none" ? true : false
  enable_default_group3_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].method, null) : null
  enable_default_group3_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].method, null) == "enable" ? true : false
  enable_default_group3_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].method, null) : null
  enable_default_group3_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].method, null) == "line" ? true : false
  enable_default_group3_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[2].method, null) == "none" ? true : false
  enable_default_group4_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].method, null) : null
  enable_default_group4_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].method, null) == "enable" ? true : false
  enable_default_group4_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].cache, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].method, null) : null
  enable_default_group4_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].method, null) == "line" ? true : false
  enable_default_group4_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, local.defaults.iosxe.configuration.aaa.authentication.enable_defaults[3].method, null) == "none" ? true : false

  depends_on = [
    iosxe_aaa.aaa,
  ]
}

resource "iosxe_aaa_authorization" "aaa_authorization" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.authorization, null) != null || try(local.defaults.iosxe.configuration.aaa.authorization, null) != null }
  device   = each.value.name

  config_commands = try(local.device_config[each.value.name].aaa.authorization.config_commands, local.defaults.iosxe.configuration.aaa.authorization.config_commands, null)

  config_lists = try(length(local.device_config[each.value.name].aaa.authorization.config_lists) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.config_lists : {
    name          = try(e.name, local.defaults.iosxe.configuration.aaa.authorization.config_lists.name, null)
    group1_cache  = try(e.groups[0].cache, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].cache, false) && try(e.groups[0].method, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].method, null) != null ? try(e.groups[0].method, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].method, null) : null
    group1_group  = !try(e.groups[0].cache, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].cache, false) && !contains(["radius", "tacacs"], try(e.groups[0].method, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].method, "")) ? try(e.groups[0].method, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].method, null) : null
    group1_radius = try(e.groups[0].method, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].method, null) == "radius" ? true : false
    group1_tacacs = try(e.groups[0].method, local.defaults.iosxe.configuration.aaa.authorization.config_lists.groups[0].method, null) == "tacacs" ? true : false
  }]

  commands = try(length(local.device_config[each.value.name].aaa.authorization.commands) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.commands : {
    level               = try(e.level, local.defaults.iosxe.configuration.aaa.authorization.commands.level, null)
    list_name           = try(e.list_name, local.defaults.iosxe.configuration.aaa.authorization.commands.list_name, null)
    a1_local            = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0], null) == "local" ? true : false
    a1_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0])), false) ? try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0]) : null
    a1_radius           = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0], null) == "radius" ? true : false
    a1_tacacs           = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0], null) == "tacacs" ? true : false
    a1_if_authenticated = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0], null) == "if_authenticated" ? true : false
    a1_none             = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[0], null) == "none" ? true : false
    a2_local            = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1], null) == "local" ? true : false
    a2_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1])), false) ? try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1]) : null
    a2_radius           = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1], null) == "radius" ? true : false
    a2_tacacs           = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1], null) == "tacacs" ? true : false
    a2_if_authenticated = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1], null) == "if_authenticated" ? true : false
    a2_none             = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[1], null) == "none" ? true : false
    a3_local            = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2], null) == "local" ? true : false
    a3_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2])), false) ? try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2]) : null
    a3_radius           = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2], null) == "radius" ? true : false
    a3_tacacs           = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2], null) == "tacacs" ? true : false
    a3_if_authenticated = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2], null) == "if_authenticated" ? true : false
    a3_none             = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[2], null) == "none" ? true : false
    a4_local            = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3], null) == "local" ? true : false
    a4_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3]) : null
    a4_radius           = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3], null) == "radius" ? true : false
    a4_tacacs           = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3], null) == "tacacs" ? true : false
    a4_if_authenticated = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3], null) == "if_authenticated" ? true : false
    a4_none             = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.commands.methods[3], null) == "none" ? true : false
  }]

  execs = try(length(local.device_config[each.value.name].aaa.authorization.execs) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.execs : {
    name                = try(e.name, local.defaults.iosxe.configuration.aaa.authorization.execs.name, null)
    a1_local            = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "local" ? true : false
    a1_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0])), false) ? try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0]) : null
    a1_radius           = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "radius" ? true : false
    a1_tacacs           = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "tacacs" ? true : false
    a1_if_authenticated = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "if_authenticated" ? true : false
    a1_none             = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "none" ? true : false
    a2_local            = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "local" ? true : false
    a2_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1])), false) ? try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1]) : null
    a2_radius           = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "radius" ? true : false
    a2_tacacs           = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "tacacs" ? true : false
    a2_if_authenticated = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "if_authenticated" ? true : false
    a2_none             = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "none" ? true : false
    a3_local            = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "local" ? true : false
    a3_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2])), false) ? try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2]) : null
    a3_radius           = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "radius" ? true : false
    a3_tacacs           = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "tacacs" ? true : false
    a3_if_authenticated = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "if_authenticated" ? true : false
    a3_none             = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "none" ? true : false
    a4_local            = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "local" ? true : false
    a4_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3]) : null
    a4_radius           = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "radius" ? true : false
    a4_tacacs           = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "tacacs" ? true : false
    a4_if_authenticated = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "if_authenticated" ? true : false
    a4_none             = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "none" ? true : false
  }]

  networks = try(length(local.device_config[each.value.name].aaa.authorization.networks) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.networks : {
    id       = try(e.name, local.defaults.iosxe.configuration.aaa.authorization.networks.name, null)
    a1_local = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[0], null) == "local" ? true : false
    a1_group = try(!contains(["local"], try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[0])), false) ? try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[0]) : null
    a2_local = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[1], null) == "local" ? true : false
    a2_group = try(!contains(["local"], try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[1])), false) ? try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[1]) : null
    a3_local = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[2], null) == "local" ? true : false
    a3_group = try(!contains(["local"], try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[2])), false) ? try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[2]) : null
    a4_local = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[3], null) == "local" ? true : false
    a4_group = try(!contains(["local"], try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[3])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.networks.methods[3]) : null
  }]

  depends_on = [
    iosxe_aaa.aaa,
  ]
}

locals {
  radius_servers = flatten([
    for device in local.devices : [
      for server in try(local.device_config[device.name].aaa.radius.servers, []) : {
        tag                              = format("%s/%s", device.name, try(server.name, local.defaults.iosxe.configuration.aaa.radius.servers.name, null))
        device_name                      = device.name
        name                             = try(server.name, local.defaults.iosxe.configuration.aaa.radius.servers.name, null)
        ipv4_address                     = try(server.ip, local.defaults.iosxe.configuration.aaa.radius.servers.ip, null)
        authentication_port              = try(server.authentication_port, local.defaults.iosxe.configuration.aaa.radius.servers.authentication_port, null)
        accounting_port                  = try(server.accounting_port, local.defaults.iosxe.configuration.aaa.radius.servers.accounting_port, null)
        timeout                          = try(server.timeout, local.defaults.iosxe.configuration.aaa.radius.servers.timeout, null)
        retransmit                       = try(server.retransmit, local.defaults.iosxe.configuration.aaa.radius.servers.retransmit, null)
        key                              = try(server.key, local.defaults.iosxe.configuration.aaa.radius.servers.key, null)
        encryption                       = try(server.encryption, local.defaults.iosxe.configuration.aaa.radius.servers.encryption, null)
        automate_tester_username         = try(server.automate_tester_username, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_username, null)
        automate_tester_ignore_acct_port = try(server.automate_tester_ignore_acct_port, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_ignore_acct_port, null)
        automate_tester_ignore_auth_port = try(server.automate_tester_ignore_auth_port, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_ignore_auth_port, null)
        automate_tester_probe_on_config  = try(server.automate_tester_probe_on_config, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_probe_on_config, null)
        automate_tester_idle_time        = try(server.automate_tester_idle_time, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_idle_time, null)
        pac_key                          = try(server.pac_key, local.defaults.iosxe.configuration.aaa.radius.servers.pac_key, null)
        pac_key_encryption               = try(server.pac_key_encryption, local.defaults.iosxe.configuration.aaa.radius.servers.pac_key_encryption, null)
      }
    ]
  ])
}

resource "iosxe_radius" "radius" {
  for_each = { for server in local.radius_servers : server.tag => server }
  device   = each.value.device_name

  name                             = each.value.name
  ipv4_address                     = each.value.ipv4_address
  timeout                          = each.value.timeout
  key                              = each.value.key
  key_encryption                   = each.value.encryption
  authentication_port              = each.value.authentication_port
  accounting_port                  = each.value.accounting_port
  retransmit                       = each.value.retransmit
  automate_tester_username         = each.value.automate_tester_username
  automate_tester_ignore_acct_port = each.value.automate_tester_ignore_acct_port
  automate_tester_ignore_auth_port = each.value.automate_tester_ignore_auth_port
  automate_tester_idle_time        = each.value.automate_tester_idle_time
  automate_tester_probe_on_config  = each.value.automate_tester_probe_on_config
  pac_key                          = each.value.pac_key
  pac_key_encryption               = each.value.pac_key_encryption
}

resource "iosxe_radius_server" "radius_server" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.radius, null) != null || try(local.defaults.iosxe.configuration.aaa.radius, null) != null }
  device   = each.value.name

  dead_criteria_time  = try(local.device_config[each.value.name].aaa.radius.dead_criteria_time, local.defaults.iosxe.configuration.aaa.radius.dead_criteria_time, null)
  dead_criteria_tries = try(local.device_config[each.value.name].aaa.radius.dead_criteria_tries, local.defaults.iosxe.configuration.aaa.radius.dead_criteria_tries, null)
  deadtime            = try(local.device_config[each.value.name].aaa.radius.deadtime, local.defaults.iosxe.configuration.aaa.radius.deadtime, null)

  attributes = try(length(local.device_config[each.value.name].aaa.radius.attributes) == 0, true) ? null : [for attr in local.device_config[each.value.name].aaa.radius.attributes :
    {
      number          = try(attr.number, local.defaults.iosxe.configuration.aaa.radius.attributes.number, null)
      send_attributes = try(attr.send_attributes, local.defaults.iosxe.configuration.aaa.radius.attributes.send_attributes, null)
      attribute_31_parameters = try(length(attr.attribute_31_parameters) == 0, true) ? null : [for param in attr.attribute_31_parameters :
        {
          calling_station_id      = try(param.calling_station_id, local.defaults.iosxe.configuration.aaa.radius.attributes.attribute_31_parameters.calling_station_id, null)
          id_mac_format           = try(param.id_mac_format, local.defaults.iosxe.configuration.aaa.radius.attributes.attribute_31_parameters.id_mac_format, null)
          id_mac_lu_case          = try(param.id_mac_lu_case, local.defaults.iosxe.configuration.aaa.radius.attributes.attribute_31_parameters.id_mac_lu_case, null)
          id_send_mac_only        = try(param.id_send_mac_only, local.defaults.iosxe.configuration.aaa.radius.attributes.attribute_31_parameters.id_send_mac_only, null)
          id_send_nas_port_detail = try(param.id_send_nas_port_detail, local.defaults.iosxe.configuration.aaa.radius.attributes.attribute_31_parameters.id_send_nas_port_detail, null)
        }
      ]
    }
  ]
}



locals {
  tacacs_servers = flatten([
    for device in local.devices : [
      for server in try(local.device_config[device.name].aaa.tacacs.servers, []) : {
        device_name  = device.name
        name         = try(server.name, local.defaults.iosxe.configuration.aaa.tacacs.servers.name, null)
        address_ipv4 = try(server.ip, local.defaults.iosxe.configuration.aaa.tacacs.servers.ip, null)
        timeout      = try(server.timeout, local.defaults.iosxe.configuration.aaa.tacacs.servers.timeout, null)
        port         = try(server.port, local.defaults.iosxe.configuration.aaa.tacacs.servers.port, null)
        encryption   = try(server.encryption, local.defaults.iosxe.configuration.aaa.tacacs.servers.encryption, null)
        key          = try(server.key, local.defaults.iosxe.configuration.aaa.tacacs.servers.key, null)
        tag          = format("%s/%s", device.name, try(server.name, local.defaults.iosxe.configuration.aaa.tacacs.servers.name, null))
      }
    ]
  ])
}

resource "iosxe_tacacs" "tacacs" {
  for_each = { for server in local.tacacs_servers : server.tag => server }
  device   = each.value.device_name

  name         = each.value.name
  address_ipv4 = each.value.address_ipv4
  timeout      = each.value.timeout
  port         = each.value.port
  encryption   = each.value.encryption
  key          = each.value.key

}

resource "iosxe_tacacs_server" "tacacs_server" {

  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.tacacs, null) != null || try(local.defaults.iosxe.configuration.aaa.tacacs, null) != null }
  device   = each.value.name

  timeout                      = try(local.device_config[each.value.name].aaa.tacacs.timeout, local.defaults.iosxe.configuration.aaa.tacacs.timeout, null)
  directed_request             = try(local.device_config[each.value.name].aaa.tacacs.directed_request, local.defaults.iosxe.configuration.aaa.tacacs.directed_request, null)
  directed_request_restricted  = try(local.device_config[each.value.name].aaa.tacacs.directed_request_restricted, local.defaults.iosxe.configuration.aaa.tacacs.directed_request_restricted, null)
  directed_request_no_truncate = try(local.device_config[each.value.name].aaa.tacacs.directed_request_no_truncate, local.defaults.iosxe.configuration.aaa.tacacs.directed_request_no_truncate, null)
  key                          = try(local.device_config[each.value.name].aaa.tacacs.key, local.defaults.iosxe.configuration.aaa.tacacs.key, null)
  encryption                   = try(local.device_config[each.value.name].aaa.tacacs.encryption, local.defaults.iosxe.configuration.aaa.tacacs.encryption, null)
  attribute_allow_unknown      = try(local.device_config[each.value.name].aaa.tacacs.attribute_allow_unknown, local.defaults.iosxe.configuration.aaa.tacacs.attribute_allow_unknown, null)

}

locals {
  usernames = flatten([
    for device in local.devices : [
      for username in try(local.device_config[device.name].aaa.usernames, []) : {
        device_name         = device.name
        name                = try(username.name, null)
        privilege           = try(username.privilege, local.defaults.iosxe.configuration.aaa.usernames.privilege, null)
        description         = try(username.description, local.defaults.iosxe.configuration.aaa.usernames.description, null)
        password_encryption = try(username.password_encryption, local.defaults.iosxe.configuration.aaa.usernames.password_encryption, null)
        password            = try(username.password, local.defaults.iosxe.configuration.aaa.usernames.password, null)
        secret_encryption   = try(username.secret_encryption, local.defaults.iosxe.configuration.aaa.usernames.secret_encryption, null)
        secret              = try(username.secret, local.defaults.iosxe.configuration.aaa.usernames.secret, null)
        tag                 = format("%s/%s", device.name, try(username.name, null))
      }
    ]
  ])
}

resource "iosxe_username" "username" {
  for_each = { for username in local.usernames : username.tag => username }
  device   = each.value.device_name

  name                = each.value.name
  privilege           = each.value.privilege
  description         = each.value.description
  password_encryption = each.value.password_encryption
  password            = each.value.password
  secret_encryption   = each.value.secret_encryption
  secret              = each.value.secret
}