locals {
  wireless_wlan_ft_map  = { enabled = "dot11r-enabled", adaptive = "dot11r-adaptive-enabled", disabled = "dot11r-disabled" }
  wireless_wlan_p2p_map = { drop = "p2p-blocking-action-drop", "forward-upstream" = "p2p-blocking-action-fwdup" }
  wireless_wlan_wmm_map = { allowed = "apf-vap-wme-allowed", require = "apf-vap-wme-required", disabled = "apf-vap-wme-disabled" }
  wireless_wlan_psk_map = { ascii = "key-ascii", hex = "key-hex" }

  wireless_wlan_profiles = flatten([
    for device in local.devices : [
      for wlan in try(local.device_config[device.name].wireless.wlan_profiles, []) : {
        key            = format("%s/%s", device.name, wlan.name)
        device         = device.name
        profile_name   = wlan.name
        wlan_id        = wlan.wlan_id
        ssid           = wlan.ssid
        wlan_status    = try(wlan.shutdown, null) == null ? null : !wlan.shutdown
        broadcast_ssid = try(wlan.broadcast_ssid, null)
        ccx_aironet_ie = try(wlan.ccx_aironet_iesupport, null)
        peer_blocking  = try(local.wireless_wlan_p2p_map[wlan.peer_blocking], null)

        # security_wpa_akm -> six provider booleans (explicit-set rule)
        security_wpa_akm_dot1x    = try(contains(wlan.security_wpa_akm, "dot1x") ? true : false, null)
        security_wpa_akm_ft_dot1x = try(contains(wlan.security_wpa_akm, "ft-dot1x") ? true : false, null)
        security_wpa_akm_psk      = try(contains(wlan.security_wpa_akm, "psk") ? true : false, null)
        security_wpa_akm_ft_psk   = try(contains(wlan.security_wpa_akm, "ft-psk") ? true : false, null)
        security_wpa_akm_sae      = try(contains(wlan.security_wpa_akm, "sae") ? true : false, null)
        security_wpa_akm_ft_sae   = try(contains(wlan.security_wpa_akm, "ft-sae") ? true : false, null)

        # security_wpa_wpa2_ciphers -> three provider booleans (explicit-set rule)
        security_wpa_wpa2_ciphers_aes     = try(contains(wlan.security_wpa_wpa2_ciphers, "aes") ? true : false, null)
        security_wpa_wpa2_ciphers_gcmp128 = try(contains(wlan.security_wpa_wpa2_ciphers, "gcmp128") ? true : false, null)
        security_wpa_wpa2_ciphers_gcmp256 = try(contains(wlan.security_wpa_wpa2_ciphers, "gcmp256") ? true : false, null)

        security_wpa_wpa3                     = try(wlan.security_wpa_wpa3, null)
        security_wpa_psk_key_format           = try(local.wireless_wlan_psk_map[wlan.security_wpa_psk_key_format], null)
        security_wpa_psk_key_encryption       = try(wlan.security_wpa_psk_key, null) != null ? "clear" : null
        security_wpa_psk_key                  = try(wlan.security_wpa_psk_key, null)
        security_dot1x_authentication_list    = try(wlan.security_dot1x_authentication_list, null)
        security_web_auth                     = try(wlan.security_web_auth, null)
        security_web_auth_authentication_list = try(wlan.security_web_auth_authentication_list, null)
        security_web_auth_parameter_map       = try(wlan.security_web_auth_parameter_map, null)
        security_ft                           = try(local.wireless_wlan_ft_map[wlan.security_ft], null)
        security_ft_over_the_ds               = try(wlan.security_ft_over_the_ds, null)
        mac_filtering                         = try(wlan.mac_filtering, null)
        load_balance                          = try(wlan.load_balance, null)
        wmm                                   = try(local.wireless_wlan_wmm_map[wlan.wmm], null)
      }
    ]
  ])
}

resource "iosxe_wireless_wlan_profile" "wireless_wlan_profile" {
  for_each = { for e in local.wireless_wlan_profiles : e.key => e }

  device                                = each.value.device
  profile_name                          = each.value.profile_name
  wlan_id                               = each.value.wlan_id
  ssid                                  = each.value.ssid
  wlan_status                           = each.value.wlan_status
  broadcast_ssid                        = each.value.broadcast_ssid
  ccx_aironet_ie                        = each.value.ccx_aironet_ie
  peer_blocking                         = each.value.peer_blocking
  security_wpa_akm_dot1x                = each.value.security_wpa_akm_dot1x
  security_wpa_akm_ft_dot1x             = each.value.security_wpa_akm_ft_dot1x
  security_wpa_akm_psk                  = each.value.security_wpa_akm_psk
  security_wpa_akm_ft_psk               = each.value.security_wpa_akm_ft_psk
  security_wpa_akm_sae                  = each.value.security_wpa_akm_sae
  security_wpa_akm_ft_sae               = each.value.security_wpa_akm_ft_sae
  security_wpa_wpa2_ciphers_aes         = each.value.security_wpa_wpa2_ciphers_aes
  security_wpa_wpa2_ciphers_gcmp128     = each.value.security_wpa_wpa2_ciphers_gcmp128
  security_wpa_wpa2_ciphers_gcmp256     = each.value.security_wpa_wpa2_ciphers_gcmp256
  security_wpa_wpa3                     = each.value.security_wpa_wpa3
  security_wpa_psk_key_format           = each.value.security_wpa_psk_key_format
  security_wpa_psk_key_encryption       = each.value.security_wpa_psk_key_encryption
  security_wpa_psk_key                  = each.value.security_wpa_psk_key
  security_dot1x_authentication_list    = each.value.security_dot1x_authentication_list
  security_web_auth                     = each.value.security_web_auth
  security_web_auth_authentication_list = each.value.security_web_auth_authentication_list
  security_web_auth_parameter_map       = each.value.security_web_auth_parameter_map
  security_ft                           = each.value.security_ft
  security_ft_over_the_ds               = each.value.security_ft_over_the_ds
  mac_filtering                         = each.value.mac_filtering
  load_balance                          = each.value.load_balance
  wmm                                   = each.value.wmm
}
