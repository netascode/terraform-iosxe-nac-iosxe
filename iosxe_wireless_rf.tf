locals {
  wireless_rf_band_map = {
    "24ghz" = "dot11-2-dot-4-ghz-band"
    "5ghz"  = "dot11-5-ghz-band"
    "6ghz"  = "dot11-6-ghz-band"
  }
  wireless_rf_rate_map = {
    "mandatory" = "apf-tx-rate-basic"
    "supported" = "apf-tx-rate-supported"
    "disable"   = "apf-tx-rate-unsupported"
  }

  # YANG defaults (Cisco-IOS-XE-wireless-rf-cfg, identical in 17.15.1 and 17.18.1).
  # The controller omits a leaf at its default from get-config, so a value equal
  # to its default is sent as null and the device keeps its default; otherwise
  # every such value shows a diff on every plan.
  wireless_rf_yang_defaults = {
    data_rate_1m                   = "apf-tx-rate-basic"
    data_rate_2m                   = "apf-tx-rate-basic"
    data_rate_5_5m                 = "apf-tx-rate-basic"
    data_rate_11m                  = "apf-tx-rate-basic"
    data_rate_6m                   = "apf-tx-rate-not-applicable"
    data_rate_9m                   = "apf-tx-rate-supported"
    data_rate_12m                  = "apf-tx-rate-not-applicable"
    data_rate_18m                  = "apf-tx-rate-supported"
    data_rate_24m                  = "apf-tx-rate-not-applicable"
    data_rate_36m                  = "apf-tx-rate-supported"
    data_rate_48m                  = "apf-tx-rate-supported"
    data_rate_54m                  = "apf-tx-rate-supported"
    band_select_client_rssi        = -80
    band_select_cycle_count        = 2
    band_select_cycle_threshold    = 200
    band_select_expire_dual_band   = 60
    band_select_expire_suppression = 20
    coverage_data_rssi_threshold   = -80
    coverage_voice_rssi_threshold  = -80
    coverage_level_global          = 3
    load_balancing_window          = 5
    load_balancing_denial          = 3
    max_clients                    = 200
    tx_power_v1_threshold          = -70
    tx_power_max                   = 30
    tx_power_min                   = -10
    trap_threshold_clients         = 12
    trap_threshold_interference    = 10
    trap_threshold_noise           = -70
  }

  wireless_rf_profiles = flatten([
    for device in local.devices : [
      for p in try(local.device_config[device.name].wireless.rf_profiles, []) : {
        key                            = format("%s/%s", device.name, p.name)
        device                         = device.name
        name                           = p.name
        band                           = try(local.wireless_rf_band_map[p.band], null)
        status                         = try(!p.shutdown, null)
        description                    = try(p.description, null)
        data_rate_1m                   = try(local.wireless_rf_rate_map[p.rate_1m], null) == local.wireless_rf_yang_defaults.data_rate_1m ? null : try(local.wireless_rf_rate_map[p.rate_1m], null)
        data_rate_2m                   = try(local.wireless_rf_rate_map[p.rate_2m], null) == local.wireless_rf_yang_defaults.data_rate_2m ? null : try(local.wireless_rf_rate_map[p.rate_2m], null)
        data_rate_5_5m                 = try(local.wireless_rf_rate_map[p.rate_5_5m], null) == local.wireless_rf_yang_defaults.data_rate_5_5m ? null : try(local.wireless_rf_rate_map[p.rate_5_5m], null)
        data_rate_11m                  = try(local.wireless_rf_rate_map[p.rate_11m], null) == local.wireless_rf_yang_defaults.data_rate_11m ? null : try(local.wireless_rf_rate_map[p.rate_11m], null)
        data_rate_6m                   = try(local.wireless_rf_rate_map[p.rate_6m], null) == local.wireless_rf_yang_defaults.data_rate_6m ? null : try(local.wireless_rf_rate_map[p.rate_6m], null)
        data_rate_9m                   = try(local.wireless_rf_rate_map[p.rate_9m], null) == local.wireless_rf_yang_defaults.data_rate_9m ? null : try(local.wireless_rf_rate_map[p.rate_9m], null)
        data_rate_12m                  = try(local.wireless_rf_rate_map[p.rate_12m], null) == local.wireless_rf_yang_defaults.data_rate_12m ? null : try(local.wireless_rf_rate_map[p.rate_12m], null)
        data_rate_18m                  = try(local.wireless_rf_rate_map[p.rate_18m], null) == local.wireless_rf_yang_defaults.data_rate_18m ? null : try(local.wireless_rf_rate_map[p.rate_18m], null)
        data_rate_24m                  = try(local.wireless_rf_rate_map[p.rate_24m], null) == local.wireless_rf_yang_defaults.data_rate_24m ? null : try(local.wireless_rf_rate_map[p.rate_24m], null)
        data_rate_36m                  = try(local.wireless_rf_rate_map[p.rate_36m], null) == local.wireless_rf_yang_defaults.data_rate_36m ? null : try(local.wireless_rf_rate_map[p.rate_36m], null)
        data_rate_48m                  = try(local.wireless_rf_rate_map[p.rate_48m], null) == local.wireless_rf_yang_defaults.data_rate_48m ? null : try(local.wireless_rf_rate_map[p.rate_48m], null)
        data_rate_54m                  = try(local.wireless_rf_rate_map[p.rate_54m], null) == local.wireless_rf_yang_defaults.data_rate_54m ? null : try(local.wireless_rf_rate_map[p.rate_54m], null)
        band_select_client_rssi        = try(p.band_select_client_rssi, null) == local.wireless_rf_yang_defaults.band_select_client_rssi ? null : try(p.band_select_client_rssi, null)
        band_select_cycle_count        = try(p.band_select_cycle_count, null) == local.wireless_rf_yang_defaults.band_select_cycle_count ? null : try(p.band_select_cycle_count, null)
        band_select_cycle_threshold    = try(p.band_select_cycle_threshold, null) == local.wireless_rf_yang_defaults.band_select_cycle_threshold ? null : try(p.band_select_cycle_threshold, null)
        band_select_expire_dual_band   = try(p.band_select_expire_dual_band, null) == local.wireless_rf_yang_defaults.band_select_expire_dual_band ? null : try(p.band_select_expire_dual_band, null)
        band_select_expire_suppression = try(p.band_select_expire_suppression, null) == local.wireless_rf_yang_defaults.band_select_expire_suppression ? null : try(p.band_select_expire_suppression, null)
        coverage_data_rssi_threshold   = try(p.coverage_data_rssi_threshold, null) == local.wireless_rf_yang_defaults.coverage_data_rssi_threshold ? null : try(p.coverage_data_rssi_threshold, null)
        coverage_voice_rssi_threshold  = try(p.coverage_voice_rssi_threshold, null) == local.wireless_rf_yang_defaults.coverage_voice_rssi_threshold ? null : try(p.coverage_voice_rssi_threshold, null)
        coverage_level_global          = try(p.coverage_level_global, null) == local.wireless_rf_yang_defaults.coverage_level_global ? null : try(p.coverage_level_global, null)
        load_balancing_window          = try(p.load_balancing_window, null) == local.wireless_rf_yang_defaults.load_balancing_window ? null : try(p.load_balancing_window, null)
        load_balancing_denial          = try(p.load_balancing_denial, null) == local.wireless_rf_yang_defaults.load_balancing_denial ? null : try(p.load_balancing_denial, null)
        max_clients                    = try(p.max_clients, null) == local.wireless_rf_yang_defaults.max_clients ? null : try(p.max_clients, null)
        tx_power_v1_threshold          = try(p.tx_power_v1_threshold, null) == local.wireless_rf_yang_defaults.tx_power_v1_threshold ? null : try(p.tx_power_v1_threshold, null)
        tx_power_max                   = try(p.tx_power_max, null) == local.wireless_rf_yang_defaults.tx_power_max ? null : try(p.tx_power_max, null)
        tx_power_min                   = try(p.tx_power_min, null) == local.wireless_rf_yang_defaults.tx_power_min ? null : try(p.tx_power_min, null)
        trap_threshold_clients         = try(p.trap_threshold_clients, null) == local.wireless_rf_yang_defaults.trap_threshold_clients ? null : try(p.trap_threshold_clients, null)
        trap_threshold_interference    = try(p.trap_threshold_interference, null) == local.wireless_rf_yang_defaults.trap_threshold_interference ? null : try(p.trap_threshold_interference, null)
        trap_threshold_noise           = try(p.trap_threshold_noise, null) == local.wireless_rf_yang_defaults.trap_threshold_noise ? null : try(p.trap_threshold_noise, null)

        dca_allowed_channels = try(length(p.dca_channels_allowed) == 0, true) ? null : [
          for ch in try(p.dca_channels_allowed, []) : {
            channel = ch
          }
        ]
      }
    ]
  ])
}

