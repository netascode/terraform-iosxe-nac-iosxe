module "iosxe" {
  source = "../../"

  yaml_files = ["evpn_profile.nac.yaml"]

  write_default_values_file = "./defaults.yaml"
}
