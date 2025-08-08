resource "iosxe_evpn" "evpn" {
  for_each                  = { for device in local.devices : device.name => device if try(local.device_config[device.name].evpn, null) != null || try(local.defaults.iosxe.configuration.evpn, null) != null }
  device                    = each.value.name
  replication_type_ingress  = try(contains(local.device_config[each.value.name].evpn.replication_type, "ingress"), contains(local.defaults.iosxe.configuration.evpn.replication_type, "ingress"), null)
  replication_type_static   = try(contains(local.device_config[each.value.name].evpn.replication_type, "static"), contains(local.defaults.iosxe.configuration.evpn.replication_type, "static"), null)
  replication_type_p2mp     = try(contains(local.device_config[each.value.name].evpn.replication_type, "p2mp"), contains(local.defaults.iosxe.configuration.evpn.replication_type, "p2mp"), null)
  replication_type_mp2mp    = try(contains(local.device_config[each.value.name].evpn.replication_type, "mp2mp"), contains(local.defaults.iosxe.configuration.evpn.replication_type, "mp2mp"), null)
  mac_duplication_limit     = try(local.device_config[each.value.name].evpn.mac_duplication_limit, local.defaults.iosxe.configuration.evpn.mac_duplication_limit, null)
  mac_duplication_time      = try(local.device_config[each.value.name].evpn.mac_duplication_time, local.defaults.iosxe.configuration.evpn.mac_duplication_time, null)
  ip_duplication_limit      = try(local.device_config[each.value.name].evpn.ip_duplication_limit, local.defaults.iosxe.configuration.evpn.ip_duplication_limit, null)
  ip_duplication_time       = try(local.device_config[each.value.name].evpn.ip_duplication_time, local.defaults.iosxe.configuration.evpn.ip_duplication_time, null)
  router_id_loopback        = try(local.device_config[each.value.name].evpn.router_id_loopback, local.defaults.iosxe.configuration.evpn.router_id_loopback, null)
  default_gateway_advertise = try(local.device_config[each.value.name].evpn.default_gateway_advertise, local.defaults.iosxe.configuration.evpn.default_gateway_advertise, null)
  logging_peer_state        = try(local.device_config[each.value.name].evpn.logging_peer_state, local.defaults.iosxe.configuration.evpn.logging_peer_state, null)
  route_target_auto_vni     = try(local.device_config[each.value.name].evpn.route_target_auto_vni, local.defaults.iosxe.configuration.evpn.route_target_auto_vni, null)
}


locals {
  evpn_instances = flatten([
    for device in local.devices : [
      for instance in try(local.device_config[device.name].evpn.instances, []) : {
        key    = format("%s/%s", device.name, instance.number)
        device = device.name

        evpn_instance_num                    = try(instance.number, local.defaults.iosxe.configuration.evpn.instances.number, null)
        vlan_based_replication_type_ingress  = try(contains(instance.vlan_based.replication_type, "ingress"), contains(local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type, "ingress"), null)
        vlan_based_replication_type_static   = try(contains(instance.vlan_based.replication_type, "static"), contains(local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type, "static"), null)
        vlan_based_replication_type_p2mp     = try(contains(instance.vlan_based.replication_type, "p2mp"), contains(local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type, "p2mp"), null)
        vlan_based_replication_type_mp2mp    = try(contains(instance.vlan_based.replication_type, "mp2mp"), contains(local.defaults.iosxe.configuration.evpn.instances.vlan_based.replication_type, "mp2mp"), null)
        vlan_based_encapsulation             = try(instance.vlan_based.encapsulation, local.defaults.iosxe.configuration.evpn.instances.vlan_based.encapsulation, null)
        vlan_based_auto_route_target         = try(instance.vlan_based.auto_route_target, local.defaults.iosxe.configuration.evpn.instances.vlan_based.auto_route_target, null)
        vlan_based_rd                        = try(instance.vlan_based.rd, local.defaults.iosxe.configuration.evpn.instances.vlan_based.rd, null)
        vlan_based_ip_local_learning_disable = try(instance.vlan_based.ip_local_learning_disable, local.defaults.iosxe.configuration.evpn.instances.vlan_based.ip_local_learning_disable, null)
        vlan_based_ip_local_learning_enable  = try(instance.vlan_based.ip_local_learning_enable, local.defaults.iosxe.configuration.evpn.instances.vlan_based.ip_local_learning_enable, null)
        vlan_based_default_gateway_advertise = try(instance.vlan_based.default_gateway_advertise == true ? "enable" : "disable", local.defaults.iosxe.configuration.evpn.instances.vlan_based.default_gateway_advertise == true ? "enable" : "disable", null)
        vlan_based_re_originate_route_type5  = try(instance.vlan_based.re_originate_route_type5, local.defaults.iosxe.configuration.evpn.instances.vlan_based.re_originate_route_type5, null)
        vlan_based_route_target_imports = [for rt in try(instance.vlan_based.route_target_imports, []) : {
          route_target = try(rt, local.defaults.iosxe.configuration.evpn.instances.vlan_based.route_target_imports, null)
        }]
        vlan_based_route_target_exports = [for rt in try(instance.vlan_based.route_target_exports, []) : {
          route_target = try(rt, local.defaults.iosxe.configuration.evpn.instances.vlan_based.route_target_exports, null)
        }]
    }]
  ])
}

resource "iosxe_evpn_instance" "evpn_instance" {
  for_each = { for e in local.evpn_instances : e.key => e }
  device   = each.value.device

  evpn_instance_num                    = each.value.evpn_instance_num
  vlan_based_replication_type_ingress  = each.value.vlan_based_replication_type_ingress
  vlan_based_replication_type_static   = each.value.vlan_based_replication_type_static
  vlan_based_replication_type_p2mp     = each.value.vlan_based_replication_type_p2mp
  vlan_based_replication_type_mp2mp    = each.value.vlan_based_replication_type_mp2mp
  vlan_based_encapsulation             = each.value.vlan_based_encapsulation
  vlan_based_auto_route_target         = each.value.vlan_based_auto_route_target
  vlan_based_rd                        = each.value.vlan_based_rd
  vlan_based_ip_local_learning_disable = each.value.vlan_based_ip_local_learning_disable
  vlan_based_ip_local_learning_enable  = each.value.vlan_based_ip_local_learning_enable
  vlan_based_default_gateway_advertise = each.value.vlan_based_default_gateway_advertise
  vlan_based_re_originate_route_type5  = each.value.vlan_based_re_originate_route_type5
  vlan_based_route_target_imports      = each.value.vlan_based_route_target_imports
  vlan_based_route_target_exports      = each.value.vlan_based_route_target_exports
}