locals {
  mdt_subscriptions = flatten([
    for device in local.devices : [
      for sub in try(local.device_config[device.name].mdt_subscriptions, []) : {
        key                     = format("%s/%s", device.name, sub.id)
        device                  = device.name
        subscription_id         = sub.id
        stream                  = try(sub.stream, local.defaults.iosxe.configuration.mdt_subscriptions.stream, null)
        encoding                = try(sub.encoding, local.defaults.iosxe.configuration.mdt_subscriptions.encoding, null)
        source_vrf              = try(sub.source_vrf, local.defaults.iosxe.configuration.mdt_subscriptions.source_vrf, null)
        source_address          = try(sub.source_ip, local.defaults.iosxe.configuration.mdt_subscriptions.source_ip, null)
        update_policy_periodic  = try(sub.update_policy_periodic, local.defaults.iosxe.configuration.mdt_subscriptions.update_policy_periodic, null)
        update_policy_on_change = try(sub.update_policy_on_change, local.defaults.iosxe.configuration.mdt_subscriptions.update_policy_on_change, null)
        filter_xpath            = try(sub.filter_xpath, local.defaults.iosxe.configuration.mdt_subscriptions.filter_xpath, null)

        receivers = [
          for r in try(sub.receivers, local.defaults.iosxe.configuration.mdt_subscriptions.receivers, []) : {
            address  = try(r.ip, local.defaults.iosxe.configuration.mdt_subscriptions.receivers.ip, null)
            port     = try(r.port, local.defaults.iosxe.configuration.mdt_subscriptions.receivers.port, null)
            protocol = try(r.protocol, local.defaults.iosxe.configuration.mdt_subscriptions.receivers.protocol, null)
          }
        ]
      }
    ]
  ])
}
resource "iosxe_mdt_subscription" "mdt_subscriptions" {
  for_each = { for e in local.mdt_subscriptions : e.key => e }

  device                  = each.value.device
  subscription_id         = each.value.subscription_id
  stream                  = each.value.stream
  encoding                = each.value.encoding
  source_vrf              = each.value.source_vrf
  source_address          = each.value.source_address
  update_policy_periodic  = each.value.update_policy_periodic
  update_policy_on_change = each.value.update_policy_on_change
  filter_xpath            = each.value.filter_xpath
  receivers               = each.value.receivers
}
