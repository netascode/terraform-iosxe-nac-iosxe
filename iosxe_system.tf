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
  # ip_ssh_authentication_retries      = try(local.device_config[each.value.name].system.ssh.authentication_retries, local.defaults.iosxe.configuration.system.ssh.authentication_retries, null)
  # ip_ssh_time_out                    = try(local.device_config[each.value.name].system.ssh.time_out, local.defaults.iosxe.configuration.system.ssh.time_out, null)
  ip_ssh_version                      = try(local.device_config[each.value.name].system.ssh.version, local.defaults.iosxe.configuration.system.ssh.version, null)
  memory_free_low_watermark_processor = try(local.device_config[each.value.name].system.memory_free_low_watermark_processor, local.defaults.iosxe.configuration.system.memory_free_low_watermark_processor, null)
  redundancy                          = try(local.device_config[each.value.name].system.redundancy, local.defaults.iosxe.configuration.system.redundancy, null)
  redundancy_mode                     = try(local.device_config[each.value.name].system.redundancy_mode, local.defaults.iosxe.configuration.system.redundancy_mode, null)
  transceiver_type_all_monitoring     = try(local.device_config[each.value.name].system.transceiver_type_all_monitoring, local.defaults.iosxe.configuration.system.transceiver_type_all_monitoring, null)

  # Interface-based source interface mappings
  ip_domain_lookup_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "FiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "FortyGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "GigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "HundredGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_loopback                     = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "TenGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "TwoGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null
  ip_domain_lookup_source_interface_vlan                         = try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_type, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ip_domain_lookup_source_interface_id, local.defaults.iosxe.configuration.system.ip_domain_lookup_source_interface_id, null) : null

  ip_radius_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "FiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "FortyGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "GigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "HundredGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_loopback                     = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "TenGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "TwoGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_vlan                         = try(local.device_config[each.value.name].system.ip_radius_source_interface_type, local.defaults.iosxe.configuration.system.ip_radius_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ip_radius_source_interface_id, local.defaults.iosxe.configuration.system.ip_radius_source_interface_id, null) : null
  ip_radius_source_interface_vrf                          = try(local.device_config[each.value.name].system.ip_radius_source_interface_vrf, local.defaults.iosxe.configuration.system.ip_radius_source_interface_vrf, null)

  ip_ssh_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "FiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "FortyGigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "GigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "HundredGigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_loopback                     = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "TenGigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "TwoGigabitEthernet" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null
  ip_ssh_source_interface_vlan                         = try(local.device_config[each.value.name].system.ssh.source_interface_type, local.defaults.iosxe.configuration.system.ssh.source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ssh.source_interface_id, local.defaults.iosxe.configuration.system.ssh.source_interface_id, null) : null

  ip_tacacs_source_interface_five_gigabit_ethernet        = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "FiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_forty_gigabit_ethernet       = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "FortyGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_gigabit_ethernet             = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "GigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_hundred_gigabit_ethernet     = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "HundredGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_loopback                     = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_ten_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "TenGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_twenty_five_gigabit_ethernet = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "TwentyFiveGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_two_gigabit_ethernet         = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "TwoGigabitEthernet" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_vlan                         = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_type, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].system.ip_tacacs_source_interface_id, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_id, null) : null
  ip_tacacs_source_interface_vrf                          = try(local.device_config[each.value.name].system.ip_tacacs_source_interface_vrf, local.defaults.iosxe.configuration.system.ip_tacacs_source_interface_vrf, null)

  # Simple list attributes
  ip_name_servers = try(local.device_config[each.value.name].system.ip_name_servers, local.defaults.iosxe.configuration.system.ip_name_servers, null)

  multicast_routing_vrfs = [
    for mrv in try(local.device_config[each.value.name].system.multicast_routing_vrfs, []) : {
      vrf         = mrv.vrf
      distributed = try(mrv.distributed, null)
    }
  ]

  # Nested list structures
  boot_system_bootfiles = [
    for bootfile in try(local.device_config[each.value.name].system.boot_system_bootfiles, []) : {
      path = bootfile
    }
  ]

  boot_system_flash_files = [
    for flashfile in try(local.device_config[each.value.name].system.boot_system_flash_files, []) : {
      path = flashfile
    }
  ]

  ip_name_servers_vrf = [
    for vrf in try(local.device_config[each.value.name].system.ip_name_servers_vrf, []) : {
      vrf     = vrf.vrf
      servers = try(vrf.servers, local.defaults.iosxe.configuration.system.ip_name_servers_vrf.servers, null)
    }
  ]

  pnp_profiles = [
    for profile in try(local.device_config[each.value.name].system.pnp_profiles, []) : {
      name                              = profile.name
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

  ip_http_authentication_aaa_command_authorization = [
    for cmd in try(local.device_config[each.value.name].system.http.authentication_aaa_command_authorizations, []) : {
      level = cmd.level
      name  = try(cmd.name, null)
    }
  ]
}

