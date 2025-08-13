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

  multicast_routing_vrfs = [
    for mrv in try(local.device_config[each.value.name].system.multicast_routing_vrfs, []) : {
      vrf         = mrv.vrf
      distributed = try(mrv.distributed, null)
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

