resource "iosxe_aaa" "aaa" {
  for_each                     = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa, null) != null || try(local.defaults.iosxe.configuration.aaa, null) != null }
  device                       = each.value.name
  new_model                    = try(local.device_config[each.value.name].aaa.new_model, local.defaults.iosxe.configuration.aaa.new_model, null)
  session_id                   = try(local.device_config[each.value.name].aaa.session_id, local.defaults.iosxe.configuration.aaa.session_id, null)
  server_radius_dynamic_author = try(local.device_config[each.value.name].aaa.radius_dynamic_author, local.defaults.iosxe.configuration.aaa.radius_dynamic_author, null)
  server_radius_dynamic_author_clients = [for e in try(local.device_config[each.value.name].aaa.radius_dynamic_author_clients, []) : {
    ip              = try(e.ip, local.defaults.iosxe.configuration.aaa.radius_dynamic_author_clients.ip, null)
    server_key_type = try(e.key_type, local.defaults.iosxe.configuration.aaa.radius_dynamic_author_clients.server_key_type, null)
    server_key      = try(e.key, local.defaults.iosxe.configuration.aaa.radius_dynamic_author_clients.server_key, null)
  }]
  group_server_radius = [for e in try(local.device_config[each.value.name].aaa.radius_groups, []) : {
    name = try(e.name, local.defaults.iosxe.configuration.aaa.radius_groups.name, null)

    ip_radius_source_interface_loopback                     = e.source_interface_type == "Loopback" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_loopback, null)
    ip_radius_source_interface_vlan                         = e.source_interface_type == "Vlan" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_vlan, null)
    ip_radius_source_interface_gigabit_ethernet             = e.source_interface_type == "GigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_gigabit_ethernet, null)
    ip_radius_source_interface_two_gigabit_ethernet         = e.source_interface_type == "TwoGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_two_gigabit_ethernet, null)
    ip_radius_source_interface_five_gigabit_ethernet        = e.source_interface_type == "FiveGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_five_gigabit_ethernet, null)
    ip_radius_source_interface_ten_gigabit_ethernet         = e.source_interface_type == "TenGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_ten_gigabit_ethernet, null)
    ip_radius_source_interface_twenty_five_gigabit_ethernet = e.source_interface_type == "TwentyFiveGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_twenty_five_gigabit_ethernet, null)
    ip_radius_source_interface_forty_gigabit_ethernet       = e.source_interface_type == "FortyGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_forty_gigabit_ethernet, null)
    ip_radius_source_interface_hundred_gigabit_ethernet     = e.source_interface_type == "HundredGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.radius_groups.ip_radius_source_interface_hundred_gigabit_ethernet, null)
    server_names = [for s in try(e.server_names, []) : {
      name = s
    }]
  }]
  group_server_tacacsplus = [for e in try(local.device_config[each.value.name].aaa.tacacs_groups, []) : {
    name                                                    = try(e.name, local.defaults.iosxe.configuration.aaa.tacacs_groups.name, null)
    ip_tacacs_source_interface_loopback                     = e.source_interface_type == "Loopback" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_loopback, null)
    ip_tacacs_source_interface_vlan                         = e.source_interface_type == "Vlan" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_vlan, null)
    ip_tacacs_source_interface_gigabit_ethernet             = e.source_interface_type == "GigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_gigabit_ethernet, null)
    ip_tacacs_source_interface_two_gigabit_ethernet         = e.source_interface_type == "TwoGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_two_gigabit_ethernet, null)
    ip_tacacs_source_interface_five_gigabit_ethernet        = e.source_interface_type == "FiveGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_five_gigabit_ethernet, null)
    ip_tacacs_source_interface_ten_gigabit_ethernet         = e.source_interface_type == "TenGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_ten_gigabit_ethernet, null)
    ip_tacacs_source_interface_twenty_five_gigabit_ethernet = e.source_interface_type == "TwentyFiveGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_twenty_five_gigabit_ethernet, null)
    ip_tacacs_source_interface_forty_gigabit_ethernet       = e.source_interface_type == "FortyGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_forty_gigabit_ethernet, null)
    ip_tacacs_source_interface_hundred_gigabit_ethernet     = e.source_interface_type == "HundredGigabitEthernet" ? e.source_interface_id : try(local.defaults.iosxe.configuration.aaa.tacacs_groups.ip_tacacs_source_interface_hundred_gigabit_ethernet, null)
    server_names = [for s in try(e.server_names, []) : {
      name = s
    }]
  }]
}

resource "iosxe_aaa_accounting" "aaa_accounting" {
  for_each                = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.accounting, null) != null || try(local.defaults.iosxe.configuration.aaa.accounting, null) != null }
  device                  = each.value.name
  update_newinfo_periodic = try(local.device_config[each.value.name].aaa.accounting.update_newinfo_periodic, local.defaults.iosxe.configuration.aaa.accounting.update_newinfo_periodic, null)
  identities = [for e in try(local.device_config[each.value.name].aaa.accounting.identities, []) : {
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
  execs = [for e in try(local.device_config[each.value.name].aaa.accounting.execs, []) : {
    name              = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.execs.name, null)
    start_stop_group1 = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.execs.start_stop_groups[0], null)
  }]
  networks = [for e in try(local.device_config[each.value.name].aaa.accounting.networks, []) : {
    id                = try(e.name, local.defaults.iosxe.configuration.aaa.accounting.networks.name, null)
    start_stop_group1 = try(e.start_stop_groups[0], local.defaults.iosxe.configuration.aaa.accounting.networks.start_stop_groups[0], null)
    start_stop_group2 = try(e.start_stop_groups[1], local.defaults.iosxe.configuration.aaa.accounting.networks.start_stop_groups[1], null)
  }]
  system_guarantee_first = try(local.device_config[each.value.name].aaa.accounting.system_guarantee_first, local.defaults.iosxe.configuration.aaa.accounting.system_guarantee_first, null)
}

