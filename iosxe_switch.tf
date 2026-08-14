locals {
  switches = flatten([
    for device in local.devices : [
      for sw in try(local.device_config[device.name].system.switch_provision, []) : {
        key       = format("%s/%s", device.name, sw.number)
        device    = device.name
        number    = try(sw.number, null)
        provision = try(sw.provision, null)
      }
    ]
  ])
}

resource "iosxe_switch" "switch" {
  for_each = { for e in local.switches : e.key => e }
  device   = each.value.device

  number    = each.value.number
  provision = each.value.provision
}
