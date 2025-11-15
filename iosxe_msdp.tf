resource "iosxe_msdp" "msdp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].msdp, null) != null || try(local.defaults.iosxe.configuration.msdp, null) != null }
  device   = each.value.name

  originator_id = try("${try(local.device_config[each.value.name].msdp.originator_id_interface_type, local.defaults.iosxe.configuration.msdp.originator_id_interface_type)}${try(trimprefix(local.device_config[each.value.name].msdp.originator_id_interface_id, "$string "), local.defaults.iosxe.configuration.msdp.originator_id_interface_id)}", null)
  passwords = try(length(local.device_config[each.value.name].msdp.passwords) == 0, true) ? null : [for password in local.device_config[each.value.name].msdp.passwords : {
    addr       = try(password.host, local.defaults.iosxe.configuration.msdp.passwords.host, null)
    encryption = try(password.encryption, local.defaults.iosxe.configuration.msdp.passwords.encryption, null)
    password   = try(password.password, local.defaults.iosxe.configuration.msdp.passwords.password, null)
  }]
  peers = try(length(local.device_config[each.value.name].msdp.peers) == 0, true) ? null : [for peer in local.device_config[each.value.name].msdp.peers : {
    addr                    = try(peer.host, local.defaults.iosxe.configuration.msdp.peers.host, null)
    remote_as               = try(peer.remote_as, local.defaults.iosxe.configuration.msdp.peers.remote_as, null)
    connect_source_loopback = try(peer.connect_source_interface_type, local.defaults.iosxe.configuration.msdp.peers.connect_source_interface_type, null) == "Loopback" ? try(peer.connect_source_interface_id, local.defaults.iosxe.configuration.msdp.peers.connect_source_interface_id, null) : null
  }]
  vrfs = try(length(local.device_config[each.value.name].msdp.vrfs) == 0, true) ? null : [for vrf in local.device_config[each.value.name].msdp.vrfs : {
    vrf           = try(vrf.vrf, null)
    originator_id = try("${try(vrf.originator_id_interface_type, local.defaults.iosxe.configuration.msdp.vrfs.originator_id_interface_type)}${try(trimprefix(vrf.originator_id_interface_id, "$string "), local.defaults.iosxe.configuration.msdp.vrfs.originator_id_interface_id)}", null)
    passwords = try(length(vrf.passwords) == 0, true) ? null : [for password in vrf.passwords : {
      addr       = try(password.host, local.defaults.iosxe.configuration.msdp.passwords.host, null)
      encryption = try(password.encryption, local.defaults.iosxe.configuration.msdp.passwords.encryption, null)
      password   = try(password.password, local.defaults.iosxe.configuration.msdp.passwords.password, null)
    }]
    peers = try(length(vrf.peers) == 0, true) ? null : [for peer in vrf.peers : {
      addr                    = try(peer.host, local.defaults.iosxe.configuration.msdp.peers.host, null)
      remote_as               = try(peer.remote_as, local.defaults.iosxe.configuration.msdp.peers.remote_as, null)
      connect_source_loopback = try(peer.connect_source_interface_type, local.defaults.iosxe.configuration.msdp.peers.connect_source_interface_type, null) == "Loopback" ? try(peer.connect_source_interface_id, local.defaults.iosxe.configuration.msdp.peers.connect_source_interface_id, null) : null
    }]
  }]

  depends_on = [
    iosxe_interface_loopback.loopback
  ]
}
