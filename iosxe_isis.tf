locals {
  isis_processes = flatten([
    for device in local.devices : [
      for process in try(local.device_config[device.name].routing.isis_processes, []) : {
        key                       = format("%s/%s", device.name, process.area_tag)
        device                    = device.name
        area_tag                  = try(process.area_tag, null)
        nets                      = try(process.nets, null)
        metric_style_wide         = try(process.metric_style_wide, local.defaults.iosxe.configuration.routing.isis_processes.metric_style_wide, null)
        metric_style_narrow       = try(process.metric_style_narrow, local.defaults.iosxe.configuration.routing.isis_processes.metric_style_narrow, null)
        metric_style_transition   = try(process.metric_style_transition, local.defaults.iosxe.configuration.routing.isis_processes.metric_style_transition, null)
        log_adjacency_changes     = try(process.log_adjacency_changes, local.defaults.iosxe.configuration.routing.isis_processes.log_adjacency_changes, null)
        log_adjacency_changes_all = try(process.log_adjacency_changes_all, local.defaults.iosxe.configuration.routing.isis_processes.log_adjacency_changes_all, null)
      }
    ]
  ])
}

resource "iosxe_isis" "isis" {
  for_each = { for e in local.isis_processes : e.key => e }
  device   = each.value.device

  area_tag = each.value.area_tag
  nets = try(length(each.value.nets) == 0, true) ? null : [for net in each.value.nets : {
    tag = try(net.tag, null)
  }]
  metric_style_wide         = each.value.metric_style_wide
  metric_style_narrow       = each.value.metric_style_narrow
  metric_style_transition   = each.value.metric_style_transition
  log_adjacency_changes     = each.value.log_adjacency_changes
  log_adjacency_changes_all = each.value.log_adjacency_changes_all
}

