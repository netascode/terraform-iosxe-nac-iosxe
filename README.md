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
| <a name="requirement_iosxe"></a> [iosxe](#requirement\_iosxe) | >= 0.5.10 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 1.0.1 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_save_config"></a> [save\_config](#input\_save\_config) | Write changes to startup-config on all devices. | `bool` | `false` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_write_model_file"></a> [write\_model\_file](#input\_write\_model\_file) | Write the full model including all resolved templates to a single YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
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
| [iosxe_clock.clock](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/clock) | resource |
| [iosxe_community_list_expanded.community_list_expanded](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/community_list_expanded) | resource |
| [iosxe_community_list_standard.community_list_standard](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/community_list_standard) | resource |
| [iosxe_crypto_ikev2.crypto_ikev2](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ikev2) | resource |
| [iosxe_crypto_ikev2_keyring.crypto_ikev2_keyring](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ikev2_keyring) | resource |
| [iosxe_crypto_ikev2_policy.crypto_ikev2_policy](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ikev2_policy) | resource |
| [iosxe_crypto_ikev2_profile.crypto_ikev2_profile](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ikev2_profile) | resource |
| [iosxe_crypto_ikev2_proposal.crypto_ikev2_proposal](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ikev2_proposal) | resource |
| [iosxe_crypto_ipsec_profile.crypto_ipsec_profile](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ipsec_profile) | resource |
| [iosxe_crypto_ipsec_transform_set.crypto_ipsec_transform_set](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/crypto_ipsec_transform_set) | resource |
| [iosxe_dhcp.dhcp](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/dhcp) | resource |
| [iosxe_dot1x.dot1x](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/dot1x) | resource |
| [iosxe_errdisable.errdisable](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/errdisable) | resource |
| [iosxe_flow_exporter.flow_exporter](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/flow_exporter) | resource |
| [iosxe_flow_monitor.flow_monitors](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/flow_monitor) | resource |
| [iosxe_flow_record.flow_records](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/flow_record) | resource |
| [iosxe_interface_ethernet.ethernet](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ethernet) | resource |
| [iosxe_interface_loopback.loopback](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_loopback) | resource |
| [iosxe_interface_mpls.ethernet_mpls](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_mpls) | resource |
| [iosxe_interface_mpls.loopback_mpls](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_mpls) | resource |
| [iosxe_interface_mpls.vlan_mpls](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_mpls) | resource |
| [iosxe_interface_nve.nves](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_nve) | resource |
| [iosxe_interface_ospf.ethernet_ospf](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ospf) | resource |
| [iosxe_interface_ospf.loopback_ospf](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ospf) | resource |
| [iosxe_interface_ospf.vlan_ospf](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ospf) | resource |
| [iosxe_interface_ospfv3.ethernet_ospfv3](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ospfv3) | resource |
| [iosxe_interface_ospfv3.loopback_ospfv3](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ospfv3) | resource |
| [iosxe_interface_ospfv3.vlan_ospfv3](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_ospfv3) | resource |
| [iosxe_interface_pim.ethernet_pim](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_pim) | resource |
| [iosxe_interface_pim.loopback_pim](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_pim) | resource |
| [iosxe_interface_pim.vlan_pim](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_pim) | resource |
| [iosxe_interface_switchport.ethernet_switchport](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_switchport) | resource |
| [iosxe_interface_vlan.interface_vlan](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/interface_vlan) | resource |
| [iosxe_line.line](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/line) | resource |
| [iosxe_logging.logging](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/logging) | resource |
| [iosxe_logging_ipv4_host_transport.logging_ipv4_host_transport](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/logging_ipv4_host_transport) | resource |
| [iosxe_logging_ipv4_host_vrf_transport.logging_ipv4_host_vrf_transport](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/logging_ipv4_host_vrf_transport) | resource |
| [iosxe_logging_ipv6_host_transport.logging_ipv6_host_transport](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/logging_ipv6_host_transport) | resource |
| [iosxe_logging_ipv6_host_vrf_transport.logging_ipv6_host_vrf_transport](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/logging_ipv6_host_vrf_transport) | resource |
| [iosxe_msdp.msdp](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/msdp) | resource |
| [iosxe_msdp_vrf.msdp_vrf](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/msdp_vrf) | resource |
| [iosxe_pim.pim](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/pim) | resource |
| [iosxe_prefix_list.prefix_list](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/prefix_list) | resource |
| [iosxe_radius.radius](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/radius) | resource |
| [iosxe_radius_server.radius_server](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/radius_server) | resource |
| [iosxe_route_map.route_map](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/route_map) | resource |
| [iosxe_save_config.save_config](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/save_config) | resource |
| [iosxe_service.service](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/service) | resource |
| [iosxe_service_template.service_templates](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/service_template) | resource |
| [iosxe_snmp_server.snmp_server](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/snmp_server) | resource |
| [iosxe_snmp_server_group.snmp_server_group](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/snmp_server_group) | resource |
| [iosxe_snmp_server_user.snmp_server_user](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/snmp_server_user) | resource |
| [iosxe_static_route.static_routes](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/static_route) | resource |
| [iosxe_system.system](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/system) | resource |
| [iosxe_tacacs_server.tacacs_server](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/tacacs_server) | resource |
| [iosxe_template.template](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/template) | resource |
| [iosxe_udld.udld](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/udld) | resource |
| [iosxe_vtp.vtp](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/vtp) | resource |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_model"></a> [model](#module\_model) | ./modules/model | n/a |
<!-- END_TF_DOCS -->