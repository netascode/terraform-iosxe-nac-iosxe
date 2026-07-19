resource "iosxe_aaa" "aaa" {
  for_each                               = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa, null) != null }
  device                                 = each.value.name
  new_model                              = try(local.device_config[each.value.name].aaa.new_model, null)
  session_id                             = try(local.device_config[each.value.name].aaa.session_id, null)
  local_authentication_type              = try(local.device_config[each.value.name].aaa.local_authentication_type, null)
  local_authorization                    = try(local.device_config[each.value.name].aaa.local_authorization, null)
  local_authentication_max_fail_attempts = try(local.device_config[each.value.name].aaa.local_authentication_max_fail_attempts, null)
  server_radius_dynamic_author           = try(local.device_config[each.value.name].aaa.radius_dynamic_author, null)
  server_radius_dynamic_author_clients = try(length(local.device_config[each.value.name].aaa.radius_dynamic_author_clients) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.radius_dynamic_author_clients : {
    ip              = try(e.ip, null)
    server_key_type = try(e.key_type, null)
    server_key      = try(e.key, null)
  }]
  group_server_radius = try(length(local.device_config[each.value.name].aaa.radius_groups) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.radius_groups : {
    name = try(e.name, null)

    deadtime                                                = try(e.deadtime, null)
    ip_radius_source_interface_loopback                     = try(e.source_interface_type, null) == "Loopback" ? try(e.source_interface_id, null) : null
    ip_radius_source_interface_vlan                         = try(e.source_interface_type, null) == "Vlan" ? try(e.source_interface_id, null) : null
    ip_radius_source_interface_gigabit_ethernet             = try(e.source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_radius_source_interface_two_gigabit_ethernet         = try(e.source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_radius_source_interface_five_gigabit_ethernet        = try(e.source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_radius_source_interface_ten_gigabit_ethernet         = try(e.source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_radius_source_interface_twenty_five_gigabit_ethernet = try(e.source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_radius_source_interface_forty_gigabit_ethernet       = try(e.source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_radius_source_interface_hundred_gigabit_ethernet     = try(e.source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    server_names = try(length(e.server_names) == 0, true) ? null : [for s in e.server_names : {
      name = s
    }]
  }]
  group_server_tacacsplus = try(length(local.device_config[each.value.name].aaa.tacacs_groups) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.tacacs_groups : {
    name                                                    = try(e.name, null)
    vrf                                                     = try(e.vrf, null)
    ip_tacacs_source_interface_loopback                     = try(e.source_interface_type, null) == "Loopback" ? try(e.source_interface_id, null) : null
    ip_tacacs_source_interface_vlan                         = try(e.source_interface_type, null) == "Vlan" ? try(e.source_interface_id, null) : null
    ip_tacacs_source_interface_gigabit_ethernet             = try(e.source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_tacacs_source_interface_two_gigabit_ethernet         = try(e.source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_tacacs_source_interface_five_gigabit_ethernet        = try(e.source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_tacacs_source_interface_ten_gigabit_ethernet         = try(e.source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_tacacs_source_interface_twenty_five_gigabit_ethernet = try(e.source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_tacacs_source_interface_forty_gigabit_ethernet       = try(e.source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    ip_tacacs_source_interface_hundred_gigabit_ethernet     = try(e.source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(e.source_interface_id, "$string "), null) : null
    server_names = try(length(e.server_names) == 0, true) ? null : [for s in e.server_names : {
      name = s
    }]
  }]

  depends_on = [
    iosxe_interface_loopback.loopback,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_interface_vlan.vlan,
    iosxe_vrf.vrf,
  ]
}

resource "iosxe_aaa_accounting" "aaa_accounting" {
  for_each                = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.accounting, null) != null }
  device                  = each.value.name
  update_newinfo_periodic = try(local.device_config[each.value.name].aaa.accounting.update_newinfo_periodic, null)
  identities = try(length(local.device_config[each.value.name].aaa.accounting.identities) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.identities : {
    name                       = try(e.name, null)
    start_stop_broadcast       = try(e.start_stop_broadcast, null)
    start_stop_group_broadcast = try(e.start_stop_group_broadcast, null)
    start_stop_group_logger    = try(e.start_stop_group_logger, null)
    start_stop_group1          = try(e.start_stop_groups[0], null)
    start_stop_group2          = try(e.start_stop_groups[1], null)
    start_stop_group3          = try(e.start_stop_groups[2], null)
    start_stop_group4          = try(e.start_stop_groups[3], null)
  }]
  identity_default_start_stop_group1 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[0], null)
  identity_default_start_stop_group2 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[1], null)
  identity_default_start_stop_group3 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[2], null)
  identity_default_start_stop_group4 = try(local.device_config[each.value.name].aaa.accounting.identity_default_start_stop_groups[3], null)
  commands = try(length(local.device_config[each.value.name].aaa.accounting.commands) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.commands : {
    level           = try(e.level, null)
    list_name       = try(e.list_name, null)
    action_type     = try(e.action_type, null)
    group_broadcast = try(e.group_broadcast, null)
    group_logger    = try(e.group_logger, null)
    group1_group    = try(e.groups[0], null)
    group2_group    = try(e.groups[1], null)
    group3_group    = try(e.groups[2], null)
    group4_group    = try(e.groups[3], null)
  }]
  connections = try(length(local.device_config[each.value.name].aaa.accounting.connections) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.connections : {
    name = try(e.name, null)
    # Note: The 'default' leaf should NOT be set for connection accounting - use name: "default" instead
    default              = null
    none                 = try(e.none, null)
    start_stop_broadcast = try(e.start_stop_broadcast, null)
    start_stop_logger    = try(e.start_stop_group_logger, null)
    start_stop_group1    = try(e.start_stop_groups[0], null)
    start_stop_group2    = try(e.start_stop_groups[1], null)
    start_stop_group3    = try(e.start_stop_groups[2], null)
    start_stop_group4    = try(e.start_stop_groups[3], null)
    stop_only_broadcast  = try(e.stop_only_broadcast, null)
    stop_only_logger     = try(e.stop_only_group_logger, null)
    stop_only_group1     = try(e.stop_only_groups[0], null)
    stop_only_group2     = try(e.stop_only_groups[1], null)
    stop_only_group3     = try(e.stop_only_groups[2], null)
    stop_only_group4     = try(e.stop_only_groups[3], null)
  }]
  execs = try(length(local.device_config[each.value.name].aaa.accounting.execs) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.execs : {
    name                 = try(e.name, null)
    none                 = try(e.none, null)
    start_stop_broadcast = try(e.start_stop_broadcast, null)
    start_stop_logger    = try(e.start_stop_group_logger, null)
    start_stop_group1    = try(e.start_stop_groups[0], null)
    start_stop_group2    = try(e.start_stop_groups[1], null)
    start_stop_group3    = try(e.start_stop_groups[2], null)
    start_stop_group4    = try(e.start_stop_groups[3], null)
    stop_only_broadcast  = try(e.stop_only_broadcast, null)
    stop_only_logger     = try(e.stop_only_group_logger, null)
    stop_only_group1     = try(e.stop_only_groups[0], null)
    stop_only_group2     = try(e.stop_only_groups[1], null)
    stop_only_group3     = try(e.stop_only_groups[2], null)
    stop_only_group4     = try(e.stop_only_groups[3], null)
  }]
  networks = try(length(local.device_config[each.value.name].aaa.accounting.networks) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.networks : {
    id                = try(e.name, null)
    start_stop_group1 = try(e.start_stop_groups[0], null)
    start_stop_group2 = try(e.start_stop_groups[1], null)
  }]
  system_guarantee_first = try(local.device_config[each.value.name].aaa.accounting.system_guarantee_first, null)
  dot1x = try(length(local.device_config[each.value.name].aaa.accounting.dot1x) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.accounting.dot1x : {
    name                       = try(e.name, null)
    start_stop_broadcast       = try(e.start_stop_broadcast, null)
    start_stop_group_broadcast = try(e.start_stop_group_broadcast, null)
    start_stop_group_logger    = try(e.start_stop_group_logger, null)
    start_stop_group1          = try(e.start_stop_groups[0], null)
    start_stop_group2          = try(e.start_stop_groups[1], null)
    start_stop_group3          = try(e.start_stop_groups[2], null)
    start_stop_group4          = try(e.start_stop_groups[3], null)
  }]

  dot1x_default_start_stop_group1          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[0], null)
  dot1x_default_start_stop_group2          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[1], null)
  dot1x_default_start_stop_group3          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[2], null)
  dot1x_default_start_stop_group4          = try(local.device_config[each.value.name].aaa.accounting.dot1x_defaults[3], null)
  dot1x_default_start_stop_broadcast       = try(local.device_config[each.value.name].aaa.accounting.dot1x_default_start_stop_broadcast, null)
  dot1x_default_start_stop_group_broadcast = try(local.device_config[each.value.name].aaa.accounting.dot1x_default_start_stop_group_broadcast, null)
  dot1x_default_start_stop_group_logger    = try(local.device_config[each.value.name].aaa.accounting.dot1x_default_start_stop_group_logger, null)

  depends_on = [
    iosxe_aaa.aaa,
  ]
}

resource "iosxe_aaa_authentication" "aaa_authentication" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.authentication, null) != null }
  device   = each.value.name

  logins = try(length(local.device_config[each.value.name].aaa.authentication.logins) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authentication.logins : {
    name      = try(e.name, null)
    a1_none   = try(e.methods[0], null) == "none" ? true : false
    a1_line   = try(e.methods[0], null) == "line" ? true : false
    a1_enable = try(e.methods[0], null) == "enable" ? true : false
    a1_local  = try(e.methods[0], null) == "local" ? true : false
    a1_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[0], null)), false) ? try(e.methods[0], null) : null
    a2_none   = try(e.methods[1], null) == "none" ? true : false
    a2_line   = try(e.methods[1], null) == "line" ? true : false
    a2_enable = try(e.methods[1], null) == "enable" ? true : false
    a2_local  = try(e.methods[1], null) == "local" ? true : false
    a2_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[1], null)), false) ? try(e.methods[1], null) : null
    a3_none   = try(e.methods[2], null) == "none" ? true : false
    a3_line   = try(e.methods[2], null) == "line" ? true : false
    a3_enable = try(e.methods[2], null) == "enable" ? true : false
    a3_local  = try(e.methods[2], null) == "local" ? true : false
    a3_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[2], null)), false) ? try(e.methods[2], null) : null
    a4_none   = try(e.methods[3], null) == "none" ? true : false
    a4_line   = try(e.methods[3], null) == "line" ? true : false
    a4_enable = try(e.methods[3], null) == "enable" ? true : false
    a4_local  = try(e.methods[3], null) == "local" ? true : false
    a4_group  = try(!contains(["none", "line", "enable", "local"], try(e.methods[3], null)), false) ? try(e.methods[3], null) : null
  }]

  dot1x = try(length(local.device_config[each.value.name].aaa.authentication.dot1xs) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authentication.dot1xs : {
    name      = try(e.name, null)
    a1_group  = try(!contains(["local", "cache", "radius"], try(e.methods[0], null)), false) ? try(e.methods[0], null) : null
    a1_local  = try(e.methods[0], null) == "local" ? true : null
    a1_cache  = null # cache requires group name - not supported as standalone method
    a1_radius = try(e.methods[0], null) == "radius" ? true : null
    a2_group  = try(!contains(["local", "cache", "radius"], try(e.methods[1], null)), false) ? try(e.methods[1], null) : null
    a2_local  = try(e.methods[1], null) == "local" ? true : null
    a2_cache  = null # cache requires group name - not supported as standalone method
    a2_radius = try(e.methods[1], null) == "radius" ? true : null
    a3_group  = try(!contains(["local", "cache", "radius"], try(e.methods[2], null)), false) ? try(e.methods[2], null) : null
    a3_local  = try(e.methods[2], null) == "local" ? true : null
    a3_cache  = null # cache requires group name - not supported as standalone method
    a3_radius = try(e.methods[2], null) == "radius" ? true : null
    a4_group  = try(!contains(["local", "cache", "radius"], try(e.methods[3], null)), false) ? try(e.methods[3], null) : null
    a4_local  = try(e.methods[3], null) == "local" ? true : null
    a4_cache  = null # cache requires group name - not supported as standalone method
    a4_radius = try(e.methods[3], null) == "radius" ? true : null
  }]

  dot1x_default_a1_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[0], null)), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[0], null) : null
  dot1x_default_a1_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[0], null) == "local" ? true : false
  dot1x_default_a2_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[1], null)), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[1], null) : null
  dot1x_default_a2_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[1], null) == "local" ? true : false
  dot1x_default_a3_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[2], null)), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[2], null) : null
  dot1x_default_a3_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[2], null) == "local" ? true : false
  dot1x_default_a4_group = try(!contains(["local"], try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[3], null)), false) ? try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[3], null) : null
  dot1x_default_a4_local = try(local.device_config[each.value.name].aaa.authentication.dot1x_defaults[3], null) == "local" ? true : false

  enable_default_group_legacy  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) != null && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null)) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) : null
  enable_default_enable_legacy = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) == "enable") : null
  enable_default_line_legacy   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) == "line") : null
  enable_default_none_legacy   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults_legacy, null) == "none") : null


  enable_default_group1_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, null) : null
  enable_default_group1_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, null) == "enable") : null
  enable_default_group1_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, null) : null
  enable_default_group1_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, null) == "line") : null
  enable_default_group1_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[0].method, null) == "none") : null
  enable_default_group2_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, null) : null
  enable_default_group2_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, null) == "enable") : null
  enable_default_group2_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, null) : null
  enable_default_group2_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, null) == "line") : null
  enable_default_group2_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[1].method, null) == "none") : null
  enable_default_group3_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, null) : null
  enable_default_group3_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, null) == "enable") : null
  enable_default_group3_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, null) : null
  enable_default_group3_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, null) == "line") : null
  enable_default_group3_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[2].method, null) == "none") : null
  enable_default_group4_cache  = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].cache, false) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, null) : null
  enable_default_group4_enable = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, null) == "enable") : null
  enable_default_group4_group  = !try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].cache, false) && !contains(["enable", "line", "none"], try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, "")) ? try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, null) : null
  enable_default_group4_line   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, null) == "line") : null
  enable_default_group4_none   = try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3], null) != null ? (try(local.device_config[each.value.name].aaa.authentication.enable_defaults[3].method, null) == "none") : null

  depends_on = [
    iosxe_aaa.aaa,
  ]
}

