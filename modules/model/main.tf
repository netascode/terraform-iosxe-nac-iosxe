locals {
  iosxe                   = try(local.model.iosxe, {})
  global                  = try(local.iosxe.global, [])
  devices                 = try(local.iosxe.devices, [])
  device_groups           = try(local.iosxe.device_groups, [])
  configuration_templates = try(local.iosxe.configuration_templates, [])
  interface_groups        = try(local.iosxe.interface_groups, [])

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

  iosxe_devices = {
    iosxe = {
      devices = [
        for device in try(local.devices, []) : {
          name          = device.name
          url           = device.url
          managed       = try(device.managed, local.defaults.iosxe.devices.managed, true)
          configuration = try(local.device_config[device.name], {})
        }
      ]
    }
  }

  interfaces_ethernets_group = flatten([
    for device in local.devices : [
      for int in try(local.device_config[device.name].interfaces.ethernets, []) : {
        key           = format("%s/%s", device.name, int.id)
        configuration = yamldecode(provider::utils::yaml_merge([for g in try(int.interface_groups, []) : try([for ig in local.interface_groups : yamlencode(ig.configuration) if ig.name == g][0], "")]))
      }
    ]
  ])

  interfaces_ethernets_group_config = {
    for int in local.interfaces_ethernets_group : int.key => int.configuration
  }
}

