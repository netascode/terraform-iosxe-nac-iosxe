locals {
  iosxe            = try(local.model.iosxe, {})
  global           = try(local.iosxe.global, [])
  devices          = try(local.iosxe.devices, [])
  device_groups    = try(local.iosxe.device_groups, [])
  interface_groups = try(local.iosxe.interface_groups, [])

  all_devices = [for device in local.devices : {
    name     = device.name
    url      = try(device.url, null)
    host     = try(device.host, null)
    protocol = try(device.protocol, null)
    managed  = try(device.managed, local.defaults.iosxe.devices.managed, true)
  }]

  managed_devices = [
    for device in local.devices : device if(length(var.managed_devices) == 0 || contains(var.managed_devices, device.name)) && (length(var.managed_device_groups) == 0 || anytrue([for dg in local.device_groups : contains(try(device.device_groups, []), dg.name) && contains(var.managed_device_groups, dg.name)]) || anytrue([for dg in local.device_groups : contains(try(dg.devices, []), device.name) && contains(var.managed_device_groups, dg.name)]))
  ]

  device_variables = { for device in local.managed_devices :
    device.name => merge(concat(
      [{ GLOBAL = local.iosxe }],
      [try(local.global.variables, {})],
      [for dg in local.device_groups : try(dg.variables, {}) if contains(try(device.device_groups, []), dg.name) || contains(try(dg.devices, []), device.name)],
      [try(device.variables, {})]
    )...)
  }

  templates = { for template in try(local.iosxe.templates, []) : template.name => template }

  global_file_templates = { for device in local.managed_devices :
    device.name => compact([
      for t in try(local.global.templates, []) : templatefile(local.templates[t].file, local.device_variables[device.name]) if try(local.templates[t].type, null) == "file"
    ])
  }

  group_file_templates = { for device in local.managed_devices :
    device.name => flatten([
      for dg in local.device_groups : compact([
        for t in try(dg.templates, []) : templatefile(local.templates[t].file, merge(local.device_variables[device.name], try(dg.variables, {}))) if try(local.templates[t].type, null) == "file"
      ])
      if contains(try(device.device_groups, []), dg.name) || contains(try(dg.devices, []), device.name)
    ])
  }

  device_file_templates = { for device in local.managed_devices :
    device.name => compact([
      for t in try(device.templates, []) : templatefile(local.templates[t].file, local.device_variables[device.name]) if try(local.templates[t].type, null) == "file"
    ])
  }

  global_model_templates_raw = { for device in local.managed_devices :
    device.name => [
      for t in try(local.global.templates, []) : yamlencode(try(local.templates[t].configuration, {})) if try(local.templates[t].type, null) == "model"
    ]
  }

  global_model_templates = { for device, configs in local.global_model_templates_raw :
    device => provider::utils::yaml_merge(
      [for config in configs : templatestring(config, local.device_variables[device])]
    )
  }

  group_model_templates_raw = { for device in local.managed_devices :
    device.name => {
      for dg in local.device_groups : dg.name => [
        for t in try(dg.templates, []) : yamlencode(try(local.templates[t].configuration, {})) if try(local.templates[t].type, null) == "model"
      ]
      if contains(try(device.device_groups, []), dg.name) || contains(try(dg.devices, []), device.name)
    }
  }

  group_model_templates = { for device, groups in local.group_model_templates_raw :
    device => provider::utils::yaml_merge([
      for group_name, group_configs in groups : provider::utils::yaml_merge(
        [for config in group_configs : templatestring(config, merge(local.device_variables[device], [for dg in local.device_groups : try(dg.variables, {}) if group_name == dg.name][0]))]
      )
    ])
  }

  device_model_templates_raw = { for device in local.managed_devices :
    device.name => [
      for t in try(device.templates, []) : yamlencode(try(local.templates[t].configuration, {})) if try(local.templates[t].type, null) == "model"
    ]
  }

  device_model_templates = { for device, configs in local.device_model_templates_raw :
    device => provider::utils::yaml_merge(
      [for config in configs : templatestring(config, local.device_variables[device])]
    )
  }

  devices_raw_config = { for device in local.managed_devices :
    device.name => try(provider::utils::yaml_merge(concat(
      local.global_file_templates[device.name],
      [local.global_model_templates[device.name]],
      [yamlencode(try(local.global.configuration, {}))],
      local.group_file_templates[device.name],
      [local.group_model_templates[device.name]],
      [for dg in local.device_groups : yamlencode(try(dg.configuration, {})) if contains(try(device.device_groups, []), dg.name) || contains(try(dg.devices, []), device.name)],
      local.device_file_templates[device.name],
      [local.device_model_templates[device.name]],
      [yamlencode(try(device.configuration, {}))]
    )), "")
  }

  devices_config = { for device, config in local.devices_raw_config :
    device => yamldecode(templatestring(config, local.device_variables[device]))
  }

  interface_groups_raw_config = {
    for device in local.managed_devices : device.name => {
      for ig in local.interface_groups : ig.name => yamlencode(try(ig.configuration, {}))
    }
  }

  interface_groups_config = {
    for device in local.managed_devices : device.name => [
      for ig in local.interface_groups : {
        name          = ig.name
        configuration = yamldecode(templatestring(local.interface_groups_raw_config[device.name][ig.name], local.device_variables[device.name]))
      }
    ]
  }

  device_only_config = { for device in local.managed_devices :
    device.name => try(yamldecode(templatestring(yamlencode(try(device.configuration, {})), local.device_variables[device.name])), {})
  }

  device_only_interface_groups = { for device in local.managed_devices :
    device.name => {
      ethernets = { for ethernet in try(local.device_only_config[device.name].interfaces.ethernets, []) :
        "${try(ethernet.type, "")}${ethernet.id}" => try(ethernet.interface_groups, [])
      }
      vlans = { for vlan in try(local.device_only_config[device.name].interfaces.vlans, []) :
        tostring(vlan.id) => try(vlan.interface_groups, [])
      }
      loopbacks = { for loopback in try(local.device_only_config[device.name].interfaces.loopbacks, []) :
        tostring(loopback.id) => try(loopback.interface_groups, [])
      }
      port_channels = { for pc in try(local.device_only_config[device.name].interfaces.port_channels, []) :
        tostring(pc.id) => try(pc.interface_groups, [])
      }
      tunnels = { for tunnel in try(local.device_only_config[device.name].interfaces.tunnels, []) :
        tostring(tunnel.name) => try(tunnel.interface_groups, [])
      }
      ethernet_ranges = { for er in try(local.device_only_config[device.name].interfaces.ranges.ethernets, []) :
        "${try(er.type, "")}${er.from}-${er.to}" => try(er.interface_groups, [])
      }
      port_channel_ranges = { for pcr in try(local.device_only_config[device.name].interfaces.ranges.port_channels, []) :
        "${pcr.from}-${pcr.to}" => try(pcr.interface_groups, [])
      }
    }
  }

  global_cli_templates_raw = { for device in local.managed_devices :
    device.name => {
      for t in try(local.global.templates, []) : local.templates[t].name => {
        content = local.templates[t].content
        order   = try(local.templates[t].order, local.defaults.iosxe.templates.order)
      } if try(local.templates[t].type, null) == "cli" && try(local.templates[t].content, "") != ""
    }
  }

  global_cli_templates = { for device, templates in local.global_cli_templates_raw :
    device => { for name, template in templates : name => {
      content = templatestring(template.content, local.device_variables[device])
      order   = template.order
    } }
  }

  group_cli_templates_raw = { for device in local.managed_devices :
    device.name => {
      for dg in local.device_groups : dg.name => {
        for t in try(dg.templates, []) : "${local.templates[t].name}/${dg.name}" => {
          content = local.templates[t].content
          order   = try(local.templates[t].order, local.defaults.iosxe.templates.order)
        } if try(local.templates[t].type, null) == "cli" && try(local.templates[t].content, "") != ""
      }
      if contains(try(device.device_groups, []), dg.name) || contains(try(dg.devices, []), device.name)
    }
  }

  group_cli_templates = { for device, groups in local.group_cli_templates_raw :
    device => merge([
      for group_name, group_configs in groups : {
        for name, template in group_configs : name => {
          content = templatestring(template.content, merge(local.device_variables[device], [for dg in local.device_groups : try(dg.variables, {}) if group_name == dg.name][0]))
          order   = template.order
        }
      }
    ]...)
  }

  device_cli_templates_raw = { for device in local.managed_devices :
    device.name => {
      for t in try(device.templates, []) : local.templates[t].name => {
        content = local.templates[t].content
        order   = try(local.templates[t].order, local.defaults.iosxe.templates.order)
      } if try(local.templates[t].type, null) == "cli" && try(local.templates[t].content, "") != ""
    }
  }

  device_cli_templates = { for device, configs in local.device_cli_templates_raw :
    device => { for name, template in configs : name => {
      content = templatestring(template.content, local.device_variables[device])
      order   = template.order
    } }
  }

  all_cli_templates = { for device in local.managed_devices :
    device.name => concat(
      [for name, template in local.global_cli_templates[device.name] : { "name" = name, "content" = template.content, "order" = template.order }],
      [for name, template in local.group_cli_templates[device.name] : { "name" = name, "content" = template.content, "order" = template.order }],
      [for name, template in local.device_cli_templates[device.name] : { "name" = name, "content" = template.content, "order" = template.order }],
      try(device.cli_templates, [])
    )
  }

  iosxe_devices = {
    iosxe = {
      devices = [
        for device in try(local.managed_devices, []) : {
          name     = device.name
          url      = try(device.url, null)
          host     = try(device.host, null)
          protocol = try(device.protocol, null)
          managed  = try(device.managed, local.defaults.iosxe.devices.managed, true)
          configuration = merge(
            { for k, v in try(local.devices_config[device.name], {}) : k => v if k != "interfaces" },
            {
              interfaces = merge(
                { for k, v in try(local.devices_config[device.name].interfaces, {}) : k => v if k != "ethernets" && k != "loopbacks" && k != "vlans" && k != "port_channels" && k != "tunnels" && k != "ranges" },
                {
                  "ethernets" = concat(
                    [
                      for ethernet in try(local.devices_config[device.name].interfaces.ethernets, []) : merge(
                        yamldecode(provider::utils::yaml_merge(concat(
                          [for g in(
                            try(ethernet.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                            && contains(keys(try(local.device_only_interface_groups[device.name].ethernets, {})), "${try(ethernet.type, "")}${ethernet.id}")
                            ? local.device_only_interface_groups[device.name].ethernets["${try(ethernet.type, "")}${ethernet.id}"]
                            : try(ethernet.interface_groups, [])
                          ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                          [yamlencode(ethernet)]
                        )))
                      )
                    ],
                    flatten([
                      for ethernet_range in try(local.devices_config[device.name].interfaces.ranges.ethernets, []) : [
                        for generated_id in [for i in range(
                          tonumber(regex("[0-9]+$", tostring(ethernet_range.from))),
                          tonumber(regex("[0-9]+$", tostring(ethernet_range.to))) + 1
                          ) : format("%s%d", regex("^(.*?)[0-9]+$", tostring(ethernet_range.from))[0], i)] : merge(
                          yamldecode(provider::utils::yaml_merge(concat(
                            [for g in(
                              try(ethernet_range.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                              && contains(keys(try(local.device_only_interface_groups[device.name].ethernet_ranges, {})), "${try(ethernet_range.type, "")}${ethernet_range.from}-${ethernet_range.to}")
                              ? local.device_only_interface_groups[device.name].ethernet_ranges["${try(ethernet_range.type, "")}${ethernet_range.from}-${ethernet_range.to}"]
                              : try(ethernet_range.interface_groups, [])
                            ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                            [yamlencode({
                              type    = try(ethernet_range.type, null)
                              id      = generated_id
                              managed = try(ethernet_range.managed, null)
                            })]
                          )))
                        )
                      ]
                    ])
                  )
                },
                {
                  "vlans" = [
                    for vlan in try(local.devices_config[device.name].interfaces.vlans, []) : merge(
                      yamldecode(provider::utils::yaml_merge(concat(
                        [for g in(
                          try(vlan.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                          && contains(keys(try(local.device_only_interface_groups[device.name].vlans, {})), tostring(vlan.id))
                          ? local.device_only_interface_groups[device.name].vlans[tostring(vlan.id)]
                          : try(vlan.interface_groups, [])
                        ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                        [yamlencode(vlan)]
                      )))
                    )
                  ]
                },
                {
                  "loopbacks" = [
                    for loopback in try(local.devices_config[device.name].interfaces.loopbacks, []) : merge(
                      yamldecode(provider::utils::yaml_merge(concat(
                        [for g in(
                          try(loopback.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                          && contains(keys(try(local.device_only_interface_groups[device.name].loopbacks, {})), tostring(loopback.id))
                          ? local.device_only_interface_groups[device.name].loopbacks[tostring(loopback.id)]
                          : try(loopback.interface_groups, [])
                        ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                        [yamlencode(loopback)]
                      )))
                    )
                  ]
                },
                {
                  "port_channels" = concat(
                    [
                      for port_channel in try(local.devices_config[device.name].interfaces.port_channels, []) : merge(
                        yamldecode(provider::utils::yaml_merge(concat(
                          [for g in(
                            try(port_channel.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                            && contains(keys(try(local.device_only_interface_groups[device.name].port_channels, {})), tostring(port_channel.id))
                            ? local.device_only_interface_groups[device.name].port_channels[tostring(port_channel.id)]
                            : try(port_channel.interface_groups, [])
                          ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                          [yamlencode(port_channel)]
                        )))
                      )
                    ],
                    flatten([
                      for pc_range in try(local.devices_config[device.name].interfaces.ranges.port_channels, []) : [
                        for generated_id in range(tonumber(pc_range.from), tonumber(pc_range.to) + 1) : merge(
                          yamldecode(provider::utils::yaml_merge(concat(
                            [for g in(
                              try(pc_range.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                              && contains(keys(try(local.device_only_interface_groups[device.name].port_channel_ranges, {})), "${pc_range.from}-${pc_range.to}")
                              ? local.device_only_interface_groups[device.name].port_channel_ranges["${pc_range.from}-${pc_range.to}"]
                              : try(pc_range.interface_groups, [])
                            ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                            [yamlencode({
                              id      = generated_id
                              managed = try(pc_range.managed, null)
                            })]
                          )))
                        )
                      ]
                    ])
                  )
                },
                {
                  "tunnels" = [
                    for tunnel in try(local.devices_config[device.name].interfaces.tunnels, []) : merge(
                      yamldecode(provider::utils::yaml_merge(concat(
                        [for g in(
                          try(tunnel.interface_group_policy, try(device.interface_group_policy, "merge")) == "replace"
                          && contains(keys(try(local.device_only_interface_groups[device.name].tunnels, {})), tostring(tunnel.name))
                          ? local.device_only_interface_groups[device.name].tunnels[tostring(tunnel.name)]
                          : try(tunnel.interface_groups, [])
                        ) : try([for ig in local.interface_groups_config[device.name] : yamlencode(ig.configuration) if ig.name == g][0], "")],
                        [yamlencode(tunnel)]
                      )))
                    )
                  ]
                }
              )
            }
          )
          cli_templates = local.all_cli_templates[device.name]
        }
      ]
    }
  }
}
