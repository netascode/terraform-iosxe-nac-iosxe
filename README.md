<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco IOS-XE Module

A Terraform module to configure Cisco IOS-XE devices.

## Usage

This module supports an inventory driven approach, where a complete IOS-XE configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

## Examples

Configuring an IOS-XE system configuration using YAML:

#### `system.nac.yaml`

```yaml
iosxe:
  devices:
    - name: Switch1
      url: https://1.2.3.4
      configuration:
        system:
          hostname: Switch1
          mtu: 9198
```

#### `main.tf`

```hcl
module "iosxe" {
  source  = "netascode/nac-iosxe/iosxe"
  version = ">= 0.1.0"

  yaml_files = ["system.nac.yaml"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_iosxe"></a> [iosxe](#requirement\_iosxe) | >= 0.5.9 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.2.6 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_save_config"></a> [save\_config](#input\_save\_config) | Write changes to startup-config on all devices. | `bool` | `false` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | `[]` | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
## Resources

| Name | Type |
|------|------|
| [iosxe_aaa.aaa](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/aaa) | resource |
| [iosxe_aaa_accounting.aaa_accounting](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/aaa_accounting) | resource |
| [iosxe_aaa_authentication.aaa_authentication](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/aaa_authentication) | resource |
| [iosxe_aaa_authorization.aaa_authorization](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/aaa_authorization) | resource |
| [iosxe_access_list_extended.access_list_extended](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/access_list_extended) | resource |
| [iosxe_access_list_standard.access_list_standard](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/access_list_standard) | resource |
| [iosxe_arp.arp](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/arp) | resource |
| [iosxe_as_path_access_list.as_path_access_list](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/as_path_access_list) | resource |
| [iosxe_banner.banner](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/banner) | resource |
| [iosxe_bfd.bfd](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bfd) | resource |
| [iosxe_bfd_template_multi_hop.bfd_template_multi_hop](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bfd_template_multi_hop) | resource |
| [iosxe_bfd_template_single_hop.bfd_template_single_hop](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bfd_template_single_hop) | resource |
| [iosxe_bgp.bgp](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp) | resource |
| [iosxe_bgp_address_family_ipv4.bgp_address_family_ipv4](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_address_family_ipv4) | resource |
| [iosxe_bgp_address_family_ipv4_vrf.bgp_address_family_ipv4_vrf](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_address_family_ipv4_vrf) | resource |
| [iosxe_bgp_address_family_ipv6.bgp_address_family_ipv6](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_address_family_ipv6) | resource |
| [iosxe_bgp_address_family_ipv6_vrf.bgp_address_family_ipv6_vrf](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_address_family_ipv6_vrf) | resource |
| [iosxe_bgp_address_family_l2vpn.bgp_address_family_l2vpn](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_address_family_l2vpn) | resource |
| [iosxe_bgp_ipv4_unicast_neighbor.bgp_ipv4_unicast_neighbor](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_ipv4_unicast_neighbor) | resource |
| [iosxe_bgp_ipv4_unicast_vrf_neighbor.bgp_ipv4_unicast_vrf_neighbor](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_ipv4_unicast_vrf_neighbor) | resource |
| [iosxe_bgp_ipv6_unicast_neighbor.bgp_ipv6_unicast_neighbor](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_ipv6_unicast_neighbor) | resource |
| [iosxe_bgp_l2vpn_evpn_neighbor.bgp_l2vpn_evpn_neighbor](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_l2vpn_evpn_neighbor) | resource |
| [iosxe_bgp_neighbor.bgp_neighbor](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/bgp_neighbor) | resource |
| [iosxe_cdp.cdp](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/cdp) | resource |
| [iosxe_class_map.class_map](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/class_map) | resource |
| [iosxe_community_list_expanded.community_list_expanded](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/community_list_expanded) | resource |
| [iosxe_community_list_standard.community_list_standard](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/community_list_standard) | resource |
| [iosxe_errdisable.errdisable](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/errdisable) | resource |
| [iosxe_route_map.route_map](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/route_map) | resource |
| [iosxe_save_config.save_config](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/save_config) | resource |
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [terraform_data.validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
## Modules

No modules.
<!-- END_TF_DOCS -->