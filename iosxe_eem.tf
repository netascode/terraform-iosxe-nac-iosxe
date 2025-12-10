locals {
  eem = flatten([
    for device in local.devices : [
      try(local.device_config[device.name].eem, null) != null ? {
        key    = device.name
        device = device.name

        environment_variables = try(length(local.device_config[device.name].eem.environment_variables) == 0, true) ? null : [
          for env in try(local.device_config[device.name].eem.environment_variables, []) : {
            name  = try(env.name, local.defaults.iosxe.configuration.eem.environment_variables.name, null)
            value = try(env.value, local.defaults.iosxe.configuration.eem.environment_variables.value, null)
          }
        ]

        session_cli_username           = try(local.device_config[device.name].eem.session_cli_username, local.defaults.iosxe.configuration.eem.session_cli_username, null)
        session_cli_username_privilege = try(local.device_config[device.name].eem.session_cli_username_privilege, local.defaults.iosxe.configuration.eem.session_cli_username_privilege, null)
        history_size_events            = try(local.device_config[device.name].eem.history_size_events, local.defaults.iosxe.configuration.eem.history_size_events, null)
        history_size_traps             = try(local.device_config[device.name].eem.history_size_traps, local.defaults.iosxe.configuration.eem.history_size_traps, null)
        directory_user_policy          = try(local.device_config[device.name].eem.directory_user_policy, local.defaults.iosxe.configuration.eem.directory_user_policy, null)
        detector_rpc_max_sessions      = try(local.device_config[device.name].eem.detector_rpc_max_sessions, local.defaults.iosxe.configuration.eem.detector_rpc_max_sessions, null)
        detector_routing_bootup_delay  = try(local.device_config[device.name].eem.detector_routing_bootup_delay, local.defaults.iosxe.configuration.eem.detector_routing_bootup_delay, null)

        # Scheduler thread class - for now, use first entry if list exists
        scheduler_applet_thread_class_default = try(
          length(local.device_config[device.name].eem.scheduler_applet_thread_classes) > 0 ?
          contains(local.device_config[device.name].eem.scheduler_applet_thread_classes[0].classes, "default") : false,
          local.defaults.iosxe.configuration.eem.scheduler_applet_thread_classes.classes,
          null
        )
        scheduler_applet_thread_class_number = try(
          length(local.device_config[device.name].eem.scheduler_applet_thread_classes) > 0 ?
          local.device_config[device.name].eem.scheduler_applet_thread_classes[0].number : null,
          local.defaults.iosxe.configuration.eem.scheduler_applet_thread_classes.number,
          null
        )

        applets = try(length(local.device_config[device.name].eem.applets) == 0, true) ? null : [
          for applet in try(local.device_config[device.name].eem.applets, []) : {
            name          = try(applet.name, local.defaults.iosxe.configuration.eem.applets.name, null)
            authorization = try(applet.authorization, local.defaults.iosxe.configuration.eem.applets.authorization, null)
            class         = try(applet.class, local.defaults.iosxe.configuration.eem.applets.class, null)
            description   = try(applet.description, local.defaults.iosxe.configuration.eem.applets.description, null)

            # Timer Watchdog Event
            event_timer_watchdog_time      = try(applet.event.timer_watchdog.time, local.defaults.iosxe.configuration.eem.applets.event.timer_watchdog.time, null)
            event_timer_watchdog_name      = try(applet.event.timer_watchdog.name, local.defaults.iosxe.configuration.eem.applets.event.timer_watchdog.name, null)
            event_timer_watchdog_maxrun    = try(applet.event.timer_watchdog.maxrun, local.defaults.iosxe.configuration.eem.applets.event.timer_watchdog.maxrun, null)
            event_timer_watchdog_ratelimit = try(applet.event.timer_watchdog.ratelimit, local.defaults.iosxe.configuration.eem.applets.event.timer_watchdog.ratelimit, null)

            # Timer Cron Event
            event_timer_cron_entry     = try(applet.event.timer_cron.cron_entry, local.defaults.iosxe.configuration.eem.applets.event.timer_cron.cron_entry, null)
            event_timer_cron_name      = try(applet.event.timer_cron.name, local.defaults.iosxe.configuration.eem.applets.event.timer_cron.name, null)
            event_timer_cron_maxrun    = try(applet.event.timer_cron.maxrun, local.defaults.iosxe.configuration.eem.applets.event.timer_cron.maxrun, null)
            event_timer_cron_ratelimit = try(applet.event.timer_cron.ratelimit, local.defaults.iosxe.configuration.eem.applets.event.timer_cron.ratelimit, null)

            # Syslog Event
            event_syslog_pattern   = try(applet.event.syslog.pattern, local.defaults.iosxe.configuration.eem.applets.event.syslog.pattern, null)
            event_syslog_occurs    = try(applet.event.syslog.occurs, local.defaults.iosxe.configuration.eem.applets.event.syslog.occurs, null)
            event_syslog_maxrun    = try(applet.event.syslog.maxrun, local.defaults.iosxe.configuration.eem.applets.event.syslog.maxrun, null)
            event_syslog_ratelimit = try(applet.event.syslog.ratelimit, local.defaults.iosxe.configuration.eem.applets.event.syslog.ratelimit, null)
            event_syslog_period    = try(applet.event.syslog.period, local.defaults.iosxe.configuration.eem.applets.event.syslog.period, null)

            # CLI Event
            event_cli_pattern = try(applet.event.cli.pattern, local.defaults.iosxe.configuration.eem.applets.event.cli.pattern, null)
            event_cli_sync    = try(applet.event.cli.sync, local.defaults.iosxe.configuration.eem.applets.event.cli.sync, null)
            event_cli_skip    = try(applet.event.cli.skip, local.defaults.iosxe.configuration.eem.applets.event.cli.skip, null)

            # Actions
            actions = try(length(applet.actions) == 0, true) ? null : [
              for action in try(applet.actions, []) : {
                name = try(action.sequence, local.defaults.iosxe.configuration.eem.applets.actions.sequence, null)

                # CLI Command action
                cli_command = try(action.cli_command, local.defaults.iosxe.configuration.eem.applets.actions.cli_command, null)

                # Regexp action
                regexp_string_pattern = try(action.regexp.pattern, local.defaults.iosxe.configuration.eem.applets.actions.regexp.pattern, null)
                regexp_string_input   = try(action.regexp.input, local.defaults.iosxe.configuration.eem.applets.actions.regexp.input, null)
                regexp_string_match   = try(action.regexp.match_variable, local.defaults.iosxe.configuration.eem.applets.actions.regexp.match_variable, null)
                regexp_string_match1  = try(action.regexp.submatch1, local.defaults.iosxe.configuration.eem.applets.actions.regexp.submatch1, null)
                regexp_string_match2  = try(action.regexp.submatch2, local.defaults.iosxe.configuration.eem.applets.actions.regexp.submatch2, null)
                regexp_string_match3  = try(action.regexp.submatch3, local.defaults.iosxe.configuration.eem.applets.actions.regexp.submatch3, null)

                # Set action
                set_varname = try(action.set.variable_name, local.defaults.iosxe.configuration.eem.applets.actions.set.variable_name, null)
                set_value   = try(action.set.variable_value, local.defaults.iosxe.configuration.eem.applets.actions.set.variable_value, null)

                # Foreach action
                foreach_loopvar   = try(action.foreach.loop_variable, local.defaults.iosxe.configuration.eem.applets.actions.foreach.loop_variable, null)
                foreach_iterator  = try(action.foreach.list_variable, local.defaults.iosxe.configuration.eem.applets.actions.foreach.list_variable, null)
                foreach_delimiter = try(action.foreach.delimiter, local.defaults.iosxe.configuration.eem.applets.actions.foreach.delimiter, null)

                # If action
                if_string_op_1 = try(action.if_statement.operand1, local.defaults.iosxe.configuration.eem.applets.actions.if_statement.operand1, null)
                if_keyword     = try(action.if_statement.operator, local.defaults.iosxe.configuration.eem.applets.actions.if_statement.operator, null)
                if_string_op_2 = try(action.if_statement.operand2, local.defaults.iosxe.configuration.eem.applets.actions.if_statement.operand2, null)

                # Control flow - all are boolean attributes
                "else"   = try(action.else_statement != null ? true : false, local.defaults.iosxe.configuration.eem.applets.actions.else_statement, null)
                end      = try(action.end_statement != null ? true : false, local.defaults.iosxe.configuration.eem.applets.actions.end_statement, null)
                continue = try(action.continue_statement != null ? true : false, local.defaults.iosxe.configuration.eem.applets.actions.continue_statement, null)
                exit     = try(action.exit_statement != null ? true : false, local.defaults.iosxe.configuration.eem.applets.actions.exit_statement, null)

                # Wait action
                wait = try(action.wait, local.defaults.iosxe.configuration.eem.applets.actions.wait, null)

                # String trim action - trims whitespace from string
                string_trim = try(action.string_trim, local.defaults.iosxe.configuration.eem.applets.actions.string_trim, null)

                # String first action - finds first occurrence of substring in string
                string_first_string_op_1 = try(action.string_first.string, local.defaults.iosxe.configuration.eem.applets.actions.string_first.string, null)
                string_first_string_op_2 = try(action.string_first.substring, local.defaults.iosxe.configuration.eem.applets.actions.string_first.substring, null)
              }
            ]
          }
        ]
      } : null
    ] if try(local.device_config[device.name].eem, null) != null
  ])
}

resource "iosxe_eem" "eem" {
  for_each = { for e in local.eem : e.key => e }
  device   = each.value.device

  environment_variables                 = each.value.environment_variables
  session_cli_username                  = each.value.session_cli_username
  session_cli_username_privilege        = each.value.session_cli_username_privilege
  history_size_events                   = each.value.history_size_events
  history_size_traps                    = each.value.history_size_traps
  directory_user_policy                 = each.value.directory_user_policy
  scheduler_applet_thread_class_default = each.value.scheduler_applet_thread_class_default
  scheduler_applet_thread_class_number  = each.value.scheduler_applet_thread_class_number
  detector_rpc_max_sessions             = each.value.detector_rpc_max_sessions
  detector_routing_bootup_delay         = each.value.detector_routing_bootup_delay
  applets                               = each.value.applets
}
