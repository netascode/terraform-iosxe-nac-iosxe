resource "iosxe_mdt_subscription" "mdt_subscriptions" {
  for_each = {
    for idx, subscription in flatten([
      for device in local.devices : [
        for sub_idx, sub in try(local.device_config[device.name].mdt_subscriptions, []) : {
          key    = "${device.name}-${sub_idx}"
          device = device.name
          subscription = sub
        }
      ]
    ]) : subscription.key => subscription
  }

  device                  = each.value.device
  subscription_id         = each.value.subscription.id
  stream                  = try(each.value.subscription.stream, local.defaults.iosxe.configuration.mdt_subscriptions.stream, null)
  encoding                = try(each.value.subscription.encoding, local.defaults.iosxe.configuration.mdt_subscriptions.encoding, null)
  source_vrf              = try(each.value.subscription.source_vrf, local.defaults.iosxe.configuration.mdt_subscriptions.source_vrf, null)
  source_address          = try(each.value.subscription.source_address, local.defaults.iosxe.configuration.mdt_subscriptions.source_address, null)
  update_policy_on_change = try(each.value.subscription.update_policy_on_change, local.defaults.iosxe.configuration.mdt_subscriptions.update_policy_on_change, null)
  filter_xpath            = try(each.value.subscription.filter_xpath, local.defaults.iosxe.configuration.mdt_subscriptions.filter_xpath, null)

  receivers = [
    for r in try(each.value.subscription.receivers, local.defaults.iosxe.configuration.mdt_subscriptions.receivers, []) : {
      address  = r.address
      port     = r.port
      protocol = r.protocol
    }
  ]
}  