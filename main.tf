module "model" {
  source = "./modules/model"

  yaml_directories          = var.yaml_directories
  yaml_files                = var.yaml_files
  model                     = var.model
  managed_device_groups     = var.managed_device_groups
  managed_devices           = var.managed_devices
  write_model_file          = var.write_model_file
  write_default_values_file = var.write_default_values_file
}

locals {
  model    = module.model.model
  defaults = module.model.default_values
  iosxe    = try(local.model.iosxe, {})
  devices  = try(local.iosxe.devices, [])

  device_config = { for device in try(local.iosxe.devices, []) :
    device.name => try(device.configuration, {})
  }

  provider_devices = [for device in try(local.iosxe.devices, []) : {
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
    iosxe_vrf.vrfs
  ]
}
