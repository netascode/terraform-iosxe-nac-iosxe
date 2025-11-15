resource "iosxe_ntp" "ntp" {
  for_each                    = { for device in local.devices : device.name => device if try(local.device_config[device.name].ntp, null) != null || try(local.defaults.iosxe.configuration.ntp, null) != null }
  device                      = each.value.name
  authenticate                = try(local.device_config[each.value.name].ntp.authenticate, local.defaults.iosxe.configuration.ntp.authenticate, null)
  logging                     = try(local.device_config[each.value.name].ntp.logging, local.defaults.iosxe.configuration.ntp.logging, null)
  access_group_peer_acl       = try(local.device_config[each.value.name].ntp.access_group_peer_acl, local.defaults.iosxe.configuration.ntp.access_group_peer_acl, null)
  access_group_query_only_acl = try(local.device_config[each.value.name].ntp.access_group_query_only_acl, local.defaults.iosxe.configuration.ntp.access_group_query_only_acl, null)
  access_group_serve_acl      = try(local.device_config[each.value.name].ntp.access_group_serve_acl, local.defaults.iosxe.configuration.ntp.access_group_serve_acl, null)
  access_group_serve_only_acl = try(local.device_config[each.value.name].ntp.access_group_serve_only_acl, local.defaults.iosxe.configuration.ntp.access_group_serve_only_acl, null)
  authentication_keys = try(length(local.device_config[each.value.name].ntp.authentication_keys) == 0, true) ? null : [for e in local.device_config[each.value.name].ntp.authentication_keys : {
    number          = try(e.number, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.number, null)
    md5             = try(e.mode, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.mode, null) == "md5" ? try(e.key, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.key, null) : null
    cmac_aes_128    = try(e.mode, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.mode, null) == "cmac_aes_128" ? try(e.key, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.key, null) : null
    hmac_sha1       = try(e.mode, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.mode, null) == "hmac_sha1" ? try(e.key, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.key, null) : null
    hmac_sha2_256   = try(e.mode, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.mode, null) == "hmac_sha2_256" ? try(e.key, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.key, null) : null
    sha1            = try(e.mode, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.mode, null) == "sha1" ? try(e.key, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.key, null) : null
    sha2            = try(e.mode, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.mode, null) == "sha2" ? try(e.key, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.key, null) : null
    encryption_type = try(e.encryption_type, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.encryption_type, null)
  }]
  clock_period                     = try(local.device_config[each.value.name].ntp.clock_period, local.defaults.iosxe.configuration.ntp.clock_period, null)
  master                           = try(local.device_config[each.value.name].ntp.master, local.defaults.iosxe.configuration.ntp.master, null)
  master_stratum                   = try(local.device_config[each.value.name].ntp.master_stratum, local.defaults.iosxe.configuration.ntp.master_stratum, null)
  passive                          = try(local.device_config[each.value.name].ntp.passive, local.defaults.iosxe.configuration.ntp.passive, null)
  source_gigabit_ethernet          = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "GigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].ntp.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_ten_gigabit_ethernet      = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "TenGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].ntp.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_forty_gigabit_ethernet    = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "FortyGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].ntp.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_hundred_gigabit_ethernet  = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "HundredGigabitEthernet" ? try(trimprefix(local.device_config[each.value.name].ntp.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_loopback                  = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "Loopback" ? try(local.device_config[each.value.name].ntp.source_interface_id, local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_port_channel              = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "PortChannel" ? try(trimprefix(local.device_config[each.value.name].ntp.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_port_channel_subinterface = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "PortChannelSubinterface" ? try(trimprefix(local.device_config[each.value.name].ntp.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  source_vlan                      = try(local.device_config[each.value.name].ntp.source_interface_type, local.defaults.iosxe.configuration.ntp.source_interface_type, null) == "Vlan" ? try(local.device_config[each.value.name].ntp.source_interface_id, local.defaults.iosxe.configuration.ntp.source_interface_id, null) : null
  update_calendar                  = try(local.device_config[each.value.name].ntp.update_calendar, local.defaults.iosxe.configuration.ntp.update_calendar, null)
  servers = try(length(local.device_config[each.value.name].ntp.servers) == 0, true) ? null : [for e in local.device_config[each.value.name].ntp.servers : {
    ip_address = try(e.ip, local.defaults.iosxe.configuration.ntp.ntp_servers.ip, null)
    source     = try("${try(e.source_interface_type, local.defaults.iosxe.configuration.ntp.ntp_servers.source_interface_type)}${try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.ntp_servers.source_interface_id)}", null)
    key        = try(e.key, local.defaults.iosxe.configuration.ntp.ntp_servers.key, null)
    prefer     = try(e.prefer, local.defaults.iosxe.configuration.ntp.ntp_servers.prefer, null)
    version    = try(e.version, local.defaults.iosxe.configuration.ntp.ntp_servers.version, null)
    burst      = try(e.burst, local.defaults.iosxe.configuration.ntp.ntp_servers.burst, null)
    iburst     = try(e.iburst, local.defaults.iosxe.configuration.ntp.ntp_servers.iburst, null)
    periodic   = try(e.periodic, local.defaults.iosxe.configuration.ntp.ntp_servers.periodic, null)
  } if try(e.vrf, null) == null]
  server_vrfs = try(length(distinct([for s in local.device_config[each.value.name].ntp.servers : s.vrf if try(s.vrf, null) != null])) == 0, true) ? null : [for vrf_name in distinct([for s in local.device_config[each.value.name].ntp.servers : s.vrf if try(s.vrf, null) != null]) : {
    name = vrf_name
    servers = try(length([for s in local.device_config[each.value.name].ntp.servers : s if try(s.vrf, null) == vrf_name]) == 0, true) ? null : [for s in local.device_config[each.value.name].ntp.servers : {
      ip_address = try(s.ip, local.defaults.iosxe.configuration.ntp.ntp_servers.ip, null)
      key        = try(s.key, local.defaults.iosxe.configuration.ntp.ntp_servers.key, null)
      prefer     = try(s.prefer, local.defaults.iosxe.configuration.ntp.ntp_servers.prefer, null)
      version    = try(s.version, local.defaults.iosxe.configuration.ntp.ntp_servers.version, null)
      burst      = try(s.burst, local.defaults.iosxe.configuration.ntp.ntp_servers.burst, null)
      iburst     = try(s.iburst, local.defaults.iosxe.configuration.ntp.ntp_servers.iburst, null)
      periodic   = try(s.periodic, local.defaults.iosxe.configuration.ntp.ntp_servers.periodic, null)
    } if try(s.vrf, null) == vrf_name]
  }]
  peers = try(length(local.device_config[each.value.name].ntp.peers) == 0, true) ? null : [for e in local.device_config[each.value.name].ntp.peers : {
    ip_address = try(e.ip, local.defaults.iosxe.configuration.ntp.ntp_peers.ip, null)
    source     = try("${try(e.source_interface_type, local.defaults.iosxe.configuration.ntp.ntp_servers.source_interface_type)}${try(trimprefix(e.source_interface_id, "$string "), local.defaults.iosxe.configuration.ntp.ntp_servers.source_interface_id)}", null)
    key        = try(e.key, local.defaults.iosxe.configuration.ntp.ntp_peers.key, null)
    prefer     = try(e.prefer, local.defaults.iosxe.configuration.ntp.ntp_peers.prefer, null)
    version    = try(e.version, local.defaults.iosxe.configuration.ntp.ntp_peers.version, null)
  } if try(e.vrf, null) == null]
  peer_vrfs = try(length(distinct([for p in local.device_config[each.value.name].ntp.peers : p.vrf if try(p.vrf, null) != null])) == 0, true) ? null : [for vrf_name in distinct([for p in local.device_config[each.value.name].ntp.peers : p.vrf if try(p.vrf, null) != null]) : {
    name = vrf_name
    peers = try(length([for p in local.device_config[each.value.name].ntp.peers : p if try(p.vrf, null) == vrf_name]) == 0, true) ? null : [for p in local.device_config[each.value.name].ntp.peers : {
      ip_address = try(p.ip, local.defaults.iosxe.configuration.ntp.ntp_peers.ip, null)
      key        = try(p.key, local.defaults.iosxe.configuration.ntp.ntp_peers.key, null)
      prefer     = try(p.prefer, local.defaults.iosxe.configuration.ntp.ntp_peers.prefer, null)
      version    = try(p.version, local.defaults.iosxe.configuration.ntp.ntp_peers.version, null)
    } if try(p.vrf, null) == vrf_name]
  }]
  trusted_keys = try(length(local.device_config[each.value.name].ntp.authentication_keys) == 0, true) ? null : [for e in local.device_config[each.value.name].ntp.authentication_keys : {
    number = try(e.number, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.number, null)
  } if try(e.trusted, null) != null && try(e.trusted, null) == true && try(tonumber(e.number), null) > 0 && try(tonumber(e.number), null) < 65536]

  depends_on = [
    iosxe_vrf.vrf,
    iosxe_interface_ethernet.ethernet,
    iosxe_interface_loopback.loopback,
    iosxe_interface_vlan.vlan,
    iosxe_interface_port_channel.port_channel,
    iosxe_interface_port_channel_subinterface.port_channel_subinterface,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended
  ]
}
