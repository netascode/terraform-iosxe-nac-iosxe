locals {
  service_template_name = flatten([
    for device in local.devices : [
      for service_template in try(local.device_config[device.name].service_templates, []) : {
        key    = format("%s/%s", device.name, service_template.name)
        device = device.name

        name                       = service_template.name
        inactivity_timer           = try(service_template.inactivity_timer, local.defaults.iosxe.configuration.service_template.name.inactivity_timer, null)
        inactivity_timer_probe     = try(service_template.inactivity_timer_probe, local.defaults.iosxe.configuration.service_template.name.inactivity_timer_probe, null)
        vlan                       = try(service_template.vlan, local.defaults.iosxe.configuration.service_template.name.vlan, null)
        voice_vlan                 = try(service_template.voice_vlan, local.defaults.iosxe.configuration.service_template.name.voice_vlan, null)
        linksec_policy             = try(service_template.linksec_policy, local.defaults.iosxe.configuration.service_template.name.linksec_policy, null)
        sgt                        = try(service_template.sgt, local.defaults.iosxe.configuration.service_template.name.sgt, null)
        absolute_timer             = try(service_template.absolute_timer, local.defaults.iosxe.configuration.service_template.name.absolute_timer, null)
        description                = try(service_template.description, local.defaults.iosxe.configuration.service_template.name.description, null)
        tunnel_capwap_name         = try(service_template.tunnel_capwap_name, local.defaults.iosxe.configuration.service_template.name.tunnel_capwap_name, null)
        vnid                       = try(service_template.vnid, local.defaults.iosxe.configuration.service_template.name.vnid, null)
        redirect_url               = try(service_template.redirect_url, local.defaults.iosxe.configuration.service_template.name.redirect_url, null)
        redirect_url_match_acl     = try(service_template.redirect_url_match_acl, local.defaults.iosxe.configuration.service_template.name.redirect_url_match_acl, null)
        dns_acl_preauth            = try(service_template.dns_acl_preauth, local.defaults.iosxe.configuration.service_template.name.dns_acl_preauth, null)
        redirect_append_client_mac = try(service_template.redirect_append_client_mac, local.defaults.iosxe.configuration.service_template.name.redirect_append_client_mac, null)
        redirect_append_switch_mac = try(service_template.redirect_append_switch_mac, local.defaults.iosxe.configuration.service_template.name.redirect_append_switch_mac, null)
        redirect_url_match_action  = try(service_template.redirect_url_match_action, local.defaults.iosxe.configuration.service_template.name.redirect_url_match_action, null)
        service_policy_qos_input   = try(service_template.service_policy_qos_input, local.defaults.iosxe.configuration.service_template.name.service_policy_qos_input, null)
        service_policy_qos_output  = try(service_template.service_policy_qos_output, local.defaults.iosxe.configuration.service_template.name.service_policy_qos_output, null)

        # Lists
        access_groups = [for group_name in try(service_template.access_groups, []) : {
          name = group_name
          }
        ]

        interface_templates = [for template_name in try(service_template.interface_templates, []) : {
          name = template_name
          }
        ]

        tags = [for tag_name in try(service_template.tags, []) : {
          name = tag_name
          }
        ]

      }
    ]
  ])
}

resource "iosxe_service_template" "service_templates" {
  for_each = { for e in local.service_template_name : e.key => e }
  device   = each.value.device

  name                       = each.value.name
  inactivity_timer           = each.value.inactivity_timer
  inactivity_timer_probe     = each.value.inactivity_timer_probe
  vlan                       = each.value.vlan
  voice_vlan                 = each.value.voice_vlan
  linksec_policy             = each.value.linksec_policy
  sgt                        = each.value.sgt
  absolute_timer             = each.value.absolute_timer
  description                = each.value.description
  tunnel_capwap_name         = each.value.tunnel_capwap_name
  vnid                       = each.value.vnid
  redirect_url               = each.value.redirect_url
  redirect_url_match_acl     = each.value.redirect_url_match_acl
  dns_acl_preauth            = each.value.dns_acl_preauth
  redirect_append_client_mac = each.value.redirect_append_client_mac
  redirect_append_switch_mac = each.value.redirect_append_switch_mac
  redirect_url_match_action  = each.value.redirect_url_match_action
  service_policy_qos_input   = each.value.service_policy_qos_input
  service_policy_qos_output  = each.value.service_policy_qos_output

  # Lists
  access_groups       = each.value.access_groups
  interface_templates = each.value.interface_templates
  tags                = each.value.tags
}
