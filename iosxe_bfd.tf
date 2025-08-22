locals {
  bfd_template_single_hop = flatten([
    for device in local.devices : [
      for template in try(local.device_config[device.name].bfd.single_hop_templates, []) : {
        key                                      = format("%s/%s", device.name, try(template.name, null))
        device                                   = device.name
        name                                     = try(template.name, local.defaults.iosxe.configuration.bfd.single_hop_templates.name, null)
        authentication_md5_keychain              = try(template.authentication_md5_keychain, local.defaults.iosxe.configuration.bfd.single_hop_templates.authentication_md5_keychain, null)
        authentication_meticulous_md5_keychain   = try(template.authentication_meticulous_md5_keychain, local.defaults.iosxe.configuration.bfd.single_hop_templates.authentication_meticulous_md5_keychain, null)
        authentication_meticulous_sha_1_keychain = try(template.authentication_meticulous_sha_1_keychain, local.defaults.iosxe.configuration.bfd.single_hop_templates.authentication_meticulous_sha_1_keychain, null)
        authentication_sha_1_keychain            = try(template.authentication_sha_1_keychain, local.defaults.iosxe.configuration.bfd.single_hop_templates.authentication_sha_1_keychain, null)
        interval_milliseconds_min_tx             = try(template.interval_milliseconds_min_tx, local.defaults.iosxe.configuration.bfd.single_hop_templates.interval_milliseconds_min_tx, null)
        interval_milliseconds_min_rx             = try(template.interval_milliseconds_min_rx, local.defaults.iosxe.configuration.bfd.single_hop_templates.interval_milliseconds_min_rx, null)
        interval_milliseconds_both               = try(template.interval_milliseconds_both, local.defaults.iosxe.configuration.bfd.single_hop_templates.interval_milliseconds_both, null)
        interval_milliseconds_multiplier         = try(template.interval_milliseconds_multiplier, local.defaults.iosxe.configuration.bfd.single_hop_templates.interval_milliseconds_multiplier, null)
        interval_microseconds_min_tx             = try(template.interval_microseconds_min_tx, local.defaults.iosxe.configuration.bfd.single_hop_templates.interval_microseconds_min_tx, null)
        interval_microseconds_min_rx             = try(template.interval_microseconds_min_rx, local.defaults.iosxe.configuration.bfd.single_hop_templates.interval_microseconds_min_rx, null)
        echo                                     = try(template.echo, local.defaults.iosxe.configuration.bfd.single_hop_templates.echo, null)
        dampening_half_time                      = try(template.dampening_half_time, local.defaults.iosxe.configuration.bfd.single_hop_templates.dampening_half_time, null)
        dampening_unsuppress_time                = try(template.dampening_unsuppress_time, local.defaults.iosxe.configuration.bfd.single_hop_templates.dampening_unsuppress_time, null)
        dampening_suppress_time                  = try(template.dampening_suppress_time, local.defaults.iosxe.configuration.bfd.single_hop_templates.dampening_suppress_time, null)
        dampening_max_suppressing_time           = try(template.dampening_max_suppressing_time, local.defaults.iosxe.configuration.bfd.single_hop_templates.dampening_max_suppressing_time, null)
      }
    ]
  ])
}

resource "iosxe_bfd_template_single_hop" "bfd_template_single_hop" {
  for_each = { for e in local.bfd_template_single_hop : e.key => e }
  device   = each.value.device

  name                                     = each.value.name
  authentication_md5_keychain              = each.value.authentication_md5_keychain
  authentication_meticulous_md5_keychain   = each.value.authentication_meticulous_md5_keychain
  authentication_meticulous_sha_1_keychain = each.value.authentication_meticulous_sha_1_keychain
  authentication_sha_1_keychain            = each.value.authentication_sha_1_keychain
  interval_milliseconds_min_tx             = each.value.interval_milliseconds_min_tx
  interval_milliseconds_min_rx             = each.value.interval_milliseconds_min_rx
  interval_milliseconds_both               = each.value.interval_milliseconds_both
  interval_milliseconds_multiplier         = each.value.interval_milliseconds_multiplier
  interval_microseconds_min_tx             = each.value.interval_microseconds_min_tx
  interval_microseconds_min_rx             = each.value.interval_microseconds_min_rx
  echo                                     = each.value.echo
  dampening_half_time                      = each.value.dampening_half_time
  dampening_unsuppress_time                = each.value.dampening_unsuppress_time
  dampening_suppress_time                  = each.value.dampening_suppress_time
  dampening_max_suppressing_time           = each.value.dampening_max_suppressing_time
}

