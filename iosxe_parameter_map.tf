locals {
  parameter_maps = flatten([
    for device in local.devices : [
      for pm in try(local.device_config[device.name].policy.parameter_maps, []) : {
        key                                = format("%s/%s", device.name, pm.name)
        device                             = device.name
        name                               = try(pm.name, null)
        type                               = try(pm.type, null)
        alert                              = try(pm.alert, null)
        application_inspect_dns            = try(pm.application_inspect_dns, null)
        application_inspect_exec           = try(pm.application_inspect_exec, null)
        application_inspect_ftp            = try(pm.application_inspect_ftp, null)
        application_inspect_gtp            = try(pm.application_inspect_gtp, null)
        application_inspect_h323           = try(pm.application_inspect_h323, null)
        application_inspect_http           = try(pm.application_inspect_http, null)
        application_inspect_imap           = try(pm.application_inspect_imap, null)
        application_inspect_login          = try(pm.application_inspect_login, null)
        application_inspect_msrpc          = try(pm.application_inspect_msrpc, null)
        application_inspect_netbios        = try(pm.application_inspect_netbios, null)
        application_inspect_pop3           = try(pm.application_inspect_pop3, null)
        application_inspect_rtsp           = try(pm.application_inspect_rtsp, null)
        application_inspect_shell          = try(pm.application_inspect_shell, null)
        application_inspect_sip            = try(pm.application_inspect_sip, null)
        application_inspect_skinny         = try(pm.application_inspect_skinny, null)
        application_inspect_smtp           = try(pm.application_inspect_smtp, null)
        application_inspect_sunrpc         = try(pm.application_inspect_sunrpc, null)
        application_inspect_tftp           = try(pm.application_inspect_tftp, null)
        audit_trail                        = try(pm.audit_trail, null)
        dns_timeout                        = try(pm.dns_timeout, null)
        icmp_idle_time                     = try(pm.icmp_idle_time, null)
        icmp_idle_time_ageout              = try(pm.icmp_idle_time_ageout, null)
        icmp_unreachable_allow             = try(pm.icmp_unreachable_allow, null)
        log_dropped_packets                = try(pm.log_dropped_packets, null)
        log_flow                           = try(pm.log_flow, null)
        max_incomplete_high                = try(pm.max_incomplete_high, null)
        max_incomplete_low                 = try(pm.max_incomplete_low, null)
        one_minute_high                    = try(pm.one_minute_high, null)
        one_minute_low                     = try(pm.one_minute_low, null)
        sessions_maximum                   = try(pm.sessions_maximum, null)
        sessions_packet                    = try(pm.sessions_packet, null)
        sessions_rate_high                 = try(pm.sessions_rate_high, null)
        sessions_rate_high_time            = try(pm.sessions_rate_high_time, null)
        sessions_rate_low                  = try(pm.sessions_rate_low, null)
        sessions_rate_low_time             = try(pm.sessions_rate_low_time, null)
        tcp_finwait_time                   = try(pm.tcp_finwait_time, null)
        tcp_finwait_time_ageout            = try(pm.tcp_finwait_time_ageout, null)
        tcp_half_close_reset_off           = try(pm.tcp_half_close_reset_off, null)
        tcp_half_open_reset_off            = try(pm.tcp_half_open_reset_off, null)
        tcp_idle_reset_off                 = try(pm.tcp_idle_reset_off, null)
        tcp_idle_time                      = try(pm.tcp_idle_time, null)
        tcp_idle_time_ageout               = try(pm.tcp_idle_time_ageout, null)
        tcp_max_incomplete_host            = try(pm.tcp_max_incomplete_host, null)
        tcp_max_incomplete_host_block_time = try(pm.tcp_max_incomplete_host_block_time, null)
        tcp_synwait_time                   = try(pm.tcp_synwait_time, null)
        tcp_synwait_time_ageout            = try(pm.tcp_synwait_time_ageout, null)
        tcp_window_scale_enforcement_loose = try(pm.tcp_window_scale_enforcement_loose, null)
        udp_half_open_idle_time            = try(pm.udp_half_open_idle_time, null)
        udp_half_open_idle_time_ageout     = try(pm.udp_half_open_idle_time_ageout, null)
        udp_idle_time                      = try(pm.udp_idle_time, null)
        udp_idle_time_ageout               = try(pm.udp_idle_time_ageout, null)
        zone_mismatch_drop                 = try(pm.zone_mismatch_drop, null)
      }
    ]
  ])
}