resource "iosxe_aaa_authorization" "aaa_authorization" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.authorization, null) != null }
  device   = each.value.name

  config_commands = try(local.device_config[each.value.name].aaa.authorization.config_commands, null)
  console         = try(local.device_config[each.value.name].aaa.authorization.console, null)

  config_lists = try(length(local.device_config[each.value.name].aaa.authorization.config_lists) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.config_lists : {
    name          = try(e.name, null)
    group1_cache  = try(e.groups[0].cache, false) && try(e.groups[0].method, null) != null ? try(e.groups[0].method, null) : null
    group1_group  = !try(e.groups[0].cache, false) && !contains(["radius", "tacacs"], try(e.groups[0].method, "")) ? try(e.groups[0].method, null) : null
    group1_radius = try(e.groups[0].method, null) == "radius" ? true : false
    group1_tacacs = try(e.groups[0].method, null) == "tacacs" ? true : false
  }]

  commands = try(length(local.device_config[each.value.name].aaa.authorization.commands) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.commands : {
    level               = try(e.level, null)
    list_name           = try(e.list_name, null)
    a1_local            = try(e.methods[0], null) == "local" ? true : false
    a1_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[0], null)), false) ? try(e.methods[0], null) : null
    a1_radius           = try(e.methods[0], null) == "radius" ? true : false
    a1_tacacs           = try(e.methods[0], null) == "tacacs" ? true : false
    a1_if_authenticated = try(e.methods[0], null) == "if_authenticated" ? true : false
    a1_none             = try(e.methods[0], null) == "none" ? true : false
    a2_local            = try(e.methods[1], null) == "local" ? true : false
    a2_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[1], null)), false) ? try(e.methods[1], null) : null
    a2_radius           = try(e.methods[1], null) == "radius" ? true : false
    a2_tacacs           = try(e.methods[1], null) == "tacacs" ? true : false
    a2_if_authenticated = try(e.methods[1], null) == "if_authenticated" ? true : false
    a2_none             = try(e.methods[1], null) == "none" ? true : false
    a3_local            = try(e.methods[2], null) == "local" ? true : false
    a3_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[2], null)), false) ? try(e.methods[2], null) : null
    a3_radius           = try(e.methods[2], null) == "radius" ? true : false
    a3_tacacs           = try(e.methods[2], null) == "tacacs" ? true : false
    a3_if_authenticated = try(e.methods[2], null) == "if_authenticated" ? true : false
    a3_none             = try(e.methods[2], null) == "none" ? true : false
    a4_local            = try(e.methods[3], null) == "local" ? true : false
    a4_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[3], null)), false) ? try(e.methods[3], null) : null
    a4_radius           = try(e.methods[3], null) == "radius" ? true : false
    a4_tacacs           = try(e.methods[3], null) == "tacacs" ? true : false
    a4_if_authenticated = try(e.methods[3], null) == "if_authenticated" ? true : false
    a4_none             = try(e.methods[3], null) == "none" ? true : false
  }]

  execs = try(length(local.device_config[each.value.name].aaa.authorization.execs) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.execs : {
    name                = try(e.name, null)
    a1_local            = try(e.methods[0], null) == "local" ? true : false
    a1_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[0], null)), false) ? try(e.methods[0], null) : null
    a1_radius           = try(e.methods[0], null) == "radius" ? true : false
    a1_tacacs           = try(e.methods[0], null) == "tacacs" ? true : false
    a1_if_authenticated = try(e.methods[0], null) == "if_authenticated" ? true : false
    a1_none             = try(e.methods[0], null) == "none" ? true : false
    a2_local            = try(e.methods[1], null) == "local" ? true : false
    a2_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[1], null)), false) ? try(e.methods[1], null) : null
    a2_radius           = try(e.methods[1], null) == "radius" ? true : false
    a2_tacacs           = try(e.methods[1], null) == "tacacs" ? true : false
    a2_if_authenticated = try(e.methods[1], null) == "if_authenticated" ? true : false
    a2_none             = try(e.methods[1], null) == "none" ? true : false
    a3_local            = try(e.methods[2], null) == "local" ? true : false
    a3_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[2], null)), false) ? try(e.methods[2], null) : null
    a3_radius           = try(e.methods[2], null) == "radius" ? true : false
    a3_tacacs           = try(e.methods[2], null) == "tacacs" ? true : false
    a3_if_authenticated = try(e.methods[2], null) == "if_authenticated" ? true : false
    a3_none             = try(e.methods[2], null) == "none" ? true : false
    a4_local            = try(e.methods[3], null) == "local" ? true : false
    a4_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated", "none"], try(e.methods[3], null)), false) ? try(e.methods[3], null) : null
    a4_radius           = try(e.methods[3], null) == "radius" ? true : false
    a4_tacacs           = try(e.methods[3], null) == "tacacs" ? true : false
    a4_if_authenticated = try(e.methods[3], null) == "if_authenticated" ? true : false
    a4_none             = try(e.methods[3], null) == "none" ? true : false
  }]

  networks = try(length(local.device_config[each.value.name].aaa.authorization.networks) == 0, true) ? null : [for e in local.device_config[each.value.name].aaa.authorization.networks : {
    id       = try(e.name, null)
    a1_local = try(e.methods[0], null) == "local" ? true : false
    a1_group = try(!contains(["local"], try(e.methods[0], null)), false) ? try(e.methods[0], null) : null
    a2_local = try(e.methods[1], null) == "local" ? true : false
    a2_group = try(!contains(["local"], try(e.methods[1], null)), false) ? try(e.methods[1], null) : null
    a3_local = try(e.methods[2], null) == "local" ? true : false
    a3_group = try(!contains(["local"], try(e.methods[2], null)), false) ? try(e.methods[2], null) : null
    a4_local = try(e.methods[3], null) == "local" ? true : false
    a4_group = try(!contains(["local"], try(e.methods[3], null)), false) ? try(e.methods[3], null) : null
  }]

  depends_on = [
    iosxe_aaa.aaa,
  ]
}

