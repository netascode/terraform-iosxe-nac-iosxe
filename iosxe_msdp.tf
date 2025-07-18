locals {
  msdp_passwords = flatten([
    for device in local.devices : [
      for password in try(local.device_config[device.name].msdp.passwords, []) : {
        key    = format("%s/%s", device.name, password.addr)
        device = device.name

        addr       = try(password.addr, local.defaults.iosxe.configuration.msdp.passwords.addr, null)
        encryption = try(password.encryption, local.defaults.iosxe.configuration.msdp.passwords.encryption, null)
        password   = try(password.password, local.defaults.iosxe.configuration.msdp.passwords.password, null)
    }]
  ])

  msdp_peers = flatten([
    for device in local.devices : [
      for peer in try(local.device_config[device.name].msdp.peers, []) : {
        key    = format("%s/%s", device.name, peer.addr)
        device = device.name

        addr                    = try(peer.addr, local.defaults.iosxe.configuration.msdp.peers.addr, null)
        remote_as               = try(peer.remote_as, local.defaults.iosxe.configuration.msdp.peers.remote_as, null)
        connect_source_loopback = try(peer.connect_source_loopback, local.defaults.iosxe.configuration.msdp.peers.connect_source_loopback, null)
    }]
  ])
}

resource "iosxe_msdp" "msdp" {

  for_each      = { for device in local.devices : device.name => device if(try(local.device_config[device.name].msdp, null) != null || try(local.defaults.iosxe.configuration.msdp, null) != null) && try(local.device_config[device.name].msdp.vrf, null) == null || (try(local.defaults.iosxe.configuration.msdp.vrf, null) == null) }
  device        = each.value.name
  originator_id = try(local.device_config[each.value.name].msdp.originator_id, local.defaults.iosxe.configuration.msdp.originator_id, null)
  passwords     = length(local.msdp_passwords) > 0 ? local.msdp_passwords : null
  peers         = length(local.msdp_peers) > 0 ? local.msdp_peers : null
}

resource "iosxe_msdp_vrf" "msdp_vrf" {
  for_each = { for device in local.devices : device.name => device if(try(local.device_config[device.name].msdp, null) != null || try(local.defaults.iosxe.configuration.msdp, null) != null) && try(local.device_config[device.name].msdp.vrf, null) != null || (try(local.defaults.iosxe.configuration.msdp.vrf, null) != null) }
  device   = each.value.name

  vrf           = local.device_config[each.value.name].msdp.vrf
  originator_id = try(local.device_config[each.value.name].msdp.originator_id, local.defaults.iosxe.configuration.msdp.originator_id, null)
  passwords     = length(local.msdp_passwords) > 0 ? local.msdp_passwords : null
  peers         = length(local.msdp_peers) > 0 ? local.msdp_peers : null
}