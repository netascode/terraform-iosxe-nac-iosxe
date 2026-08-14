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
    transport_output      = length(setsubtract(try(c.transport_output, []), ["all", "none"])) > 0 ? tolist(setsubtract(try(c.transport_output, []), ["all", "none"])) : null
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
    transport_output             = length(setsubtract(try(v.transport_output, []), ["all", "none"])) > 0 ? tolist(setsubtract(try(v.transport_output, []), ["all", "none"])) : null
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

  lifecycle {
    precondition {
      condition = alltrue(flatten([
        for c in try(local.device_config[each.value.name].line.consoles, []) : [
          for p in try(c.transport_output, []) : contains(["acercon", "all", "lapb-ta", "lat", "mop", "nasi", "none", "pad", "rlogin", "ssh", "telnet", "udptn", "v120"], p)
        ]
      ]))
      error_message = "Invalid transport_output value in line.consoles for device ${each.value.name}. Valid choices (Cisco-IOS-XE-line.yang, 17.15.1): acercon, all, lapb-ta, lat, mop, nasi, none, pad, rlogin, ssh, telnet, udptn, v120."
    }

    precondition {
      condition = alltrue(flatten([
        for v in try(local.device_config[each.value.name].line.vtys, []) : [
          for p in try(v.transport_output, []) : contains(["acercon", "all", "lapb-ta", "lat", "mop", "nasi", "none", "pad", "rlogin", "ssh", "telnet", "udptn", "v120"], p)
        ]
      ]))
      error_message = "Invalid transport_output value in line.vtys for device ${each.value.name}. Valid choices (Cisco-IOS-XE-line.yang, 17.15.1): acercon, all, lapb-ta, lat, mop, nasi, none, pad, rlogin, ssh, telnet, udptn, v120."
    }

    precondition {
      condition = alltrue(flatten([
        for v in try(local.device_config[each.value.name].line.vtys, []) : [
          for p in try(v.transport_input, []) : contains(["acercon", "lapb-ta", "lat", "mop", "nasi", "pad", "rlogin", "ssh", "telnet", "udptn", "v120"], p)
        ]
      ]))
      error_message = "Invalid transport_input value in line.vtys for device ${each.value.name}. Valid choices (Cisco-IOS-XE-line.yang, 17.15.1): acercon, lapb-ta, lat, mop, nasi, pad, rlogin, ssh, telnet, udptn, v120. Use transport_input_all / transport_input_none for the all/none keywords -- this module passes transport_input straight through to the provider, unlike transport_output, so 'all'/'none' here would be rejected by the device."
    }

    precondition {
      condition = alltrue([
        for v in try(local.device_config[each.value.name].line.vtys, []) :
        try(v.transport_preferred_protocol, null) == null || contains(["acercon", "lat", "mop", "nasi", "none", "pad", "rlogin", "ssh", "telnet", "udptn"], v.transport_preferred_protocol)
      ])
      error_message = "Invalid transport_preferred_protocol value in line.vtys for device ${each.value.name}. Valid choices (Cisco-IOS-XE-line.yang, 17.15.1): acercon, lat, mop, nasi, none, pad, rlogin, ssh, telnet, udptn."
    }

    precondition {
      condition = alltrue([
        for c in try(local.device_config[each.value.name].line.consoles, []) :
        !(contains(try(c.transport_output, []), "all") || contains(try(c.transport_output, []), "none")) || length(try(c.transport_output, [])) == 1
      ])
      error_message = "transport_output in line.consoles for device ${each.value.name} combines \"all\" or \"none\" with other protocols (or with each other). Per the YANG transport/output choice these are mutually exclusive -- specify either \"all\" alone, \"none\" alone, or a list of concrete protocol names."
    }

    precondition {
      condition = alltrue([
        for v in try(local.device_config[each.value.name].line.vtys, []) :
        !(contains(try(v.transport_output, []), "all") || contains(try(v.transport_output, []), "none")) || length(try(v.transport_output, [])) == 1
      ])
      error_message = "transport_output in line.vtys for device ${each.value.name} combines \"all\" or \"none\" with other protocols (or with each other). Per the YANG transport/output choice these are mutually exclusive -- specify either \"all\" alone, \"none\" alone, or a list of concrete protocol names."
    }

    precondition {
      condition = alltrue([
        for v in try(local.device_config[each.value.name].line.vtys, []) :
        !(try(v.transport_input_all, false) == true && try(v.transport_input_none, false) == true)
      ])
      error_message = "transport_input_all and transport_input_none cannot both be true on the same vty line for device ${each.value.name}."
    }

    precondition {
      condition = alltrue([
        for v in try(local.device_config[each.value.name].line.vtys, []) :
        !((try(v.transport_input_all, false) == true || try(v.transport_input_none, false) == true) && length(try(v.transport_input, [])) > 0)
      ])
      error_message = "transport_input_all/transport_input_none cannot be combined with a non-empty transport_input protocol list on the same vty line for device ${each.value.name}. Per the YANG transport/input choice these are mutually exclusive."
    }
  }
}