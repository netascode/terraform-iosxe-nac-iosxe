resource "iosxe_spanning_tree" "spanning_tree" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].spanning_tree, null) != null }
  device   = each.value.name

  mode                       = try(local.device_config[each.value.name].spanning_tree.mode, null)
  logging                    = try(local.device_config[each.value.name].spanning_tree.logging, null)
  loopguard_default          = try(local.device_config[each.value.name].spanning_tree.loopguard_default, null)
  portfast_default           = try(local.device_config[each.value.name].spanning_tree.portfast_default, null)
  portfast_bpduguard_default = try(local.device_config[each.value.name].spanning_tree.portfast_bpduguard_default, null)
  extend_system_id           = try(local.device_config[each.value.name].spanning_tree.extend_system_id, null)

  mst_instances = try(length(local.device_config[each.value.name].spanning_tree.mst_instances) == 0, true) ? null : [for e in local.device_config[each.value.name].spanning_tree.mst_instances : {
    id = try(e.id, null)
    vlan_ids = try(
      provider::utils::normalize_vlans(
        try(e.vlans, null),
        "list"
      ),
      concat(range(1, 1025), range(1025, 2049), range(2049, 3073), range(3073, 4094))
    )
  }]

  vlans = try(length(local.device_config[each.value.name].spanning_tree.vlans) == 0, true) ? null : flatten([
    for v in try(local.device_config[each.value.name].spanning_tree.vlans, []) : [
      for id in(
        try(v.vlans, null) != null
        ? provider::utils::normalize_vlans(v.vlans, "list")
        : [try(v.id, null)]
        ) : {
        id       = tostring(id)
        priority = try(v.priority, null)
      }
    ]
  ])

  disabled_vlans = try(local.device_config[each.value.name].spanning_tree.disabled.vlans, null) == null ? null : [
    for id in provider::utils::normalize_vlans(
      try(local.device_config[each.value.name].spanning_tree.disabled.vlans, null),
      "list"
      ) : {
      id = tostring(id)
    }
  ]
}
