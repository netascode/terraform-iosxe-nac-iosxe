locals {
  eem = flatten([
    for device in local.devices : [
      try(local.device_config[device.name].eem, null) != null ? {
        key    = device.name
        device = device.name

        environment_variables = try(length(local.device_config[device.name].eem.environment_variables) == 0, true) ? null : [
          for env in try(local.device_config[device.name].eem.environment_variables, []) : {
            name  = try(env.name, null)
            value = try(env.value, null)
          }
        ]

        session_cli_username           = try(local.device_config[device.name].eem.session_cli_username, null)
        session_cli_username_privilege = try(local.device_config[device.name].eem.session_cli_username_privilege, null)
        history_size_events            = try(local.device_config[device.name].eem.history_size_events, null)
        history_size_traps             = try(local.device_config[device.name].eem.history_size_traps, null)
        directory_user_policy          = try(local.device_config[device.name].eem.directory_user_policy, null)
        detector_routing_bootup_delay  = try(local.device_config[device.name].eem.detector_routing_bootup_delay, null)

        # Scheduler thread class
        scheduler_applet_thread_class_default = try(contains(local.device_config[device.name].eem.scheduler_applet_thread_class.classes, "default"), null)
        scheduler_applet_thread_class_number  = try(local.device_config[device.name].eem.scheduler_applet_thread_class.number, null)

        applets = try(length(local.device_config[device.name].eem.applets) == 0, true) ? null : [
          for applet in try(local.device_config[device.name].eem.applets, []) : {
            name          = try(applet.name, null)
            authorization = try(applet.authorization, null)
            class         = try(applet.class, null)
            description   = try(applet.description, null)

            # Timer Watchdog Event
            event_timer_watchdog_time      = try(applet.event.timer_watchdog.time, null)
            event_timer_watchdog_name      = try(applet.event.timer_watchdog.name, null)
            event_timer_watchdog_maxrun    = try(applet.event.timer_watchdog.maxrun, null)
            event_timer_watchdog_ratelimit = try(applet.event.timer_watchdog.ratelimit, null)

            # Timer Cron Event
            event_timer_cron_entry     = try(applet.event.timer_cron.cron_entry, null)
            event_timer_cron_name      = try(applet.event.timer_cron.name, null)
            event_timer_cron_maxrun    = try(applet.event.timer_cron.maxrun, null)
            event_timer_cron_ratelimit = try(applet.event.timer_cron.ratelimit, null)

            # Syslog Event
            event_syslog_pattern   = try(applet.event.syslog.pattern, null)
            event_syslog_occurs    = try(applet.event.syslog.occurs, null)
            event_syslog_maxrun    = try(applet.event.syslog.maxrun, null)
            event_syslog_ratelimit = try(applet.event.syslog.ratelimit, null)
            event_syslog_period    = try(applet.event.syslog.period, null)

            # CLI Event
            event_cli_pattern = try(applet.event.cli.pattern, null)
            event_cli_sync    = try(applet.event.cli.sync, null)
            event_cli_skip    = try(applet.event.cli.skip, null)

            # Actions
            actions = try(length(applet.actions) == 0, true) ? null : [
              for action in try(applet.actions, []) : {
                name = try(action.sequence, null)

                # CLI Command action
                cli_command = try(action.cli_command, null)

                # Regexp action
                regexp_string_pattern = try(action.regexp.pattern, null)
                regexp_string_input   = try(action.regexp.input, null)
                regexp_string_match   = try(action.regexp.match_variable, null)
                regexp_string_match1  = try(action.regexp.submatch1, null)
                regexp_string_match2  = try(action.regexp.submatch2, null)
                regexp_string_match3  = try(action.regexp.submatch3, null)

                # Set action
                set_varname = try(action.set.variable_name, null)
                set_value   = try(action.set.variable_value, null)

                # Foreach action
                foreach_loopvar   = try(action.foreach.loop_variable, null)
                foreach_iterator  = try(action.foreach.list_variable, null)
                foreach_delimiter = try(action.foreach.delimiter, null)

                # If action
                if_string_op_1 = try(action.if_statement.operand1, null)
                if_keyword     = try(action.if_statement.operator, null)
                if_string_op_2 = try(action.if_statement.operand2, null)

                # Control flow - all are boolean attributes
                "else"   = try(action.else_statement != null ? true : false, null)
                end      = try(action.end_statement != null ? true : false, null)
                continue = try(action.continue_statement != null ? true : false, null)
                exit     = try(action.exit_statement != null ? true : false, null)

                # Wait action
                wait = try(action.wait, null)

                # String trim action - trims whitespace from string
                string_trim = try(action.string_trim, null)

                # String first action - finds first occurrence of substring in string
                string_first_string_op_1 = try(action.string_first.string, null)
                string_first_string_op_2 = try(action.string_first.substring, null)
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
  detector_routing_bootup_delay         = each.value.detector_routing_bootup_delay
  applets                               = each.value.applets
}
