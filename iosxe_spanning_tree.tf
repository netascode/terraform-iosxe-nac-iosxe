resource "iosxe_spanning_tree" "spanning_tree" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].spanning_tree, local.defaults.iosxe.configuration.spanning_tree, null) != null }
  device   = each.value.name

  mode                       = try(local.device_config[each.value.name].spanning_tree.mode, local.defaults.iosxe.configuration.spanning_tree.mode, null)
  loopguard_default          = try(local.device_config[each.value.name].spanning_tree.loopguard_default, local.defaults.iosxe.configuration.spanning_tree.loopguard_default, null)
  portfast_default           = try(local.device_config[each.value.name].spanning_tree.portfast_default, local.defaults.iosxe.configuration.spanning_tree.portfast_default, null)
  portfast_bpduguard_default = try(local.device_config[each.value.name].spanning_tree.portfast_bpduguard_default, local.defaults.iosxe.configuration.spanning_tree.portfast_bpduguard_default, null)
  extend_system_id           = try(local.device_config[each.value.name].spanning_tree.extend_system_id, local.defaults.iosxe.configuration.spanning_tree.extend_system_id, null)

  mst_instances = [for e in try(local.device_config[each.value.name].spanning_tree.mst_instances, []) : {
    id       = try(e.id, local.defaults.iosxe.configuration.spanning_tree.mst_instances.id, null)
    vlan_ids = try(e.vlan_ids, local.defaults.iosxe.configuration.spanning_tree.mst_instances.vlan_ids, null)
  }]
}