resource "iosxe_dot1x" "dot1x" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].dot1x, null) != null || try(local.defaults.iosxe.configuration.dot1x, null) != null }
  device   = each.value.name

  auth_fail_eapol                 = try(local.device_config[each.value.name].dot1x.auth_fail_eapol, local.defaults.iosxe.configuration.dot1x.auth_fail_eapol, null)
  critical_eapol_config_block     = try(local.device_config[each.value.name].dot1x.critical_eapol_config_block, local.defaults.iosxe.configuration.dot1x.critical_eapol_config_block, null)
  critical_recovery_delay         = try(local.device_config[each.value.name].dot1x.critical_recovery_delay, local.defaults.iosxe.configuration.dot1x.critical_recovery_delay, null)
  test_timeout                    = try(local.device_config[each.value.name].dot1x.test_timeout, local.defaults.iosxe.configuration.dot1x.test_timeout, null)
  logging_verbose                 = try(local.device_config[each.value.name].dot1x.logging_verbose, local.defaults.iosxe.configuration.dot1x.logging_verbose, null)
  supplicant_controlled_transient = try(local.device_config[each.value.name].dot1x.supplicant_controlled_transient, local.defaults.iosxe.configuration.dot1x.supplicant_controlled_transient, null)
  supplicant_force_multicast      = try(local.device_config[each.value.name].dot1x.supplicant_force_multicast, local.defaults.iosxe.configuration.dot1x.supplicant_force_multicast, null)
  system_auth_control             = try(local.device_config[each.value.name].dot1x.system_auth_control, local.defaults.iosxe.configuration.dot1x.system_auth_control, null)

  credentials = try(length(local.device_config[each.value.name].dot1x.credentials) == 0, true) ? null : [
    for cred in local.device_config[each.value.name].dot1x.credentials : {
      profile_name   = try(cred.profile_name, local.defaults.iosxe.configuration.dot1x.credentials.profile_name, null)
      description    = try(cred.description, local.defaults.iosxe.configuration.dot1x.credentials.description, null)
      username       = try(cred.username, local.defaults.iosxe.configuration.dot1x.credentials.username, null)
      password_type  = try(cred.password_type, local.defaults.iosxe.configuration.dot1x.credentials.password_type, null)
      password       = try(cred.password, local.defaults.iosxe.configuration.dot1x.credentials.password, null)
      pki_trustpoint = try(cred.pki_trustpoint, local.defaults.iosxe.configuration.dot1x.credentials.pki_trustpoint, null)
      anonymous_id   = try(cred.anonymous_id, local.defaults.iosxe.configuration.dot1x.credentials.anonymous_id, null)
    }
  ]
}
