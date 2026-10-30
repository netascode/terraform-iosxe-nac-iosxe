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
  # Accept CLI dotted (0000.0000.0c01), colon, hyphen or bare
  # (000000000c01) input in any case: strip the separators, lowercase, and
  # regroup the 12 hex digits in pairs. Anything that does not leave exactly
  # 12 hex digits is passed through unchanged so the provider's MAC pattern
  # rejects it instead of it being silently truncated.
  wireless_mobility_raw = {
    for device in local.devices : device.name => local.device_config[device.name].wireless.mobility
    if try(local.device_config[device.name].wireless.mobility, null) != null
  }
  # Raw MAC -> normalized MAC, for the local MAC and every member MAC.
  wireless_mobility_macs = {
    for raw in distinct(flatten([
      for mob in values(local.wireless_mobility_raw) : concat(
        try(mob.mac_address, null) == null ? [] : [mob.mac_address],
        [for m in try(mob.group_members, []) : m.mac_address],
      )
      ])) : raw => (
      length(replace(raw, "/[^0-9A-Fa-f]/", "")) == 12
      ? join(":", regexall("[0-9a-f]{2}", lower(replace(raw, "/[^0-9A-Fa-f]/", ""))))
      : raw
    )
  }
  wireless_mobility = {
    for name, mob in local.wireless_mobility_raw : name => {
      group_name               = try(mob.group_name, null)
      mac_address              = try(local.wireless_mobility_macs[mob.mac_address], null)
      group_keepalive_interval = try(mob.group_keepalive_interval, null)
      group_keepalive_count    = try(mob.group_keepalive_count, null)
      dscp                     = try(mob.dscp, null)
      group_members = try(length(mob.group_members) == 0, true) ? null : [
        for m in mob.group_members : {
          mac_address = local.wireless_mobility_macs[m.mac_address]
          ip          = try(m.ip, null)
          # Over NETCONF an omitted nat-ip is stored as 0.0.0.0, while the CLI
          # stores the member's ip. Send ip (also for an explicit null) so both
          # paths give the same result. An explicit 0.0.0.0 means "no public
          # IP": it is the YANG default and the only nat-ip several peers may
          # share, the controller does not return it in get-config, so it is
          # sent as null to keep plans clean. It is IPv4-only; the schema only
          # accepts valid IPs and IPv4 has no other spelling of 0.0.0.0.
          public_ip            = try(coalesce(try(m.public_ip, null), m.ip) == "0.0.0.0" ? null : coalesce(try(m.public_ip, null), m.ip), null)
          group                = try(m.group, null)
          ssc_hash             = try(m.ssc_hash, null)
          data_link_encryption = try(m.data_link_encryption, null)
        }
      ]
    }
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
