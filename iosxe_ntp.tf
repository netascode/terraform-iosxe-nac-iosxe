resource "iosxe_ntp" "ntp" {
  for_each                    = { for device in local.devices : device.name => device if try(local.device_config[device.name].ntp, null) != null || try(local.defaults.iosxe.configuration.ntp, null) != null }
  device                      = each.value.name
  authenticate                = try(local.device_config[each.value.name].ntp.authenticate, local.defaults.iosxe.configuration.ntp.authenticate, null)
  logging                     = try(local.device_config[each.value.name].ntp.logging, local.defaults.iosxe.configuration.ntp.logging, null)
  access_group_peer_acl       = try(local.device_config[each.value.name].ntp.access_group_peer_acl, local.defaults.iosxe.configuration.ntp.access_group_peer_acl, null)
  access_group_query_only_acl = try(local.device_config[each.value.name].ntp.access_group_query_only_acl, local.defaults.iosxe.configuration.ntp.access_group_query_only_acl, null)
  access_group_serve_acl      = try(local.device_config[each.value.name].ntp.access_group_serve_acl, local.defaults.iosxe.configuration.ntp.access_group_serve_acl, null)
  access_group_serve_only_acl = try(local.device_config[each.value.name].ntp.access_group_serve_only_acl, local.defaults.iosxe.configuration.ntp.access_group_serve_only_acl, null)
  authentication_keys = [for e in try(local.device_config[each.value.name].ntp.authentication_keys, []) : {
    number          = try(e.number, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.number, null)
    md5             = try(e.md5, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.md5, null)
    cmac_aes_128    = try(e.cmac_aes_128, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.cmac_aes_128, null)
    hmac_sha1       = try(e.hmac_sha1, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.hmac_sha1, null)
    hmac_sha2_256   = try(e.hmac_sha2_256, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.hmac_sha2_256, null)
    sha1            = try(e.sha1, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.sha1, null)
    sha2            = try(e.sha2, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.sha2, null)
    encryption_type = try(e.encryption_type, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.encryption_type, null)
  }]
  clock_period                          = try(local.device_config[each.value.name].ntp.clock_period, local.defaults.iosxe.configuration.ntp.clock_period, null)
  master                                = try(local.device_config[each.value.name].ntp.master, local.defaults.iosxe.configuration.ntp.master, null)
  master_stratum                        = try(local.device_config[each.value.name].ntp.master_stratum, local.defaults.iosxe.configuration.ntp.master_stratum, null)
  passive                               = try(local.device_config[each.value.name].ntp.passive, local.defaults.iosxe.configuration.ntp.passive, null)
  trap_source_gigabit_ethernet          = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.ethernets, []) : e.id if e.type == "GigabitEthernet" && e.id == try(local.device_config[each.value.name].ntp.trap_source, null)]) > 0 ? try(local.device_config[each.value.name].ntp.trap_source, null) : null
  trap_source_ten_gigabit_ethernet      = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.ethernets, []) : e.id if e.type == "TenGigabitEthernet" && e.id == try(local.device_config[each.value.name].ntp.trap_source, null)]) > 0 ? try(local.device_config[each.value.name].ntp.trap_source, null) : null
  trap_source_forty_gigabit_ethernet    = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.ethernets, []) : e.id if e.type == "FortyGigabitEthernet" && e.id == try(local.device_config[each.value.name].ntp.trap_source, null)]) > 0 ? try(local.device_config[each.value.name].ntp.trap_source, null) : null
  trap_source_hundred_gigabit_ethernet  = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.ethernets, []) : e.id if e.type == "HundredGigE" && e.id == try(local.device_config[each.value.name].ntp.trap_source, null)]) > 0 ? try(local.device_config[each.value.name].ntp.trap_source, null) : null
  trap_source_loopback                  = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.loopbacks, []) : e.id if e.id == try(tonumber(local.device_config[each.value.name].ntp.trap_source), null)]) > 0 ? try(tonumber(local.device_config[each.value.name].ntp.trap_source), null) : null
  trap_source_port_channel              = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.port_channels, []) : e.name if e.name == try(tonumber(local.device_config[each.value.name].ntp.trap_source), null)]) > 0 ? try(tonumber(local.device_config[each.value.name].ntp.trap_source), null) : null
  trap_source_port_channel_subinterface = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.port_channels, []) : [for subinterface in try(e.subinterfaces, []) : subinterface.name if subinterface.name == try(local.device_config[each.value.name].ntp.trap_source, null)]]) > 0 ? try(local.device_config[each.value.name].ntp.trap_source, null) : null
  trap_source_vlan                      = (try(local.device_config[each.value.name].ntp.trap_source, null) != null) && length([for e in try(local.device_config[each.value.name].interfaces.vlans, []) : e.id if e.id == try(tonumber(local.device_config[each.value.name].ntp.trap_source), null)]) > 0 ? try(tonumber(local.device_config[each.value.name].ntp.trap_source), null) : null
  update_calendar                       = try(local.device_config[each.value.name].ntp.update_calendar, local.defaults.iosxe.configuration.ntp.update_calendar, null)
  servers = [for e in try(local.device_config[each.value.name].ntp.servers, []) : {
    ip_address = try(e.ip, local.defaults.iosxe.configuration.ntp.ntp_servers.ip, null)
    source     = try(e.source, local.defaults.iosxe.configuration.ntp.ntp_servers.source, null)
    key        = try(e.key, local.defaults.iosxe.configuration.ntp.ntp_servers.key, null)
    prefer     = try(e.prefer, local.defaults.iosxe.configuration.ntp.ntp_servers.prefer, null)
    version    = try(e.version, local.defaults.iosxe.configuration.ntp.ntp_servers.version, null)
  } if try(e.vrf, null) == null]
  server_vrfs = [for vrf_name in distinct([for s in try(local.device_config[each.value.name].ntp.servers, []) : s.vrf if try(s.vrf, null) != null]) : {
    name = vrf_name
    servers = [for s in try(local.device_config[each.value.name].ntp.servers, []) : {
      ip_address = try(s.ip, local.defaults.iosxe.configuration.ntp.ntp_servers.ip, null)
      key        = try(s.key, local.defaults.iosxe.configuration.ntp.ntp_servers.key, null)
      prefer     = try(s.prefer, local.defaults.iosxe.configuration.ntp.ntp_servers.prefer, null)
      version    = try(s.version, local.defaults.iosxe.configuration.ntp.ntp_servers.version, null)
    } if try(s.vrf, null) == vrf_name]
  }]
  peers = [for e in try(local.device_config[each.value.name].ntp.peers, []) : {
    ip_address = try(e.ip, local.defaults.iosxe.configuration.ntp.ntp_peers.ip, null)
    source     = try(e.source, local.defaults.iosxe.configuration.ntp.ntp_peers.source, null)
    key        = try(e.key, local.defaults.iosxe.configuration.ntp.ntp_peers.key, null)
    prefer     = try(e.prefer, local.defaults.iosxe.configuration.ntp.ntp_peers.prefer, null)
    version    = try(e.version, local.defaults.iosxe.configuration.ntp.ntp_peers.version, null)
  } if try(e.vrf, null) == null]
  peer_vrfs = [for vrf_name in distinct([for p in try(local.device_config[each.value.name].ntp.peers, []) : p.vrf if try(p.vrf, null) != null]) : {
    name = vrf_name
    peers = [for p in try(local.device_config[each.value.name].ntp.peers, []) : {
      ip_address = try(p.ip, local.defaults.iosxe.configuration.ntp.ntp_peers.ip, null)
      key        = try(p.key, local.defaults.iosxe.configuration.ntp.ntp_peers.key, null)
      prefer     = try(p.prefer, local.defaults.iosxe.configuration.ntp.ntp_peers.prefer, null)
      version    = try(p.version, local.defaults.iosxe.configuration.ntp.ntp_peers.version, null)
    } if try(p.vrf, null) == vrf_name]
  }]
  trusted_keys = [for e in try(local.device_config[each.value.name].ntp.authentication_keys, []) : {
    number = try(e.number, local.defaults.iosxe.configuration.ntp.ntp_authentication_keys.number, null)
  } if try(e.trusted, null) != null && try(e.trusted, null) == true && try(tonumber(e.number), null) > 0 && try(tonumber(e.number), null) < 65536]
}