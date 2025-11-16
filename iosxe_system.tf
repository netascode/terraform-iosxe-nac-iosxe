resource "iosxe_system" "system" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].system, null) != null || try(local.defaults.iosxe.configuration.system, null) != null }
  device   = each.value.name

  hostname                         = try(local.device_config[each.value.name].system.hostname, local.defaults.iosxe.configuration.system.hostname, null)
  ip_bgp_community_new_format      = try(local.device_config[each.value.name].system.ip_bgp_community_new_format, local.defaults.iosxe.configuration.system.ip_bgp_community_new_format, null)
  ip_routing                       = try(local.device_config[each.value.name].system.ip_routing, local.defaults.iosxe.configuration.system.ip_routing, null)
  ipv6_unicast_routing             = try(local.device_config[each.value.name].system.ipv6_unicast_routing, local.defaults.iosxe.configuration.system.ipv6_unicast_routing, null)
  mtu                              = try(local.device_config[each.value.name].system.mtu, local.defaults.iosxe.configuration.system.mtu, null)
  ip_source_route                  = try(local.device_config[each.value.name].system.ip_source_route, local.defaults.iosxe.configuration.system.ip_source_route, null)
  ip_domain_lookup                 = try(local.device_config[each.value.name].system.ip_domain_lookup, local.defaults.iosxe.configuration.system.ip_domain_lookup, null)
  ip_domain_name                   = try(local.device_config[each.value.name].system.ip_domain_name, local.defaults.iosxe.configuration.system.ip_domain_name, null)
  login_delay                      = try(local.device_config[each.value.name].system.login_delay, local.defaults.iosxe.configuration.system.login_delay, null)
  login_on_failure                 = try(local.device_config[each.value.name].system.login_on_failure, local.defaults.iosxe.configuration.system.login_on_failure, null)
  login_on_failure_log             = try(local.device_config[each.value.name].system.login_on_failure_log, local.defaults.iosxe.configuration.system.login_on_failure_log, null)
  login_on_success                 = try(local.device_config[each.value.name].system.login_on_success, local.defaults.iosxe.configuration.system.login_on_success, null)
  login_on_success_log             = try(local.device_config[each.value.name].system.login_on_success_log, local.defaults.iosxe.configuration.system.login_on_success_log, null)
  ip_multicast_routing             = try(local.device_config[each.value.name].system.ip_multicast_routing, local.defaults.iosxe.configuration.system.ip_multicast_routing, null)
  multicast_routing_switch         = try(local.device_config[each.value.name].system.multicast_routing_switch, local.defaults.iosxe.configuration.system.multicast_routing_switch, null)
  ip_multicast_routing_distributed = try(local.device_config[each.value.name].system.ip_multicast_routing_distributed, local.defaults.iosxe.configuration.system.ip_multicast_routing_distributed, null)
  access_session_mac_move_deny     = try(local.device_config[each.value.name].system.access_session_mac_move_deny, local.defaults.iosxe.configuration.system.access_session_mac_move_deny, null)

  # Archive configuration
  archive_log_config_logging_enable  = try(local.device_config[each.value.name].system.archive.log_config_logging_enable, local.defaults.iosxe.configuration.system.archive.log_config_logging_enable, null)
  archive_log_config_logging_size    = try(local.device_config[each.value.name].system.archive.log_config_logging_size, local.defaults.iosxe.configuration.system.archive.log_config_logging_size, null)
  archive_maximum                    = try(local.device_config[each.value.name].system.archive.maximum, local.defaults.iosxe.configuration.system.archive.maximum, null)
  archive_path                       = try(local.device_config[each.value.name].system.archive.path, local.defaults.iosxe.configuration.system.archive.path, null)
  archive_time_period                = try(local.device_config[each.value.name].system.archive.time_period, local.defaults.iosxe.configuration.system.archive.time_period, null)
  archive_write_memory               = try(local.device_config[each.value.name].system.archive.write_memory, local.defaults.iosxe.configuration.system.archive.write_memory, null)
  cisp_enable                        = try(local.device_config[each.value.name].system.cisp_enable, local.defaults.iosxe.configuration.system.cisp_enable, null)
  control_plane_service_policy_input = try(local.device_config[each.value.name].system.control_plane_service_policy_input, local.defaults.iosxe.configuration.system.control_plane_service_policy_input, null)
  diagnostic_bootup_level            = try(local.device_config[each.value.name].system.diagnostic_bootup_level, local.defaults.iosxe.configuration.system.diagnostic_bootup_level, null)
  enable_secret                      = try(local.device_config[each.value.name].system.enable_secret, local.defaults.iosxe.configuration.system.enable_secret, null)
  enable_secret_level                = try(local.device_config[each.value.name].system.enable_secret_level, local.defaults.iosxe.configuration.system.enable_secret_level, null)
  enable_secret_type                 = try(local.device_config[each.value.name].system.enable_secret_type, local.defaults.iosxe.configuration.system.enable_secret_type, null)
  epm_logging                        = try(local.device_config[each.value.name].system.epm_logging, local.defaults.iosxe.configuration.system.epm_logging, null)
  ip_forward_protocol_nd             = try(local.device_config[each.value.name].system.ip_forward_protocol_nd, local.defaults.iosxe.configuration.system.ip_forward_protocol_nd, null)
  ip_scp_server_enable               = try(local.device_config[each.value.name].system.ip_scp_server_enable, local.defaults.iosxe.configuration.system.ip_scp_server_enable, null)
  # SSH configuration
  ip_ssh_authentication_retries       = try(local.device_config[each.value.name].system.ssh.authentication_retries, local.defaults.iosxe.configuration.system.ssh.authentication_retries, null)
  ip_ssh_time_out                     = try(local.device_config[each.value.name].system.ssh.time_out, local.defaults.iosxe.configuration.system.ssh.time_out, null)
  ip_ssh_version                      = try(local.device_config[each.value.name].system.ssh.version, local.defaults.iosxe.configuration.system.ssh.version, null)
  ip_ssh_bulk_mode                    = try(local.device_config[each.value.name].system.ssh.bulk_mode, local.defaults.iosxe.configuration.system.ssh.bulk_mode, null)
  ip_ssh_bulk_mode_window_size        = try(local.device_config[each.value.name].system.ssh.bulk_mode_window_size, local.defaults.iosxe.configuration.system.ssh.bulk_mode_window_size, null)
  memory_free_low_watermark_processor = try(local.device_config[each.value.name].system.memory_free_low_watermark_processor, local.defaults.iosxe.configuration.system.memory_free_low_watermark_processor, null)
  redundancy                          = try(local.device_config[each.value.name].system.redundancy, local.defaults.iosxe.configuration.system.redundancy, null)
  redundancy_mode                     = try(local.device_config[each.value.name].system.redundancy_mode, local.defaults.iosxe.configuration.system.redundancy_mode, null)
  transceiver_type_all_monitoring     = try(local.device_config[each.value.name].system.transceiver_type_all_monitoring, local.defaults.iosxe.configuration.system.transceiver_type_all_monitoring, null)

  # Interface-based source interface mappings
  ip_domain_lookup_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_loopback                     = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_vlan                         = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null

  ip_radius_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_loopback                     = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_radius_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_vlan                         = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_vrf                          = try(local.device_config[each.value.name].system.ip_radius_source_interface_vrf, local.defaults.iosxe.configuration.system.ip_radius_source_interface_vrf, null)

  ip_ssh_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_loopback                     = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ssh.source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_vlan                         = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null

  ip_tacacs_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_loopback                     = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_vlan                         = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_vrf                          = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_vrf, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_vrf, null)

  # Simple list attributes
  ip_name_servers = try(local.device_config[each.value.name].system.ip_name_servers, local.defaults.iosxe.configuration.system.ip_name_servers, null)

  multicast_routing_vrfs = try(length(local.device_config[each.value.name].system.multicast_routing_vrfs) == 0, true) ? null : [
    for mrv in local.device_config[each.value.name].system.multicast_routing_vrfs : {
      vrf         = try(mrv.vrf, local.defaults.iosxe.configuration.system.multicast_routing_vrfs.vrf, null)
      distributed = try(mrv.distributed, local.defaults.iosxe.configuration.system.multicast_routing_vrfs.distributed, null)
    }
  ]

  # Nested list structures
  boot_system_bootfiles = try(length(local.device_config[each.value.name].system.boot_system_bootfiles) == 0, true) ? null : [
    for bootfile in local.device_config[each.value.name].system.boot_system_bootfiles : {
      path = bootfile
    }
  ]

  boot_system_flash_files = try(length(local.device_config[each.value.name].system.boot_system_flash_files) == 0, true) ? null : [
    for flashfile in local.device_config[each.value.name].system.boot_system_flash_files : {
      path = flashfile
    }
  ]

  ip_name_servers_vrf = try(length(local.device_config[each.value.name].system.ip_name_servers_vrf) == 0, true) ? null : [
    for vrf in local.device_config[each.value.name].system.ip_name_servers_vrf : {
      vrf     = try(vrf.vrf, local.defaults.iosxe.configuration.system.ip_name_servers_vrf.vrf, null)
      servers = try(vrf.servers, local.defaults.iosxe.configuration.system.ip_name_servers_vrf.servers, null)
    }
  ]

  pnp_profiles = try(length(local.device_config[each.value.name].system.pnp_profiles) == 0, true) ? null : [
    for profile in local.device_config[each.value.name].system.pnp_profiles : {
      name                              = try(profile.name, local.defaults.iosxe.configuration.system.pnp_profiles.name, null)
      transport_https_ipv4_ipv4_address = try(profile.transport_https_ipv4_ipv4_address, local.defaults.iosxe.configuration.system.pnp_profiles.transport_https_ipv4_ipv4_address, null)
      transport_https_ipv4_port         = try(profile.transport_https_ipv4_port, local.defaults.iosxe.configuration.system.pnp_profiles.transport_https_ipv4_port, null)
    }
  ]

  ip_http_access_class                            = try(local.device_config[each.value.name].system.http.access_class, local.defaults.iosxe.configuration.system.http.access_class, null)
  ip_http_active_session_modules                  = try(local.device_config[each.value.name].system.http.active_session_modules, local.defaults.iosxe.configuration.system.http.active_session_modules, null)
  ip_http_authentication_aaa                      = try(local.device_config[each.value.name].system.http.authentication_aaa, local.defaults.iosxe.configuration.system.http.authentication_aaa, null)
  ip_http_authentication_aaa_exec_authorization   = try(local.device_config[each.value.name].system.http.authentication_aaa_exec_authorization, local.defaults.iosxe.configuration.system.http.authentication_aaa_exec_authorization, null)
  ip_http_authentication_aaa_login_authentication = try(local.device_config[each.value.name].system.http.authentication_aaa_login_authentication, local.defaults.iosxe.configuration.system.http.authentication_aaa_login_authentication, null)
  ip_http_authentication_local                    = try(local.device_config[each.value.name].system.http.authentication_local, local.defaults.iosxe.configuration.system.http.authentication_local, null)
  ip_http_client_secure_trustpoint                = try(local.device_config[each.value.name].system.http.client_secure_trustpoint, local.defaults.iosxe.configuration.system.http.client_secure_trustpoint, null)
  ip_http_client_source_interface                 = try("${try(local.device_config[each.value.name].system.http.client_source_interface_type, local.defaults.iosxe.configuration.system.http.client_source_interface_type)}${try(local.device_config[each.value.name].system.http.client_source_interface_id, local.defaults.iosxe.configuration.system.http.client_source_interface_id)}", null)
  ip_http_max_connections                         = try(local.device_config[each.value.name].system.http.max_connections, local.defaults.iosxe.configuration.system.http.max_connections, null)
  ip_http_secure_active_session_modules           = try(local.device_config[each.value.name].system.http.secure_active_session_modules, local.defaults.iosxe.configuration.system.http.secure_active_session_modules, null)
  ip_http_secure_server                           = try(local.device_config[each.value.name].system.http.secure_server, local.defaults.iosxe.configuration.system.http.secure_server, null)
  ip_http_secure_trustpoint                       = try(local.device_config[each.value.name].system.http.secure_trustpoint, local.defaults.iosxe.configuration.system.http.secure_trustpoint, null)
  ip_http_server                                  = try(local.device_config[each.value.name].system.http.server, local.defaults.iosxe.configuration.system.http.server, null)
  ip_http_tls_version                             = try(local.device_config[each.value.name].system.http.tls_version, local.defaults.iosxe.configuration.system.http.tls_version, null)

  ip_http_authentication_aaa_command_authorization = try(length(local.device_config[each.value.name].system.http.authentication_aaa_command_authorizations) == 0, true) ? null : [
    for cmd in local.device_config[each.value.name].system.http.authentication_aaa_command_authorizations : {
      level = try(cmd.level, local.defaults.iosxe.configuration.system.http.authentication_aaa_command_authorizations.level, null)
      name  = try(cmd.name, local.defaults.iosxe.configuration.system.http.authentication_aaa_command_authorizations.name, null)
    }
  ]

  ip_hosts = try(length([for host in local.device_config[each.value.name].system.ip_hosts : host if try(host.vrf, null) == null]) == 0, true) ? null : [
    for host in local.device_config[each.value.name].system.ip_hosts : {
      name = try(host.name, local.defaults.iosxe.configuration.system.ip_hosts.name, null)
      ips  = try(host.ips, local.defaults.iosxe.configuration.system.ip_hosts.ips, null)
    } if try(host.vrf, null) == null
  ]

  ip_hosts_vrf = try(length([for host in local.device_config[each.value.name].system.ip_hosts : host if try(host.vrf, null) != null]) == 0, true) ? null : [
    for vrf in distinct([for host in local.device_config[each.value.name].system.ip_hosts : host.vrf if try(host.vrf, null) != null]) : {
      vrf = vrf
      hosts = [
        for host in local.device_config[each.value.name].system.ip_hosts : {
          name = try(host.name, local.defaults.iosxe.configuration.system.ip_hosts.name, null)
          ips  = try(host.ips, local.defaults.iosxe.configuration.system.ip_hosts.ips, null)
        } if try(host.vrf, null) == vrf
      ]
    }
  ]

  subscriber_templating                              = try(local.device_config[each.value.name].system.subscriber_templating, local.defaults.iosxe.configuration.system.subscriber_templating, null)
  call_home_contact_email                            = try(local.device_config[each.value.name].system.call_home_contact_email, local.defaults.iosxe.configuration.system.call_home_contact_email, null)
  call_home_cisco_tac_1_profile_active               = try(local.device_config[each.value.name].system.call_home_cisco_tac_1_profile_active, local.defaults.iosxe.configuration.system.call_home_cisco_tac_1_profile_active, null)
  call_home_cisco_tac_1_destination_transport_method = try(local.device_config[each.value.name].system.call_home_cisco_tac_1_destination_transport_method, local.defaults.iosxe.configuration.system.call_home_cisco_tac_1_destination_transport_method, null)
  ip_ftp_passive                                     = try(local.device_config[each.value.name].system.ip_ftp_passive, local.defaults.iosxe.configuration.system.ip_ftp_passive, null)
  tftp_source_interface_loopback                     = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.tftp_source_interface_id, local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "FiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "TwoGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].system.tftp_source_interface_id, "$string "), local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  tftp_source_interface_vlan                         = try(local.device_config[each.value.name].system.tftp_source_interface_type, local.defaults.iosxe.configuration.system.tftp_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.tftp_source_interface_id, local.defaults.iosxe.configuration.system.tftp_source_interface_id, null) : null
  multilink_ppp_bundle_name                          = try(local.device_config[each.value.name].system.multilink_ppp_bundle_name, local.defaults.iosxe.configuration.system.multilink_ppp_bundle_name, null)

  ip_nbar_classification_dns_classify_by_domain = try(local.device_config[each.value.name].system.ip_nbar_classification_dns_classify_by_domain, local.defaults.iosxe.configuration.system.ip_nbar_classification_dns_classify_by_domain, null)
  ip_multicast_route_limit                      = try(local.device_config[each.value.name].system.ip_multicast_route_limit, local.defaults.iosxe.configuration.system.ip_multicast_route_limit, null)
  security_passwords_min_length                 = try(local.device_config[each.value.name].system.security_passwords_min_length, local.defaults.iosxe.configuration.system.security_passwords_min_length, null)
  ip_domain_list_names                          = try(local.device_config[each.value.name].system.ip_domain_list_names, local.defaults.iosxe.configuration.system.ip_domain_list_names, null)
  ip_domain_list_vrf_domain                     = try(local.device_config[each.value.name].system.ip_domain_list_vrf_domain, local.defaults.iosxe.configuration.system.ip_domain_list_vrf_domain, null)
  ip_domain_list_vrf                            = try(local.device_config[each.value.name].system.ip_domain_list_vrf, local.defaults.iosxe.configuration.system.ip_domain_list_vrf, null)
  ethernet_cfm_alarm_config_delay               = try(local.device_config[each.value.name].system.ethernet_cfm_alarm_config_delay, local.defaults.iosxe.configuration.system.ethernet_cfm_alarm_config_delay, null)
  ethernet_cfm_alarm_config_reset               = try(local.device_config[each.value.name].system.ethernet_cfm_alarm_config_reset, local.defaults.iosxe.configuration.system.ethernet_cfm_alarm_config_reset, null)

  standby_redirects                = try(local.device_config[each.value.name].system.standby_redirects, local.defaults.iosxe.configuration.system.standby_redirects, null) == "none" ? true : null
  standby_redirects_enable_disable = contains(["enable", "disable"], try(local.device_config[each.value.name].system.standby_redirects, local.defaults.iosxe.configuration.system.standby_redirects, "")) ? try(local.device_config[each.value.name].system.standby_redirects, local.defaults.iosxe.configuration.system.standby_redirects, null) : null

  track_objects = try(length(local.device_config[each.value.name].system.track_objects) == 0, true) ? null : [
    for track_obj in local.device_config[each.value.name].system.track_objects : {
      number              = try(track_obj.number, local.defaults.iosxe.configuration.system.track_objects.number, null)
      ip_sla_number       = try(track_obj.ip_sla_number, local.defaults.iosxe.configuration.system.track_objects.ip_sla_number, null)
      ip_sla_reachability = try(track_obj.ip_sla_reachability, local.defaults.iosxe.configuration.system.track_objects.ip_sla_reachability, null)
    }
  ]

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_policy_map.policy_map
  ]
}

