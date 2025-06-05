resource "iosxe_system" "http" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].system, null) != null || try(local.defaults.iosxe.configuration.system, null) != null }
  device   = each.value.name

  ip_http_access_class                            = try(local.device_config[each.value.name].system.http.access_class, local.defaults.iosxe.configuration.system.http.access_class, null)
  ip_http_active_session_modules                  = try(local.device_config[each.value.name].system.http.active_session_modules, local.defaults.iosxe.configuration.system.http.active_session_modules, null)
  ip_http_authentication_aaa                      = try(local.device_config[each.value.name].system.http.authentication_aaa, local.defaults.iosxe.configuration.system.http.authentication_aaa, null)
  ip_http_authentication_aaa_exec_authorization   = try(local.device_config[each.value.name].system.http.authentication_aaa_exec_authorization, local.defaults.iosxe.configuration.system.http.authentication_aaa_exec_authorization, null)
  ip_http_authentication_aaa_login_authentication = try(local.device_config[each.value.name].system.http.authentication_aaa_login_authentication, local.defaults.iosxe.configuration.system.http.authentication_aaa_login_authentication, null)
  ip_http_authentication_local                    = try(local.device_config[each.value.name].system.http.authentication_local, local.defaults.iosxe.configuration.system.http.authentication_local, null)
  ip_http_client_secure_trustpoint                = try(local.device_config[each.value.name].system.http.client_secure_trustpoint, local.defaults.iosxe.configuration.system.http.client_secure_trustpoint, null)
  ip_http_client_source_interface                 = try(local.device_config[each.value.name].system.http.client_source_interface, local.defaults.iosxe.configuration.system.http.client_source_interface, null)
  ip_http_max_connections                         = try(local.device_config[each.value.name].system.http.max_connections, local.defaults.iosxe.configuration.system.http.max_connections, null)
  ip_http_secure_active_session_modules           = try(local.device_config[each.value.name].system.http.secure_active_session_modules, local.defaults.iosxe.configuration.system.http.secure_active_session_modules, null)
  ip_http_secure_server                           = try(local.device_config[each.value.name].system.http.secure_server, local.defaults.iosxe.configuration.system.http.secure_server, null)
  ip_http_secure_trustpoint                       = try(local.device_config[each.value.name].system.http.secure_trustpoint, local.defaults.iosxe.configuration.system.http.secure_trustpoint, null)
  ip_http_server                                  = try(local.device_config[each.value.name].system.http.server, local.defaults.iosxe.configuration.system.http.server, null)
  ip_http_tls_version                             = try(local.device_config[each.value.name].system.http.tls_version, local.defaults.iosxe.configuration.system.http.tls_version, null)

  ip_http_authentication_aaa_command_authorization = [
    for cmd in try(local.device_config[each.value.name].system.http.authentication_aaa_command_authorization, []) : {
      level = cmd.level
      name  = try(cmd.name, null)
    }
  ]

}