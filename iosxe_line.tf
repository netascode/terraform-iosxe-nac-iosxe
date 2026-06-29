resource "iosxe_line" "line" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].line, null) != null }
  device   = each.value.name

  console = try(length(local.device_config[each.value.name].line.consoles) == 0, true) ? null : [for c in local.device_config[each.value.name].line.consoles : {
    first                 = try(c.number, "0")
    exec_timeout_minutes  = try(c.exec_timeout_minutes, null)
    exec_timeout_seconds  = try(c.exec_timeout_seconds, null)
    login_authentication  = try(c.login_authentication, null)
    login_local           = try(c.login_local, null)
    password              = try(c.password, null)
    password_level        = try(c.password_level, null)
    password_type         = try(c.password_type, null)
    privilege_level       = try(c.privilege_level, null)
    stopbits              = try(c.stopbits, null)
    session_timeout       = try(c.session_timeout, null)
    monitor               = try(c.monitor, null)
    escape_character      = try(c.escape_character, null)
    logging_synchronous   = try(c.logging_synchronous, null)
    transport_output_all  = contains(try(c.transport_output, []), "all") ? true : null
    transport_output_none = contains(try(c.transport_output, []), "none") ? true : null
    transport_output      = length(setsubtract(try(c.transport_output, []), ["all", "none"])) > 0 ? setsubtract(try(c.transport_output, []), ["all", "none"])[0] : null
  }]

  vty = try(length(local.device_config[each.value.name].line.vtys) == 0, true) ? null : [for v in local.device_config[each.value.name].line.vtys : {
    first = v.number_from
    access_classes = try(length(v.access_classes) == 0, true) ? null : [for a in v.access_classes : {
      access_list = a.access_list
      direction   = a.direction
      vrf_also    = try(a.vrf_also, null)
    }]
    authorization_exec           = try(v.authorization_exec, null)
    authorization_exec_default   = try(v.authorization_exec_default, null)
    escape_character             = try(v.escape_character, null)
    exec_timeout_minutes         = try(v.exec_timeout_minutes, null)
    exec_timeout_seconds         = try(v.exec_timeout_seconds, null)
    password_level               = try(v.password_level, null)
    password_type                = try(v.password_type, null)
    password                     = try(v.password, null)
    last                         = try(v.number_to, v.number_from, null)
    login_authentication         = try(v.login_authentication, null)
    transport_preferred_protocol = try(v.transport_preferred_protocol, null)
    transport_input_all          = try(v.transport_input_all, null)
    transport_input_none         = try(v.transport_input_none, null)
    transport_input              = try(v.transport_input, null)
    session_timeout              = try(v.session_timeout, null)
    monitor                      = try(v.monitor, null)
    logging_synchronous          = try(v.logging_synchronous, null)
    transport_output_all         = contains(try(v.transport_output, []), "all") ? true : null
    transport_output_none        = contains(try(v.transport_output, []), "none") ? true : null
    transport_output             = length(setsubtract(try(v.transport_output, []), ["all", "none"])) > 0 ? setsubtract(try(v.transport_output, []), ["all", "none"])[0] : null
  }]

  aux = try(length(local.device_config[each.value.name].line.auxes) == 0, true) ? null : [for a in local.device_config[each.value.name].line.auxes : {
    first                 = try(a.number, null)
    exec_timeout_minutes  = try(a.exec_timeout_minutes, null)
    exec_timeout_seconds  = try(a.exec_timeout_seconds, null)
    monitor               = try(a.monitor, null)
    stopbits              = try(a.stopbits, null)
    password              = try(a.password, null)
    password_level        = try(a.password_level, null)
    password_type         = try(a.password_type, null)
    escape_character      = try(a.escape_character, null)
    logging_synchronous   = try(a.logging_synchronous, null)
    transport_output_none = contains(try(a.transport_output, []), "none") ? true : null
  }]

  depends_on = [
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}