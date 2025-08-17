terraform {
  required_version = ">= 1.8.0"

  required_providers {
    iosxe = {
      source  = "CiscoDevNet/iosxe"
      version = "= 0.7.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 1.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }
  }
}