locals {
  radius_servers = flatten([
    for device in local.devices : [
      for server in try(local.device_config[device.name].aaa.radius.servers, []) : {
        tag                              = format("%s/%s", device.name, try(server.name, null))
        device_name                      = device.name
        name                             = try(server.name, null)
        ipv4_address                     = try(server.ip, null)
        authentication_port              = try(server.authentication_port, null)
        accounting_port                  = try(server.accounting_port, null)
        timeout                          = try(server.timeout, null)
        retransmit                       = try(server.retransmit, null)
        key                              = try(server.key, null)
        encryption                       = try(server.encryption, null)
        automate_tester_username         = try(server.automate_tester_username, null)
        automate_tester_ignore_acct_port = try(server.automate_tester_ignore_acct_port, null)
        automate_tester_ignore_auth_port = try(server.automate_tester_ignore_auth_port, null)
        automate_tester_probe_on_config  = try(server.automate_tester_probe_on_config, null)
        automate_tester_idle_time        = try(server.automate_tester_idle_time, null)
        pac_key                          = try(server.pac_key, null)
        pac_key_encryption               = try(server.pac_key_encryption, null)
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

  depends_on = [
    iosxe_aaa.aaa
  ]
}

resource "iosxe_radius_server" "radius_server" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.radius, null) != null }
  device   = each.value.name

  dead_criteria_time  = try(local.device_config[each.value.name].aaa.radius.dead_criteria_time, null)
  dead_criteria_tries = try(local.device_config[each.value.name].aaa.radius.dead_criteria_tries, null)
  deadtime            = try(local.device_config[each.value.name].aaa.radius.deadtime, null)

  attributes = try(length(local.device_config[each.value.name].aaa.radius.attributes) == 0, true) ? null : [for attr in local.device_config[each.value.name].aaa.radius.attributes :
    {
      number          = try(attr.number, null)
      send_attributes = try(attr.send_attributes, null)
      attribute_31_parameters = try(length(attr.attribute_31_parameters) == 0, true) ? null : [for param in attr.attribute_31_parameters :
        {
          calling_station_id      = try(param.calling_station_id, null)
          id_mac_format           = try(param.id_mac_format, null)
          id_mac_lu_case          = try(param.id_mac_lu_case, null)
          id_send_mac_only        = try(param.id_send_mac_only, null)
          id_send_nas_port_detail = try(param.id_send_nas_port_detail, null)
        }
      ]
    }
  ]

  depends_on = [
    iosxe_aaa.aaa
  ]
}

locals {
  tacacs_servers = flatten([
    for device in local.devices : [
      for server in try(local.device_config[device.name].aaa.tacacs.servers, []) : {
        device_name  = device.name
        name         = try(server.name, null)
        address_ipv4 = try(server.ip, null)
        timeout      = try(server.timeout, null)
        port         = try(server.port, null)
        encryption   = try(server.encryption, null)
        key          = try(server.key, null)
        tag          = format("%s/%s", device.name, try(server.name, null))
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

  depends_on = [
    iosxe_aaa.aaa
  ]
}

resource "iosxe_tacacs_server" "tacacs_server" {

  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.tacacs, null) != null }
  device   = each.value.name

  timeout                      = try(local.device_config[each.value.name].aaa.tacacs.timeout, null)
  directed_request             = try(local.device_config[each.value.name].aaa.tacacs.directed_request, null)
  directed_request_restricted  = try(local.device_config[each.value.name].aaa.tacacs.directed_request_restricted, null)
  directed_request_no_truncate = try(local.device_config[each.value.name].aaa.tacacs.directed_request_no_truncate, null)
  key                          = try(local.device_config[each.value.name].aaa.tacacs.key, null)
  encryption                   = try(local.device_config[each.value.name].aaa.tacacs.encryption, null)
  attribute_allow_unknown      = try(local.device_config[each.value.name].aaa.tacacs.attribute_allow_unknown, null)

}

locals {
  usernames = flatten([
    for device in local.devices : [
      for username in try(local.device_config[device.name].aaa.usernames, []) : {
        device_name         = device.name
        name                = try(username.name, null)
        privilege           = try(username.privilege, null)
        description         = try(username.description, null)
        password_encryption = try(username.password_encryption, null)
        password            = try(username.password, null)
        secret_encryption   = try(username.secret_encryption, null)
        secret              = try(username.secret, null)
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