resource "iosxe_aaa_authentication" "aaa_authentication" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.authentication, null) != null || try(local.defaults.iosxe.configuration.aaa.authentication, null) != null }
  device   = each.value.name

  logins = [for e in try(local.device_config[each.value.name].aaa.authentication.logins, []) : {
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

  dot1x = [for e in try(local.device_config[each.value.name].aaa.authentication.dot1xs, []) : {
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
}

resource "iosxe_aaa_authorization" "aaa_authorization" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].aaa.authorization, null) != null || try(local.defaults.iosxe.configuration.aaa.authorization, null) != null }
  device   = each.value.name

  execs = [for e in try(local.device_config[each.value.name].aaa.authorization.execs, []) : {
    name                = try(e.name, local.defaults.iosxe.configuration.aaa.authorization.execs.name, null)
    a1_local            = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "local" ? true : false
    a1_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated"], try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0])), false) ? try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0]) : null
    a2_local            = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "local" ? true : false
    a2_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated"], try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1])), false) ? try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1]) : null
    a3_local            = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "local" ? true : false
    a3_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated"], try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2])), false) ? try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2]) : null
    a4_local            = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "local" ? true : false
    a4_group            = try(!contains(["local", "radius", "tacacs", "if_authenticated"], try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3])), false) ? try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3]) : null
    a1_radius           = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "radius" ? true : false
    a1_tacacs           = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "tacacs" ? true : false
    a1_if_authenticated = try(e.methods[0], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[0], null) == "if_authenticated" ? true : false
    a2_radius           = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "radius" ? true : false
    a2_tacacs           = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "tacacs" ? true : false
    a2_if_authenticated = try(e.methods[1], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[1], null) == "if_authenticated" ? true : false
    a3_radius           = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "radius" ? true : false
    a3_tacacs           = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "tacacs" ? true : false
    a3_if_authenticated = try(e.methods[2], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[2], null) == "if_authenticated" ? true : false
    a4_radius           = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "radius" ? true : false
    a4_tacacs           = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "tacacs" ? true : false
    a4_if_authenticated = try(e.methods[3], local.defaults.iosxe.configuration.aaa.authorization.execs.methods[3], null) == "if_authenticated" ? true : false
  }]

  networks = [for e in try(local.device_config[each.value.name].aaa.authorization.networks, []) : {
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
        automate_tester_username         = try(server.automate_tester_username, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_username, null)
        automate_tester_ignore_acct_port = try(server.automate_tester_ignore_acct_port, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_ignore_acct_port, null)
        automate_tester_probe_on_config  = try(server.automate_tester_probe_on_config, local.defaults.iosxe.configuration.aaa.radius.servers.automate_tester_probe_on_config, null)
        pac_key                          = try(server.pac_key, local.defaults.iosxe.configuration.aaa.radius.servers.pac_key, null)
        pac_key_encryption               = try(server.pac_key_encryption, local.defaults.iosxe.configuration.aaa.radius.servers.pac_key_encryption, null)
      }
    ]
  ])
}

resource "iosxe_radius" "radius" {

  for_each = {
    for server in local.radius_servers : server.tag => server
  }
  device                           = each.value.device_name
  name                             = each.value.name
  ipv4_address                     = each.value.ipv4_address
  timeout                          = each.value.timeout
  key                              = each.value.key
  authentication_port              = each.value.authentication_port
  accounting_port                  = each.value.accounting_port
  retransmit                       = each.value.retransmit
  automate_tester_username         = each.value.automate_tester_username
  automate_tester_ignore_acct_port = each.value.automate_tester_ignore_acct_port
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

  attributes = [for attr in try(local.device_config[each.value.name].aaa.radius.attributes, local.defaults.iosxe.configuration.aaa.radius.attributes, []) :
    {
      number                 = try(attr.number, null)
      access_request_include = try(attr.access_request_include, null)
      send_attributes        = try(attr.send_attributes, null)
      attribute_31_parameters = [for param in try(attr.attribute_31_parameters, []) :
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
}

locals {
  tacacs_servers = flatten([
    for device in local.devices : [
      for server in try(local.device_config[device.name].aaa.tacacs_servers, []) : {
        device_name  = device.name
        name         = try(server.name, local.defaults.iosxe.configuration.aaa.tacacs_servers.name, null)
        address_ipv4 = try(server.ip, local.defaults.iosxe.configuration.aaa.tacacs_servers.ip, null)
        timeout      = try(server.timeout, local.defaults.iosxe.configuration.aaa.tacacs_servers.timeout, null)
        encryption   = try(server.encryption, local.defaults.iosxe.configuration.aaa.tacacs_servers.encryption, null)
        key          = try(server.key, local.defaults.iosxe.configuration.aaa.tacacs_servers.key, null)
        tag          = format("%s/%s", device.name, try(server.name, local.defaults.iosxe.configuration.aaa.tacacs_servers.name, null))
      }
    ]
  ])
}

resource "iosxe_tacacs_server" "tacacs_server" {
  for_each = {
    for server in local.tacacs_servers : server.tag => server
  }
  device       = each.value.device_name
  name         = each.value.name
  address_ipv4 = each.value.address_ipv4
  timeout      = each.value.timeout
  encryption   = each.value.encryption
  key          = each.value.key
}