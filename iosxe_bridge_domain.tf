locals {
  bridge_domains = flatten([
    for device in local.devices : [
      for bd in try(local.device_config[device.name].bridge_domains, []) : {
        key        = format("%s/BD%s", device.name, try(bd.id, null))
        device     = device.name
        id         = trimprefix(bd.id, "$string ")
        member_vni = try(bd.member_vni, null)
        member_interfaces = try(length(bd.member_interfaces) == 0, true) ? null : [for mi in bd.member_interfaces : {
          interface = try(mi.name, null)
          service_instance = [{
            instance_id = try(mi.service_instance, null)
          }]
        }]
      }
    ]
  ])
}

resource "iosxe_bridge_domain" "bridge_domain" {
  for_each = { for v in local.bridge_domains : v.key => v }
  device   = each.value.device

  bridge_domain_id  = each.value.id
  member_vni        = each.value.member_vni
  member_interfaces = each.value.member_interfaces

  depends_on = [
    iosxe_interface_ethernet.ethernet
  ]
}
