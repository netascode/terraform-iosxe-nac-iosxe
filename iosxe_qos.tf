resource "iosxe_qos" "qos" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].qos, null) != null || try(local.defaults.iosxe.configuration.qos, null) != null }
  device   = each.value.name

  queue_softmax_multiplier = try(local.device_config[each.value.name].qos.queue_softmax_multiplier, local.defaults.iosxe.configuration.qos.queue_softmax_multiplier, null)
}