resource "iosxe_sla" "sla" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].system.ip_sla, null) != null || try(local.defaults.iosxe.configuration.system.ip_sla, null) != null }
  device   = each.value.name

  entries = try(length(local.device_config[each.value.name].system.ip_sla.entries) == 0, true) ? null : [
    for entry in local.device_config[each.value.name].system.ip_sla.entries : {
      number                = try(entry.number, local.defaults.iosxe.configuration.system.ip_sla.entries.number, null)
      icmp_echo_destination = try(entry.icmp_echo_destination, local.defaults.iosxe.configuration.system.ip_sla.entries.icmp_echo_destination, null)
      icmp_echo_source_ip   = try(entry.icmp_echo_source_ip, local.defaults.iosxe.configuration.system.ip_sla.entries.icmp_echo_source_ip, null)
    }
  ]

  schedules = try(length(local.device_config[each.value.name].system.ip_sla.schedules) == 0, true) ? null : [
    for schedule in local.device_config[each.value.name].system.ip_sla.schedules : {
      entry_number   = try(schedule.entry_number, local.defaults.iosxe.configuration.system.ip_sla.schedules.entry_number, null)
      life           = try(schedule.life, local.defaults.iosxe.configuration.system.ip_sla.schedules.life, null)
      start_time_now = try(schedule.start_time_now, local.defaults.iosxe.configuration.system.ip_sla.schedules.start_time_now, null)
    }
  ]

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_policy_map.policy_map
  ]
}

resource "iosxe_platform" "platform" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].system.platform, null) != null || try(local.defaults.iosxe.configuration.system.platform, null) != null }
  device   = each.value.name

  punt_keepalive_disable_kernel_core        = try(local.device_config[each.value.name].system.platform.punt_keepalive_disable_kernel_core, local.defaults.iosxe.configuration.system.platform.punt_keepalive_disable_kernel_core, null)
  punt_keepalive_settings_fatal_count       = try(local.device_config[each.value.name].system.platform.punt_keepalive_settings_fatal_count, local.defaults.iosxe.configuration.system.platform.punt_keepalive_settings_fatal_count, null)
  punt_keepalive_settings_transmit_interval = try(local.device_config[each.value.name].system.platform.punt_keepalive_settings_transmit_interval, local.defaults.iosxe.configuration.system.platform.punt_keepalive_settings_transmit_interval, null)
  punt_keepalive_settings_warning_count     = try(local.device_config[each.value.name].system.platform.punt_keepalive_settings_warning_count, local.defaults.iosxe.configuration.system.platform.punt_keepalive_settings_warning_count, null)
}
