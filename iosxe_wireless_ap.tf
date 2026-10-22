locals {
  wireless_ap_join_profile_syslog_levels = {
    emergencies   = "syslog-level-emergency"
    alerts        = "syslog-level-alert"
    critical      = "syslog-level-critical"
    errors        = "syslog-level-errors"
    warnings      = "syslog-level-warning"
    notifications = "syslog-level-notification"
    informational = "syslog-level-information"
    debugging     = "syslog-level-debug"
  }
  wireless_ap_join_profile_password_types = {
    "0" = "clear"
    "8" = "aes"
  }

  wireless_ap_join_profiles = flatten([
    for device in local.devices : [
      for prof in try(local.device_config[device.name].wireless.ap_join_profiles, []) : {
        key         = format("%s/%s", device.name, prof.name)
        device      = device.name
        name        = prof.name
        description = try(prof.description, null)

        capwap_window_size = try(prof.capwap_window_size, null)
        country            = try(lower(prof.country), null)
        ssh                = try(prof.ssh, null)

        mgmtuser_username      = try(prof.mgmtuser_username, null)
        mgmtuser_password      = try(prof.mgmtuser_password, null)
        mgmtuser_password_type = try(local.wireless_ap_join_profile_password_types[tostring(prof.mgmtuser_password_type)], null)
        mgmtuser_secret        = try(prof.mgmtuser_secret, null)
        mgmtuser_secret_type   = try(local.wireless_ap_join_profile_password_types[tostring(prof.mgmtuser_secret_type)], null)

        ntp_ip            = try(prof.ntp_ip, null)
        syslog_host       = try(prof.syslog_host, null)
        syslog_facility   = try("facility-${prof.syslog_facility}", null)
        syslog_level      = try(local.wireless_ap_join_profile_syslog_levels[prof.syslog_level], null)
        apphost           = try(prof.apphost, null)
        association_limit = try(prof.association_limit, null)
        awips             = try(prof.awips, null)
        awips_forensic    = try(prof.awips_forensic, null)

        capwap_retransmit_count              = try(prof.capwap_retransmit_count, null)
        capwap_retransmit_interval           = try(prof.capwap_retransmit_interval, null)
        capwap_timers_discovery_timeout      = try(prof.capwap_timers_discovery_timeout, null)
        capwap_timers_fast_heartbeat_timeout = try(prof.capwap_timers_fast_heartbeat_timeout, null)
        capwap_timers_heartbeat_timeout      = try(prof.capwap_timers_heartbeat_timeout, null)
        capwap_timers_primed_join_timeout    = try(prof.capwap_timers_primed_join_timeout, null)
        capwap_fallback                      = try(prof.capwap_fallback, null)

        # N+1 attributes
        capwap_timers_primary_discovery_timeout = try(prof.capwap_timers_primary_discovery_timeout, null)
        capwap_backup_primary_name              = try(prof.capwap_backup_primary_name, null)
        capwap_backup_primary_ip                = try(prof.capwap_backup_primary_ip, null)
        capwap_backup_secondary_name            = try(prof.capwap_backup_secondary_name, null)
        capwap_backup_secondary_ip              = try(prof.capwap_backup_secondary_ip, null)

        # Explicit-set rule: list present -> set both booleans, absent -> null
        capwap_discovery_private = try(contains(prof.capwap_discovery, "private"), null)
        capwap_discovery_public  = try(contains(prof.capwap_discovery, "public"), null)

        cdp                 = try(prof.cdp, null)
        dot1x_eap_type      = try("dot1x-${prof.dot1x_eap_type}", null)
        dot1x_username      = try(prof.dot1x_username, null)
        dot1x_password      = try(prof.dot1x_password, null)
        dot1x_password_type = try(local.wireless_ap_join_profile_password_types[tostring(prof.dot1x_password_type)], null)
        hyperlocation       = try(prof.hyperlocation, null)
        ip_dhcp_fallback    = try(prof.ip_dhcp_fallback, null)
        lag                 = try(prof.lag, null)
        led                 = try(prof.led, null)
        mesh_profile        = try(prof.mesh_profile, null)

        rogue_detection_enable             = try(prof.rogue_detection_enable, null)
        rogue_detection_min_rssi           = try(prof.rogue_detection_min_rssi, null)
        rogue_detection_min_transient_time = try(prof.rogue_detection_min_transient_time, null)
        rogue_detection_report_interval    = try(prof.rogue_detection_report_interval, null)

        statistics_ap_system_monitoring_enable                = try(prof.statistics_ap_system_monitoring_enable, null)
        statistics_ap_system_monitoring_alarm_enable          = try(prof.statistics_ap_system_monitoring_alarm_enable, null)
        statistics_ap_system_monitoring_alarm_hold_time       = try(prof.statistics_ap_system_monitoring_alarm_hold_time, null)
        statistics_ap_system_monitoring_alarm_retransmit_time = try(prof.statistics_ap_system_monitoring_alarm_retransmit_time, null)
        statistics_ap_system_monitoring_cpu_threshold         = try(prof.statistics_ap_system_monitoring_cpu_threshold, null)
        statistics_ap_system_monitoring_mem_threshold         = try(prof.statistics_ap_system_monitoring_mem_threshold, null)
        statistics_ap_system_monitoring_sampling_interval     = try(prof.statistics_ap_system_monitoring_sampling_interval, null)
        statistics_ap_system_monitoring_stats_interval        = try(prof.statistics_ap_system_monitoring_stats_interval, null)
        statistics_traffic_distribution                       = try(prof.statistics_traffic_distribution, null)
        statistics_traffic_distribution_interval              = try(prof.statistics_traffic_distribution_interval, null)
        statistics_ap_radio_monitoring_enable                 = try(prof.statistics_ap_radio_monitoring_enable, null)
        statistics_ap_radio_monitoring_sampling_interval      = try(prof.statistics_ap_radio_monitoring_sampling_interval, null)
        stats_timer                                           = try(prof.stats_timer, null)

        tcp_adjust_mss_enable = try(prof.tcp_adjust_mss_enable, null)
        tcp_adjust_mss_size   = try(prof.tcp_adjust_mss_size, null)
        ble_scan              = try(prof.ble_scan, null)
      }
    ]
  ])
}

