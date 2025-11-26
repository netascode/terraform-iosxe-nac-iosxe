# TRM VRF MDT Configuration Example

This example demonstrates how to configure TRM (Tenant Routed Multicast) VRF with Multicast Distribution Tree (MDT) support using the Terraform IOS-XE NaC module.

## Overview

The example configures three VRFs with different MDT configurations:

1. **TRM_VRF_VXLAN** - VxLAN auto-discovery with inter-AS support
2. **TRM_VRF_INTERWORKING** - VxLAN-PIM interworking
3. **TRM_VRF_ADVANCED** - Multiple MDT data groups with access lists

## Prerequisites

- IOS-XE device running version 17.12.1 or later
- IP multicast routing enabled globally
- BGP configured for MVPN (if using overlay use-bgp)
- Access lists defined (if using data group access lists)

## MDT Features Demonstrated

### Default MDT Group
```yaml
mdt:
  default_address: 239.1.1.1
```
Configures the default multicast group for the MDT backbone.

### Auto-Discovery VxLAN
```yaml
mdt:
  auto_discovery_vxlan: true
  auto_discovery_vxlan_inter_as: true
```
Enables BGP auto-discovery for VxLAN with optional inter-AS support.

### Auto-Discovery Interworking
```yaml
mdt:
  auto_discovery_interworking_vxlan_pim: true
  auto_discovery_interworking_vxlan_pim_inter_as: true
```
Enables BGP auto-discovery for VxLAN-PIM interworking.

**Note:** VxLAN and interworking auto-discovery are mutually exclusive. Configure only one per VRF.

### Overlay Use-BGP
```yaml
mdt:
  overlay_use_bgp: true
  overlay_use_bgp_spt_only: true
```
Enables BGP for MDT overlay signaling with optional SPT-only mode.

### Data MDT Groups
```yaml
mdt:
  data_threshold: 50
  data_multicast:
    - address: 239.1.2.0
      wildcard: 0.0.0.255
      access_list: MDT_DATA_ACL
```
Configures data MDT multicast groups with threshold and optional access lists.

## Usage

1. Update the `host` value in `trm_mdt.nac.yaml` with your device IP
2. Ensure device credentials are configured (environment variables or provider config)
3. Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Generated CLI Configuration

The module will generate the following CLI configuration:

```
ip vrf definition TRM_VRF_VXLAN
 description TRM VRF with VxLAN MDT Auto-Discovery
 rd 65000:100
 vpn id 65000:100
 route-target export 65000:100
 route-target import 65000:100
 address-family ipv4
  mdt default 239.1.1.1
  mdt auto-discovery vxlan inter-as
  mdt overlay use-bgp spt-only
  mdt data 239.1.2.0 0.0.0.255 list MDT_DATA_ACL
  mdt data threshold 50
 exit-address-family
!
ip vrf definition TRM_VRF_INTERWORKING
 description TRM VRF with VxLAN-PIM Interworking
 rd 65000:200
 vpn id 65000:200
 route-target export 65000:200
 route-target import 65000:200
 address-family ipv4
  mdt default 239.2.1.1
  mdt auto-discovery interworking vxlan-pim inter-as
  mdt overlay use-bgp
  mdt data 239.2.2.0 0.0.0.255
  mdt data threshold 75
 exit-address-family
!
ip vrf definition TRM_VRF_ADVANCED
 description Advanced TRM VRF with Multiple MDT Data Groups
 rd 65000:300
 vpn id 65000:300
 route-target export 65000:300
 route-target import 65000:300
 address-family ipv4
  mdt default 239.10.10.1
  mdt auto-discovery vxlan
  mdt overlay use-bgp
  mdt data 239.10.20.0 0.0.0.255 list ACL_MDT_1
  mdt data 239.10.30.0 0.0.1.255 list ACL_MDT_2
  mdt data 239.10.40.0 0.0.0.127 list ACL_MDT_3
  mdt data threshold 100
 exit-address-family
```

## Important Notes

1. **Mutual Exclusivity**: VxLAN and interworking auto-discovery are mutually exclusive. Only configure one per VRF.

2. **Multicast Addresses**: Ensure multicast addresses are in the valid range (224.0.0.0 to 239.255.255.255).

3. **Threshold Units**: The threshold value is in Kbps (1-4,294,967).

4. **Access Lists**: If using access lists with data groups, ensure they are defined before applying VRF configuration.

5. **BGP Requirement**: The `overlay_use_bgp` option requires BGP to be configured for MVPN.

## Related Documentation

- [VRF Resource Documentation](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/vrf)
- [IOS-XE Multicast Configuration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipmulti/configuration/xe-17/imc-xe-17-book.html)
- [MVPN Configuration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipmulti_vpn/configuration/xe-17/imc-vpn-xe-17-book.html)

