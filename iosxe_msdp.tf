resource "iosxe_msdp" "msdp" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].msdp, null) != null || try(local.defaults.iosxe.configuration.msdp, null) != null }
  device   = each.value.name

  originator_id = try(local.device_config[each.value.name].msdp.originator_id, local.defaults.iosxe.configuration.msdp.originator_id, null)
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

  depends_on = [
    iosxe_interface_loopback.loopback
  ]
}

locals {
  msdp_vrfs = flatten([
    for device in local.devices : [
      for vrf in try(local.device_config[device.name].msdp.vrfs, []) : {
        key           = format("%s/%s", device.name, vrf.vrf)
        device        = device.name
        vrf           = try(vrf.vrf, null)
        originator_id = try(local.device_config[device.name].msdp.originator_id, local.defaults.iosxe.configuration.msdp.originator_id, null)
        passwords = try(length(local.device_config[device.name].msdp.passwords) == 0, true) ? null : [for password in local.device_config[device.name].msdp.passwords : {
          addr       = try(password.host, local.defaults.iosxe.configuration.msdp.passwords.host, null)
          encryption = try(password.encryption, local.defaults.iosxe.configuration.msdp.passwords.encryption, null)
          password   = try(password.password, local.defaults.iosxe.configuration.msdp.passwords.password, null)
        }]
        peers = try(length(local.device_config[device.name].msdp.peers) == 0, true) ? null : [for peer in local.device_config[device.name].msdp.peers : {
          addr                    = try(peer.host, local.defaults.iosxe.configuration.msdp.peers.host, null)
          remote_as               = try(peer.remote_as, local.defaults.iosxe.configuration.msdp.peers.remote_as, null)
          connect_source_loopback = try(peer.connect_source_interface_type, local.defaults.iosxe.configuration.msdp.peers.connect_source_interface_type, null) == "Loopback" ? try(peer.connect_source_interface_id, local.defaults.iosxe.configuration.msdp.peers.connect_source_interface_id, null) : null
        }]
      }
    ]
  ])
}

resource "iosxe_msdp_vrf" "msdp_vrf" {
  for_each = { for e in local.msdp_vrfs : e.key => e }
  device   = each.value.device

  vrf           = each.value.vrf
  originator_id = each.value.originator_id
  passwords     = each.value.passwords
  peers         = each.value.peers

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_interface_loopback.loopback
  ]
}