resource "iosxe_wireless_ap_join_profile" "wireless_ap_join_profile" {
  for_each = { for e in local.wireless_ap_join_profiles : e.key => e }

  device                                                = each.value.device
  name                                                  = each.value.name
  description                                           = each.value.description
  capwap_window_size                                    = each.value.capwap_window_size
  country                                               = each.value.country
  ssh                                                   = each.value.ssh
  mgmtuser_username                                     = each.value.mgmtuser_username
  mgmtuser_password                                     = each.value.mgmtuser_password
  mgmtuser_password_type                                = each.value.mgmtuser_password_type
  mgmtuser_secret                                       = each.value.mgmtuser_secret
  mgmtuser_secret_type                                  = each.value.mgmtuser_secret_type
  ntp_ip                                                = each.value.ntp_ip
  syslog_host                                           = each.value.syslog_host
  syslog_facility                                       = each.value.syslog_facility
  syslog_level                                          = each.value.syslog_level
  apphost                                               = each.value.apphost
  association_limit                                     = each.value.association_limit
  awips                                                 = each.value.awips
  awips_forensic                                        = each.value.awips_forensic
  capwap_retransmit_count                               = each.value.capwap_retransmit_count
  capwap_retransmit_interval                            = each.value.capwap_retransmit_interval
  capwap_timers_discovery_timeout                       = each.value.capwap_timers_discovery_timeout
  capwap_timers_fast_heartbeat_timeout                  = each.value.capwap_timers_fast_heartbeat_timeout
  capwap_timers_heartbeat_timeout                       = each.value.capwap_timers_heartbeat_timeout
  capwap_timers_primary_discovery_timeout               = each.value.capwap_timers_primary_discovery_timeout
  capwap_timers_primed_join_timeout                     = each.value.capwap_timers_primed_join_timeout
  capwap_backup_primary_name                            = each.value.capwap_backup_primary_name
  capwap_backup_primary_ip                              = each.value.capwap_backup_primary_ip
  capwap_backup_secondary_name                          = each.value.capwap_backup_secondary_name
  capwap_backup_secondary_ip                            = each.value.capwap_backup_secondary_ip
  capwap_fallback                                       = each.value.capwap_fallback
  capwap_discovery_private                              = each.value.capwap_discovery_private
  capwap_discovery_public                               = each.value.capwap_discovery_public
  cdp                                                   = each.value.cdp
  dot1x_eap_type                                        = each.value.dot1x_eap_type
  dot1x_username                                        = each.value.dot1x_username
  dot1x_password                                        = each.value.dot1x_password
  dot1x_password_type                                   = each.value.dot1x_password_type
  hyperlocation                                         = each.value.hyperlocation
  ip_dhcp_fallback                                      = each.value.ip_dhcp_fallback
  lag                                                   = each.value.lag
  led                                                   = each.value.led
  mesh_profile                                          = each.value.mesh_profile
  rogue_detection_enable                                = each.value.rogue_detection_enable
  rogue_detection_min_rssi                              = each.value.rogue_detection_min_rssi
  rogue_detection_min_transient_time                    = each.value.rogue_detection_min_transient_time
  rogue_detection_report_interval                       = each.value.rogue_detection_report_interval
  statistics_ap_system_monitoring_enable                = each.value.statistics_ap_system_monitoring_enable
  statistics_ap_system_monitoring_alarm_enable          = each.value.statistics_ap_system_monitoring_alarm_enable
  statistics_ap_system_monitoring_alarm_hold_time       = each.value.statistics_ap_system_monitoring_alarm_hold_time
  statistics_ap_system_monitoring_alarm_retransmit_time = each.value.statistics_ap_system_monitoring_alarm_retransmit_time
  statistics_ap_system_monitoring_cpu_threshold         = each.value.statistics_ap_system_monitoring_cpu_threshold
  statistics_ap_system_monitoring_mem_threshold         = each.value.statistics_ap_system_monitoring_mem_threshold
  statistics_ap_system_monitoring_sampling_interval     = each.value.statistics_ap_system_monitoring_sampling_interval
  statistics_ap_system_monitoring_stats_interval        = each.value.statistics_ap_system_monitoring_stats_interval
  statistics_traffic_distribution                       = each.value.statistics_traffic_distribution
  statistics_traffic_distribution_interval              = each.value.statistics_traffic_distribution_interval
  statistics_ap_radio_monitoring_enable                 = each.value.statistics_ap_radio_monitoring_enable
  statistics_ap_radio_monitoring_sampling_interval      = each.value.statistics_ap_radio_monitoring_sampling_interval
  stats_timer                                           = each.value.stats_timer
  tcp_adjust_mss_enable                                 = each.value.tcp_adjust_mss_enable
  tcp_adjust_mss_size                                   = each.value.tcp_adjust_mss_size
  ble_scan                                              = each.value.ble_scan
}

