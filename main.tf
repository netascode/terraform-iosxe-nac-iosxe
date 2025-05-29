locals {
  iosxe         = try(local.model.iosxe, {})
  global        = try(local.iosxe.global, [])
  devices       = try(local.iosxe.devices, [])
  device_groups = try(local.iosxe.device_groups, [])
  //interface_groups        = try(local.iosxe.interface_groups, [])
  configuration_templates = try(local.iosxe.configuration_templates, [])

  device_group_config_template_variables = { for dg in local.device_groups :
    dg.name => merge(concat(
      [try(local.global.variables, {})],
      [try(dg.variables, {})],
    )...)
  }

  device_group_config_template_raw_config = { for dg in local.device_groups :
    dg.name => provider::utils::yaml_merge(
      [for t in try(dg.configuration_templates, []) : yamlencode(try([for ct in local.configuration_templates : try(ct.configuration, {}) if ct.name == t][0], {}))]
    )
  }

  device_group_config_template_config = { for dg, config in local.device_group_config_template_raw_config :
    dg => templatestring(config, local.device_group_config_template_variables[dg])
  }

  raw_device_config = { for device in local.devices :
    device.name => try(provider::utils::yaml_merge(concat(
      [yamlencode(try(local.global.configuration, {}))],
      [for dg in local.device_groups : yamlencode(try(dg.configuration, {})) if contains(try(device.device_groups, []), dg.name)],
      [for dg in local.device_groups : yamlencode(try(dg.configuration, {})) if contains(try(dg.devices, []), device.name)],
      [for dg in local.device_groups : local.device_group_config_template_config[dg.name] if contains(try(device.device_groups, []), dg.name)],
      [for dg in local.device_groups : local.device_group_config_template_config[dg.name] if contains(try(dg.devices, []), device.name)],
      [yamlencode(try(device.configuration, {}))]
    )), "")
  }

  device_variables = { for device in local.devices :
    device.name => merge(concat(
      [try(local.global.variables, {})],
      [for dg in local.device_groups : try(dg.variables, {}) if contains(try(device.device_groups, []), dg.name)],
      [for dg in local.device_groups : try(dg.variables, {}) if contains(try(dg.devices, []), device.name)],
      [try(device.variables, {})]
    )...)
  }

  device_config = { for device, config in local.raw_device_config :
    device => yamldecode(templatestring(config, local.device_variables[device]))
  }

  provider_devices = [for device in local.devices : {
    name    = device.name
    url     = device.url
    managed = try(device.managed, local.defaults.iosxe.devices.managed, true)
  }]
}

provider "iosxe" {
  devices = local.provider_devices
}

resource "iosxe_save_config" "save_config" {
  for_each = { for device in local.devices : device.name => device if var.save_config }
  device   = each.key
  depends_on = [
    iosxe_aaa.aaa,
    iosxe_aaa_accounting.aaa_accounting,
    iosxe_aaa_authentication.aaa_authentication,
    iosxe_aaa_authorization.aaa_authorization,
    iosxe_access_list_standard.access_list_standard,
    iosxe_access_list_extended.access_list_extended,
    iosxe_as_path_access_list.as_path_access_list,
    iosxe_arp.arp,
    iosxe_banner.banner,
    iosxe_bfd.bfd,
    iosxe_ospf_vrf.ospf,
    iosxe_ospf.ospf,
    iosxe_vrf.vrfs,
    iosxe_interface_ospf.interface,
    iosxe_interface.ospfv3.interface
  ]
}