resource "iosxe_wireless_rf_profile" "wireless_rf_profile" {
  for_each = { for e in local.wireless_rf_profiles : e.key => e }

  device                         = each.value.device
  name                           = each.value.name
  band                           = each.value.band
  status                         = each.value.status
  description                    = each.value.description
  data_rate_1m                   = each.value.data_rate_1m
  data_rate_2m                   = each.value.data_rate_2m
  data_rate_5_5m                 = each.value.data_rate_5_5m
  data_rate_11m                  = each.value.data_rate_11m
  data_rate_6m                   = each.value.data_rate_6m
  data_rate_9m                   = each.value.data_rate_9m
  data_rate_12m                  = each.value.data_rate_12m
  data_rate_18m                  = each.value.data_rate_18m
  data_rate_24m                  = each.value.data_rate_24m
  data_rate_36m                  = each.value.data_rate_36m
  data_rate_48m                  = each.value.data_rate_48m
  data_rate_54m                  = each.value.data_rate_54m
  band_select_client_rssi        = each.value.band_select_client_rssi
  band_select_cycle_count        = each.value.band_select_cycle_count
  band_select_cycle_threshold    = each.value.band_select_cycle_threshold
  band_select_expire_dual_band   = each.value.band_select_expire_dual_band
  band_select_expire_suppression = each.value.band_select_expire_suppression
  dca_allowed_channels           = each.value.dca_allowed_channels
  coverage_data_rssi_threshold   = each.value.coverage_data_rssi_threshold
  coverage_voice_rssi_threshold  = each.value.coverage_voice_rssi_threshold
  coverage_level_global          = each.value.coverage_level_global
  load_balancing_window          = each.value.load_balancing_window
  load_balancing_denial          = each.value.load_balancing_denial
  max_clients                    = each.value.max_clients
  tx_power_v1_threshold          = each.value.tx_power_v1_threshold
  tx_power_max                   = each.value.tx_power_max
  tx_power_min                   = each.value.tx_power_min
  trap_threshold_clients         = each.value.trap_threshold_clients
  trap_threshold_interference    = each.value.trap_threshold_interference
  trap_threshold_noise           = each.value.trap_threshold_noise
}