locals {
  wireless_site_tags = flatten([
    for device in local.devices : [
      for tag in try(local.device_config[device.name].wireless.site_tags, []) : {
        key             = format("%s/%s", device.name, tag.name)
        device          = device.name
        site_tag_name   = tag.name
        description     = try(tag.description, null)
        ap_join_profile = try(tag.ap_join_profile, null)
        local_site      = try(tag.local_site, null)
        flex_profile    = try(tag.flex_profile, null)
      }
    ]
  ])
}

resource "iosxe_wireless_site_tag" "wireless_site_tag" {
  for_each = { for e in local.wireless_site_tags : e.key => e }

  device          = each.value.device
  site_tag_name   = each.value.site_tag_name
  description     = each.value.description
  ap_join_profile = each.value.ap_join_profile
  local_site      = each.value.local_site
  flex_profile    = each.value.flex_profile

  depends_on = [iosxe_wireless_ap_join_profile.wireless_ap_join_profile]
}

locals {
  # CLI tag source token -> YANG enum. Only priorities 2 and 3 are configurable on the device.
  wireless_tag_source_map = {
    filter = "tag-source-filter"
    ap     = "tag-source-ap-pnp"
  }

  # The device does not return a tag that is explicitly set to its built-in default name, so a
  # default name is sent as null (the device default applies) to avoid a perpetual diff.
  wireless_default_tags = {
    policy = "default-policy-tag"
    site   = "default-site-tag"
    rf     = "default-rf-tag"
  }

  # Static AP tags use the bulk iosxe_wireless_ap_tags resource: one NETCONF read and one write per
  # device, however many APs there are, instead of one resource per AP. The items map is keyed by
  # the MAC in YANG form (lowercase, colon separated), normalized from the CLI dotted, colon or
  # hyphen form. Only the MACs in the data model are managed; entries configured outside IOS-XE as
  # Code are left untouched.
  wireless_ap_tags = {
    for device in local.devices : device.name => {
      for t in try(local.device_config[device.name].wireless.ap_tags, []) :
      join(":", regexall("[0-9a-f]{2}", lower(replace(t.mac, "/[^0-9A-Fa-f]/", "")))) => {
        policy_tag = try(t.policy_tag, local.wireless_default_tags.policy) == local.wireless_default_tags.policy ? null : t.policy_tag
        site_tag   = try(t.site_tag, local.wireless_default_tags.site) == local.wireless_default_tags.site ? null : t.site_tag
        rf_tag     = try(t.rf_tag, local.wireless_default_tags.rf) == local.wireless_default_tags.rf ? null : t.rf_tag
      }
    } if length(try(local.device_config[device.name].wireless.ap_tags, [])) > 0
  }

  wireless_ap_filters = flatten([
    for device in local.devices : [
      for f in try(local.device_config[device.name].wireless.ap_filters, []) : {
        key           = format("%s/%s", device.name, f.name)
        device        = device.name
        name          = f.name
        ap_name_regex = try(f.ap_name_regex, null)
        tag_policy    = try(f.tag_policy, null)
        tag_site      = try(f.tag_site, null)
        tag_rf        = try(f.tag_rf, null)
      }
    ]
  ])

  # Each filter's priority is moved into the device-wide AP filter priority table.
  wireless_ap_filter_priorities = {
    for device in local.devices : device.name => [
      for f in try(local.device_config[device.name].wireless.ap_filters, []) : {
        priority    = f.priority
        filter_name = f.name
      } if try(f.priority, null) != null
    ] if length([for f in try(local.device_config[device.name].wireless.ap_filters, []) : f if try(f.priority, null) != null]) > 0
  }

  wireless_tag_source_priorities = {
    for device in local.devices : device.name => [
      for p in try(local.device_config[device.name].wireless.tag_source_priorities, []) : {
        priority = p.priority
        source   = local.wireless_tag_source_map[p.source]
      }
    ] if length(try(local.device_config[device.name].wireless.tag_source_priorities, [])) > 0
  }
}

