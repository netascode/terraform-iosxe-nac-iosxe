resource "iosxe_wireless_system" "wireless_system" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].wireless.management_interface_type, null) != null }
  device   = each.value.name

  interface_name = format("%s%s",
    try(local.device_config[each.value.name].wireless.management_interface_type, null),
    try(local.device_config[each.value.name].wireless.management_interface_id, null)
  )

  depends_on = [iosxe_interface_vlan.vlan]
}

locals {
  # The controller stores MACs in lowercase colon form (00:00:00:00:0c:01).
  # Accept CLI dotted (0000.0000.0c01), colon or hyphen input in any case:
  # strip the separators, lowercase, and regroup the 12 hex digits in pairs.
  wireless_mobility = {
    for device in local.devices : device.name => {
      group_name               = try(local.device_config[device.name].wireless.mobility.group_name, null)
      mac_address              = try(join(":", regexall("[0-9a-f]{2}", lower(replace(local.device_config[device.name].wireless.mobility.mac_address, "/[^0-9A-Fa-f]/", "")))), null)
      group_keepalive_interval = try(local.device_config[device.name].wireless.mobility.group_keepalive_interval, null)
      group_keepalive_count    = try(local.device_config[device.name].wireless.mobility.group_keepalive_count, null)
      dscp                     = try(local.device_config[device.name].wireless.mobility.dscp, null)
      group_members = try(length(local.device_config[device.name].wireless.mobility.group_members) == 0, true) ? null : [
        for m in local.device_config[device.name].wireless.mobility.group_members : {
          mac_address = join(":", regexall("[0-9a-f]{2}", lower(replace(m.mac_address, "/[^0-9A-Fa-f]/", ""))))
          ip          = try(m.ip, null)
          # Over NETCONF an omitted nat-ip is stored as 0.0.0.0, while the CLI
          # stores the member's ip. Send ip so both paths give the same result.
          # An explicit 0.0.0.0 / :: means "no public IP": the controller
          # stores that when nat-ip is omitted and does not return it in
          # get-config, so it is sent as null to keep plans clean.
          public_ip            = contains(["0.0.0.0", "::"], try(m.public_ip, "")) ? null : try(m.public_ip, m.ip, null)
          group                = try(m.group, null)
          ssc_hash             = try(m.ssc_hash, null)
          data_link_encryption = try(m.data_link_encryption, null)
        }
      ]
    } if try(local.device_config[device.name].wireless.mobility, null) != null
  }
}

resource "iosxe_wireless_mobility" "wireless_mobility" {
  for_each = local.wireless_mobility
  device   = each.key

  group_name               = each.value.group_name
  mac_address              = each.value.mac_address
  group_keepalive_interval = each.value.group_keepalive_interval
  group_keepalive_count    = each.value.group_keepalive_count
  dscp                     = each.value.dscp
  group_members            = each.value.group_members
}