locals {
  bfd_template_multi_hop = flatten([
    for device in local.devices : [
      for template in try(local.device_config[device.name].bfd.multi_hop_templates, []) : {
        key                                     = format("%s/%s", device.name, try(template.name, null))
        device                                  = device.name
        name                                    = try(template.name, local.defaults.iosxe.configuration.bfd.multi_hop_templates.name, null)
        authentication_md5_keychain             = try(template.authentication_md5_keychain, local.defaults.iosxe.configuration.bfd.multi_hop_templates.authentication_md5_keychain, null)
        authentication_meticulous_md5_keychain  = try(template.authentication_meticulous_md5_keychain, local.defaults.iosxe.configuration.bfd.multi_hop_templates.authentication_meticulous_md5_keychain, null)
        authentication_meticulous_sha_1keychain = try(template.authentication_meticulous_sha_1keychain, local.defaults.iosxe.configuration.bfd.multi_hop_templates.authentication_meticulous_sha_1keychain, null)
        authentication_sha_1_keychain           = try(template.authentication_sha_1_keychain, local.defaults.iosxe.configuration.bfd.multi_hop_templates.authentication_sha_1_keychain, null)
        interval_milliseconds_both              = try(template.interval_milliseconds_both, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_milliseconds_both, null)
        interval_milliseconds_min_tx            = try(template.interval_milliseconds_min_tx, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_milliseconds_min_tx, null)
        interval_milliseconds_min_rx            = try(template.interval_milliseconds_min_rx, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_milliseconds_min_rx, null)
        interval_milliseconds_multiplier        = try(template.interval_milliseconds_multiplier, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_milliseconds_multiplier, null)
        interval_microseconds_both              = try(template.interval_microseconds_both, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_microseconds_both, null)
        interval_microseconds_min_tx            = try(template.interval_microseconds_min_tx, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_microseconds_min_tx, null)
        interval_microseconds_min_rx            = try(template.interval_microseconds_min_rx, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_microseconds_min_rx, null)
        interval_microseconds_multiplier        = try(template.interval_microseconds_multiplier, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_microseconds_multiplier, null)
        interval_microseconds                   = try(template.interval_microseconds, local.defaults.iosxe.configuration.bfd.multi_hop_templates.interval_microseconds, null)
        echo                                    = try(template.echo, local.defaults.iosxe.configuration.bfd.multi_hop_templates.echo, null)
        dampening_half_time                     = try(template.dampening_half_time, local.defaults.iosxe.configuration.bfd.multi_hop_templates.dampening_half_time, null)
        dampening_unsuppress_time               = try(template.dampening_unsuppress_time, local.defaults.iosxe.configuration.bfd.multi_hop_templates.dampening_unsuppress_time, null)
        dampening_suppress_time                 = try(template.dampening_suppress_time, local.defaults.iosxe.configuration.bfd.multi_hop_templates.dampening_suppress_time, null)
        dampening_max_suppressing_time          = try(template.dampening_max_suppressing_time, local.defaults.iosxe.configuration.bfd.multi_hop_templates.dampening_max_suppressing_time, null)
        dampening_threshold                     = try(template.dampening_threshold, local.defaults.iosxe.configuration.bfd.multi_hop_templates.dampening_threshold, null)
        dampening_down_monitoring               = try(template.dampening_down_monitoring, local.defaults.iosxe.configuration.bfd.multi_hop_templates.dampening_down_monitoring, null)
      }
    ]
  ])
}

resource "iosxe_bfd_template_multi_hop" "bfd_template_multi_hop" {
  for_each = { for e in local.bfd_template_multi_hop : e.key => e }
  device   = each.value.device

  name                                    = each.value.name
  authentication_md5_keychain             = each.value.authentication_md5_keychain
  authentication_meticulous_md5_keychain  = each.value.authentication_meticulous_md5_keychain
  authentication_meticulous_sha_1keychain = each.value.authentication_meticulous_sha_1keychain
  authentication_sha_1_keychain           = each.value.authentication_sha_1_keychain
  interval_milliseconds_both              = each.value.interval_milliseconds_both
  interval_milliseconds_min_tx            = each.value.interval_milliseconds_min_tx
  interval_milliseconds_min_rx            = each.value.interval_milliseconds_min_rx
  interval_milliseconds_multiplier        = each.value.interval_milliseconds_multiplier
  interval_microseconds_both              = each.value.interval_microseconds_both
  interval_microseconds_min_tx            = each.value.interval_microseconds_min_tx
  interval_microseconds_min_rx            = each.value.interval_microseconds_min_rx
  interval_microseconds_multiplier        = each.value.interval_microseconds_multiplier
  interval_microseconds                   = each.value.interval_microseconds
  echo                                    = each.value.echo
  dampening_half_time                     = each.value.dampening_half_time
  dampening_unsuppress_time               = each.value.dampening_unsuppress_time
  dampening_suppress_time                 = each.value.dampening_suppress_time
  dampening_max_suppressing_time          = each.value.dampening_max_suppressing_time
  dampening_threshold                     = each.value.dampening_threshold
  dampening_down_monitoring               = each.value.dampening_down_monitoring
}