resource "iosxe_wireless_ap_tags" "wireless_ap_tags" {
  for_each = local.wireless_ap_tags

  device = each.key
  items  = each.value

  depends_on = [iosxe_wireless_site_tag.wireless_site_tag]
}

resource "iosxe_wireless_ap_filter" "wireless_ap_filter" {
  for_each = { for e in local.wireless_ap_filters : e.key => e }

  device        = each.value.device
  name          = each.value.name
  ap_name_regex = each.value.ap_name_regex
  tag_policy    = each.value.tag_policy
  tag_site      = each.value.tag_site
  tag_rf        = each.value.tag_rf
  filter_type   = "ap-filter-type-tag" # only tag filters are modeled

  depends_on = [iosxe_wireless_site_tag.wireless_site_tag]
}

# Created after and destroyed before the filters: the device rejects a priority that references a
# filter without a regular expression, and the deletion of a filter that a priority references.
resource "iosxe_wireless_ap_filter_priority" "wireless_ap_filter_priority" {
  for_each = local.wireless_ap_filter_priorities

  device     = each.key
  priorities = each.value

  depends_on = [iosxe_wireless_ap_filter.wireless_ap_filter]
}

# Destroying this resource restores the factory order (2 = filter, 3 = ap); the fixed priorities
# 0 (static), 1 (location) and 4 (default) are never touched.
resource "iosxe_wireless_ap_tag_source_priority" "wireless_ap_tag_source_priority" {
  for_each = local.wireless_tag_source_priorities

  device     = each.key
  priorities = each.value
}
