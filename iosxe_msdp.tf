resource "iosxe_msdp" "msdp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].msdp, null) != null }
  device   = each.value.name

  originator_id = try("${try(local.device_config[each.value.name].msdp.originator_id_interface_type, null)}${try(trimprefix(local.device_config[each.value.name].msdp.originator_id_interface_id, "$string "), null)}", null)
  passwords = try(length(local.device_config[each.value.name].msdp.passwords) == 0, true) ? null : [for password in local.device_config[each.value.name].msdp.passwords : {
    addr       = try(password.host, null)
    encryption = try(password.encryption, null)
    password   = try(password.password, null)
  }]
  peers = try(length(local.device_config[each.value.name].msdp.peers) == 0, true) ? null : [for peer in local.device_config[each.value.name].msdp.peers : {
    addr                    = try(peer.host, null)
    remote_as               = try(peer.remote_as, null)
    connect_source_loopback = try(peer.connect_source_interface_type, null) == "Loopback" ? try(peer.connect_source_interface_id, null) : null
  }]
  vrfs = try(length(local.device_config[each.value.name].msdp.vrfs) == 0, true) ? null : [for vrf in local.device_config[each.value.name].msdp.vrfs : {
    vrf           = try(vrf.vrf, null)
    originator_id = try("${try(vrf.originator_id_interface_type, null)}${try(trimprefix(vrf.originator_id_interface_id, "$string "), null)}", null)
    passwords = try(length(vrf.passwords) == 0, true) ? null : [for password in vrf.passwords : {
      addr       = try(password.host, null)
      encryption = try(password.encryption, null)
      password   = try(password.password, null)
    }]
    peers = try(length(vrf.peers) == 0, true) ? null : [for peer in vrf.peers : {
      addr                    = try(peer.host, null)
      remote_as               = try(peer.remote_as, null)
      connect_source_loopback = try(peer.connect_source_interface_type, null) == "Loopback" ? try(peer.connect_source_interface_id, null) : null
    }]
  }]

  depends_on = [
    iosxe_interface_loopback.loopback
  ]
}
