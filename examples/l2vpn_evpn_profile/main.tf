module "iosxe" {
  source = "../../"

  yaml_files = ["l2vpn_evpn_profile.nac.yaml"]

  write_default_values_file = "./defaults.yaml"
}
