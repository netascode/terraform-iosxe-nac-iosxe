locals {
  nves = flatten([
    for device in local.devices : [
      for nve in try(local.device_config[device.name].interfaces.nves, []) : {
        key    = format("%s/%s", device.name, nve.id)
        device = device.name

        id                             = nve.id
        description                    = try(nve.description, local.defaults.iosxe.configuration.interfaces.nves.description, null)
        shutdown                       = try(nve.shutdown, local.defaults.iosxe.configuration.interfaces.nves.name.shutdown, null)
        host_reachability_protocol_bgp = try(nve.host_reachability_protocol_bgp, local.defaults.iosxe.configuration.interfaces.nves.name.host_reachability_protocol_bgp, null)
        source_interface_loopback      = try(nve.source_interface_loopback, local.defaults.iosxe.configuration.interfaces.nves.name.source_interface_loopback, null)

        # Lists
        vni_vrfs = [for vni_vrf in try(nve.vni_vrfs, []) : {
          vni_range = "${vni_vrf.vni_from}-${vni_vrf.vni_to}"
          vrf       = try(vni_vrf.vrf, local.defaults.iosxe.configuration.interfaces.nves.vni_vrfs.vrf, null)
          }
        ]

        vnis = [for vni in try(nve.vnis, []) : {
          vni_range            = "${vni.vni_from}-${vni.vni_to}"
          ipv4_multicast_group = try(vni.ipv4_multicast_group, local.defaults.iosxe.configuration.interfaces.nves.vnis.ipv4_multicast_group, null)
          ingress_replication  = try(vni.ingress_replication, local.defaults.iosxe.configuration.interfaces.nves.vnis.ingress_replication, null)
          }
        ]
    }]
  ])
}

resource "iosxe_interface_nve" "nves" {
  for_each = { for e in local.nves : e.key => e }
  device   = each.value.device

  name                           = each.value.id
  description                    = each.value.description
  shutdown                       = each.value.shutdown
  host_reachability_protocol_bgp = each.value.host_reachability_protocol_bgp
  source_interface_loopback      = each.value.source_interface_loopback

  # Lists
  vnis     = each.value.vnis
  vni_vrfs = each.value.vni_vrfs
}
