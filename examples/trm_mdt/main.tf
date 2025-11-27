terraform {
  required_version = ">= 1.8.0"
  required_providers {
    iosxe = {
      source  = "CiscoDevNet/iosxe"
      version = ">= 0.10.2"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 1.1.0-beta3"
    }
  }
}

module "iosxe" {
  source = "../.."

  yaml_files = ["trm_mdt.nac.yaml"]
}

