resource "iosxe_line" "line" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].line, null) != null || try(local.defaults.iosxe.configuration.line, null) != null }
  device   = each.value.name

  console = try(length(local.device_config[each.value.name].line.consoles) == 0, true) ? null : [for c in local.device_config[each.value.name].line.consoles : {
    first                = "0"
    exec_timeout_minutes = try(c.exec_timeout_minutes, local.defaults.iosxe.configuration.line.consoles.exec_timeout_minutes, null)
    exec_timeout_seconds = try(c.exec_timeout_seconds, local.defaults.iosxe.configuration.line.consoles.exec_timeout_seconds, null)
    login_authentication = try(c.login_authentication, local.defaults.iosxe.configuration.line.consoles.login_authentication, null)
    login_local          = try(c.login_local, local.defaults.iosxe.configuration.line.consoles.login_local, null)
    password             = try(c.password, local.defaults.iosxe.configuration.line.consoles.password, null)
    password_level       = try(c.password_level, local.defaults.iosxe.configuration.line.consoles.password_level, null)
    password_type        = try(c.password_type, local.defaults.iosxe.configuration.line.consoles.password_type, null)
    privilege_level      = try(c.privilege_level, local.defaults.iosxe.configuration.line.consoles.privilege_level, null)
    stopbits             = try(c.stopbits, local.defaults.iosxe.configuration.line.consoles.stopbits, null)
  }]

  vty = try(length(local.device_config[each.value.name].line.vtys) == 0, true) ? null : [for v in local.device_config[each.value.name].line.vtys : {
    first = v.number_from
    access_classes = try(length(v.access_classes) == 0, true) ? null : [for a in v.access_classes : {
      access_list = a.access_list
      direction   = a.direction
      vrf_also    = try(a.vrf_also, local.defaults.iosxe.configuration.line.vtys.access_classes.vrf_also, null)
    }]
    authorization_exec           = try(v.authorization_exec, local.defaults.iosxe.configuration.line.vtys.authorization_exec, null)
    authorization_exec_default   = try(v.authorization_exec_default, local.defaults.iosxe.configuration.line.vtys.authorization_exec_default, null)
    escape_character             = try(v.escape_character, local.defaults.iosxe.configuration.line.vtys.escape_character, null)
    exec_timeout_minutes         = try(v.exec_timeout_minutes, local.defaults.iosxe.configuration.line.vtys.exec_timeout_minutes, null)
    exec_timeout_seconds         = try(v.exec_timeout_seconds, local.defaults.iosxe.configuration.line.vtys.exec_timeout_seconds, null)
    password_level               = try(v.password_level, local.defaults.iosxe.configuration.line.vtys.password_level, null)
    password_type                = try(v.password_type, local.defaults.iosxe.configuration.line.vtys.password_type, null)
    password                     = try(v.password, local.defaults.iosxe.configuration.line.vtys.password, null)
    last                         = try(v.number_to, v.number_from, null)
    login_authentication         = try(v.login_authentication, local.defaults.iosxe.configuration.line.vtys.login_authentication, null)
    transport_preferred_protocol = try(v.transport_preferred_protocol, local.defaults.iosxe.configuration.line.vtys.transport_preferred_protocol, null)
    transport_input_all          = try(v.transport_input_all, local.defaults.iosxe.configuration.line.vtys.transport_input_all, null)
    transport_input_none         = try(v.transport_input_none, local.defaults.iosxe.configuration.line.vtys.transport_input_none, null)
    transport_input              = try(v.transport_input, local.defaults.iosxe.configuration.line.vtys.transport_input, null)
  }]

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}