resource "iosxe_parameter_map" "parameter_map" {
  for_each = { for e in local.parameter_maps : e.key => e }
  device   = each.value.device

  name                               = each.value.name
  alert                              = each.value.alert
  application_inspect_dns            = each.value.application_inspect_dns
  application_inspect_exec           = each.value.application_inspect_exec
  application_inspect_ftp            = each.value.application_inspect_ftp
  application_inspect_gtp            = each.value.application_inspect_gtp
  application_inspect_h323           = each.value.application_inspect_h323
  application_inspect_http           = each.value.application_inspect_http
  application_inspect_imap           = each.value.application_inspect_imap
  application_inspect_login          = each.value.application_inspect_login
  application_inspect_msrpc          = each.value.application_inspect_msrpc
  application_inspect_netbios        = each.value.application_inspect_netbios
  application_inspect_pop3           = each.value.application_inspect_pop3
  application_inspect_rtsp           = each.value.application_inspect_rtsp
  application_inspect_shell          = each.value.application_inspect_shell
  application_inspect_sip            = each.value.application_inspect_sip
  application_inspect_skinny         = each.value.application_inspect_skinny
  application_inspect_smtp           = each.value.application_inspect_smtp
  application_inspect_sunrpc         = each.value.application_inspect_sunrpc
  application_inspect_tftp           = each.value.application_inspect_tftp
  audit_trail                        = each.value.audit_trail
  dns_timeout                        = each.value.dns_timeout
  icmp_idle_time                     = each.value.icmp_idle_time
  icmp_idle_time_ageout              = each.value.icmp_idle_time_ageout
  icmp_unreachable_allow             = each.value.icmp_unreachable_allow
  log_dropped_packets                = each.value.log_dropped_packets
  log_flow                           = each.value.log_flow
  max_incomplete_high                = each.value.max_incomplete_high
  max_incomplete_low                 = each.value.max_incomplete_low
  one_minute_high                    = each.value.one_minute_high
  one_minute_low                     = each.value.one_minute_low
  sessions_maximum                   = each.value.sessions_maximum
  sessions_packet                    = each.value.sessions_packet
  sessions_rate_high                 = each.value.sessions_rate_high
  sessions_rate_high_time            = each.value.sessions_rate_high_time
  sessions_rate_low                  = each.value.sessions_rate_low
  sessions_rate_low_time             = each.value.sessions_rate_low_time
  tcp_finwait_time                   = each.value.tcp_finwait_time
  tcp_finwait_time_ageout            = each.value.tcp_finwait_time_ageout
  tcp_half_close_reset_off           = each.value.tcp_half_close_reset_off
  tcp_half_open_reset_off            = each.value.tcp_half_open_reset_off
  tcp_idle_reset_off                 = each.value.tcp_idle_reset_off
  tcp_idle_time                      = each.value.tcp_idle_time
  tcp_idle_time_ageout               = each.value.tcp_idle_time_ageout
  tcp_max_incomplete_host            = each.value.tcp_max_incomplete_host
  tcp_max_incomplete_host_block_time = each.value.tcp_max_incomplete_host_block_time
  tcp_synwait_time                   = each.value.tcp_synwait_time
  tcp_synwait_time_ageout            = each.value.tcp_synwait_time_ageout
  tcp_window_scale_enforcement_loose = each.value.tcp_window_scale_enforcement_loose
  udp_half_open_idle_time            = each.value.udp_half_open_idle_time
  udp_half_open_idle_time_ageout     = each.value.udp_half_open_idle_time_ageout
  udp_idle_time                      = each.value.udp_idle_time
  udp_idle_time_ageout               = each.value.udp_idle_time_ageout
  zone_mismatch_drop                 = each.value.zone_mismatch_drop
}

##### WEB AUTHENTICATION #####
# WARNING (IBNS 2.0): configuring any web authentication parameter map,
# including the global map below, converts the device to IBNS 2.0 (new-style)
# session management. IOS-XE rewrites `authentication mac-move` as
# `access-session mac-move`, removes the `ip admission` defaults and creates
# default `service-template`s. The conversion happens over NETCONF as well as
# the CLI and cannot be reversed from the CLI; destroying these resources does
# not undo it. After the first apply, values read from the device may drift
# against `system` attributes managed in iosxe_system.tf
# (authentication_mac_move_*, access_session_mac_move_deny) and against
# `service_templates`. The module does not try to prevent this.

resource "iosxe_parameter_map_webauth_global" "parameter_map_webauth_global" {
  # Created only when at least one attribute has a non-null value. Counting
  # keys alone would let a block such as `{virtual_ip_ipv4: null}` create the
  # resource, and any write triggers the irreversible IBNS 2.0 conversion.
  for_each = {
    for device in local.devices : device.name => device
    if try(local.device_config[device.name].policy.parameter_map_webauth_global.virtual_ip_ipv4, null) != null || try(local.device_config[device.name].policy.parameter_map_webauth_global.virtual_ip_ipv6, null) != null
  }
  device = each.value.name

  virtual_ip_ipv4 = try(local.device_config[each.value.name].policy.parameter_map_webauth_global.virtual_ip_ipv4, null)
  virtual_ip_ipv6 = try(local.device_config[each.value.name].policy.parameter_map_webauth_global.virtual_ip_ipv6, null)

  # Convert to IBNS 2.0 only after iosxe_system (authentication/access-session
  # mac-move and related settings) has been applied.
  depends_on = [iosxe_system.system]
}
