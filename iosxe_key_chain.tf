locals {
  key_chain = flatten([
    for device in local.devices : [
      for chain in try(local.device_config[device.name].key_chains, []) : {
        key    = format("%s/%s", device.name, try(chain.name, null))
        device = device.name
        name   = try(chain.name, null)
        macsec = try(chain.macsec, null)
        tcp    = try(chain.tcp, null)
        keys = try(length(chain.keys) == 0, true) ? null : [for key in chain.keys : {
          id                             = try(tostring(key.id), null)
          cryptographic_algorithm        = try(key.cryptographic_algorithm, null)
          cryptographic_algorithm_tcp    = try(key.cryptographic_algorithm_tcp, null)
          cryptographic_algorithm_macsec = try(key.cryptographic_algorithm_macsec, null)
          key_string_encryption          = try(key.key_string_encryption, null)
          key_string_key                 = try(key.key_string_key, null)
          accept_lifetime_local          = try(key.accept_lifetime_local, null)
          accept_lifetime_start_time     = try(key.accept_lifetime_start_time, null)
          accept_lifetime_start_month    = try(key.accept_lifetime_start_month, null)
          accept_lifetime_start_day      = try(key.accept_lifetime_start_day, null)
          accept_lifetime_start_year     = try(key.accept_lifetime_start_year, null)
          accept_lifetime_duration       = try(key.accept_lifetime_duration, null)
          accept_lifetime_infinite       = try(key.accept_lifetime_infinite, null)
          accept_lifetime_end_time       = try(key.accept_lifetime_end_time, null)
          accept_lifetime_end_month      = try(key.accept_lifetime_end_month, null)
          accept_lifetime_end_day        = try(key.accept_lifetime_end_day, null)
          accept_lifetime_end_year       = try(key.accept_lifetime_end_year, null)
          send_lifetime_local            = try(key.send_lifetime_local, null)
          send_lifetime_start_time       = try(key.send_lifetime_start_time, null)
          send_lifetime_start_month      = try(key.send_lifetime_start_month, null)
          send_lifetime_start_day        = try(key.send_lifetime_start_day, null)
          send_lifetime_start_year       = try(key.send_lifetime_start_year, null)
          send_lifetime_duration         = try(key.send_lifetime_duration, null)
          send_lifetime_infinite         = try(key.send_lifetime_infinite, null)
          send_lifetime_end_time         = try(key.send_lifetime_end_time, null)
          send_lifetime_end_month        = try(key.send_lifetime_end_month, null)
          send_lifetime_end_day          = try(key.send_lifetime_end_day, null)
          send_lifetime_end_year         = try(key.send_lifetime_end_year, null)
          macsec_lifetime_local          = try(key.macsec_lifetime_local, null)
          macsec_lifetime_start_time     = try(key.macsec_lifetime_start_time, null)
          macsec_lifetime_start_month    = try(key.macsec_lifetime_start_month, null)
          macsec_lifetime_start_day      = try(key.macsec_lifetime_start_day, null)
          macsec_lifetime_start_year     = try(key.macsec_lifetime_start_year, null)
          macsec_lifetime_duration       = try(key.macsec_lifetime_duration, null)
          macsec_lifetime_infinite       = try(key.macsec_lifetime_infinite, null)
          macsec_lifetime_end_time       = try(key.macsec_lifetime_end_time, null)
          macsec_lifetime_end_month      = try(key.macsec_lifetime_end_month, null)
          macsec_lifetime_end_day        = try(key.macsec_lifetime_end_day, null)
          macsec_lifetime_end_year       = try(key.macsec_lifetime_end_year, null)
          send_id                        = try(key.send_id, null)
          recv_id                        = try(key.recv_id, null)
          include_tcp_options            = try(key.include_tcp_options, null)
          accept_ao_mismatch             = try(key.accept_ao_mismatch, null)
        }]
      }
    ]
  ])
}

resource "iosxe_key_chain" "key_chain" {
  for_each = { for e in local.key_chain : e.key => e }
  device   = each.value.device

  name   = each.value.name
  macsec = each.value.macsec
  tcp    = each.value.tcp
  keys   = each.value.keys
}
