terraform {
  required_version = ">= 1.9.0"

  required_providers {
    iosxe = {
      source  = "CiscoDevNet/iosxe"
      version = "~> 0.18.0"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 2.0.2, < 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0, < 3.0.0"
    }
  }
}