resource "iosxe_bfd" "bfd" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].bfd, null) != null }
  device   = each.value.name

  ipv4_both_vrfs = try(length(local.device_config[each.value.name].bfd.ipv4_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv4_maps : {
    dst_vrf       = try(e.destination_vrf, local.defaults.iosxe.configuration.bfd.ipv4_maps.destination_vrf, null)
    dest_ip       = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.destination_prefix, null)
    src_vrf       = try(e.source_vrf, local.defaults.iosxe.configuration.bfd.ipv4_maps.source_vrf, null)
    src_ip        = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.source_prefix, null)
    template_name = e.template
  } if try(e.source_vrf, null) != null && try(e.destination_vrf, null) != null]

  ipv4_without_vrfs = try(length(local.device_config[each.value.name].bfd.ipv4_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv4_maps : {
    dest_ip       = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.destination_prefix, null)
    src_ip        = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.source_prefix, null)
    template_name = e.template
  } if try(e.source_vrf, null) == null && try(e.destination_vrf, null) == null]

  ipv4_with_src_vrfs = try(length(local.device_config[each.value.name].bfd.ipv4_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv4_maps : {
    dest_ip       = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.destination_prefix, null)
    src_vrf       = try(e.source_vrf, local.defaults.iosxe.configuration.bfd.ipv4_maps.source_vrf, null)
    src_ip        = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.source_prefix, null)
    template_name = e.template
  } if try(e.source_vrf, null) != null && try(e.destination_vrf, null) == null]

  ipv4_with_dst_vrfs = try(length(local.device_config[each.value.name].bfd.ipv4_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv4_maps : {
    dst_vrf       = try(e.destination_vrf, local.defaults.iosxe.configuration.bfd.ipv4_maps.destination_vrf, null)
    dest_ip       = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.destination_prefix, null)
    src_ip        = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv4_maps.source_prefix, null)
    template_name = e.template
  } if try(e.destination_vrf, null) != null && try(e.source_vrf, null) == null]

  ipv6_with_both_vrfs = try(length(local.device_config[each.value.name].bfd.ipv6_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv6_maps : {
    dst_vrf       = try(e.destination_vrf, local.defaults.iosxe.configuration.bfd.ipv6_maps.destination_vrf, null)
    dest_ipv6     = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.destination_prefix, null)
    src_vrf       = try(e.source_vrf, local.defaults.iosxe.configuration.bfd.ipv6_maps.source_vrf, null)
    src_ipv6      = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.source_prefix, null)
    template_name = e.template
  } if try(e.source_vrf, null) != null && try(e.destination_vrf, null) != null]

  ipv6_without_vrfs = try(length(local.device_config[each.value.name].bfd.ipv6_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv6_maps : {
    dest_ipv6     = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.destination_prefix, null)
    src_ipv6      = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.source_prefix, null)
    template_name = e.template
  } if try(e.source_vrf, null) == null && try(e.destination_vrf, null) == null]

  ipv6_with_src_vrfs = try(length(local.device_config[each.value.name].bfd.ipv6_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv6_maps : {
    dest_ipv6     = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.destination_prefix, null)
    src_vrf       = try(e.source_vrf, local.defaults.iosxe.configuration.bfd.ipv6_maps.source_vrf, null)
    src_ipv6      = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.source_prefix, null)
    template_name = e.template
  } if try(e.source_vrf, null) != null && try(e.destination_vrf, null) == null]

  ipv6_with_dst_vrfs = try(length(local.device_config[each.value.name].bfd.ipv6_maps) == 0, true) ? null : [for e in local.device_config[each.value.name].bfd.ipv6_maps : {
    dst_vrf       = try(e.destination_vrf, local.defaults.iosxe.configuration.bfd.ipv6_maps.destination_vrf, null)
    dest_ipv6     = try(e.destination_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.destination_prefix, null)
    src_ipv6      = try(e.source_prefix, local.defaults.iosxe.configuration.bfd.ipv6_maps.source_prefix, null)
    template_name = e.template
  } if try(e.destination_vrf, null) != null && try(e.source_vrf, null) == null]

  slow_timers = try(local.device_config[each.value.name].bfd.slow_timers, local.defaults.iosxe.configuration.bfd.slow_timers, null)

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_bfd_template_single_hop.bfd_template_single_hop,
    iosxe_bfd_template_multi_hop.bfd_template_multi_hop
  ]
}
