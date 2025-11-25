# IPv6 Multicast Configuration Example

This example demonstrates how to configure IPv6 multicast routing with PIM RP address on Cisco IOS-XE devices.

## Configuration Overview

The example configures:
- IPv6 unicast routing enablement
- IPv6 multicast routing enablement
- IPv6 PIM RP address (2001:db8::100)
- IPv6 PIM access-list for multicast group range (e.g., FF70::/12)
- IPv6 PIM bidir mode (optional)

## CLI Commands Generated

```
ipv6 unicast-routing
ipv6 multicast-routing
ipv6 pim rp-address 2001:DB8::100 ipv6_multicast_groups
```

## Prerequisites

Before applying this configuration:

1. **IPv6 ACL Configuration**: Create a named IPv6 ACL that defines the multicast group range
   ```
   ipv6 access-list ipv6_multicast_groups
    permit ipv6 any FF70::/12
   ```

2. **Network Connectivity**: Ensure IPv6 connectivity is established

3. **Device Access**: RESTCONF or NETCONF must be enabled on the device

## Configuration File

See `ipv6_multicast.nac.yaml` for the complete configuration example.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Important Notes

### Single RP Address Limitation
- **Only one RP address is supported per device** (provider limitation)
- Multiple RP addresses require enhancement to the `iosxe_pim_ipv6` provider resource
- For multiple RP addresses, consider using CLI templates as a workaround

### IPv6 Multicast Group Ranges
- The multicast group range (e.g., FF70::/12) is defined in a named IPv6 ACL
- The `rp_address_access_list` attribute references the ACL name
- IPv6 multicast addresses must be in the FF00::/8 range

### Bidir Mode
- Bidirectional PIM mode is optional
- Set `rp_address_bidir: true` to enable bidir mode
- Default is `false` (unidirectional mode)

### VRF Support
- VRF-aware IPv6 PIM configuration is supported by the provider resource
- VRF support in this module will be added in a future release
- For VRF configurations, use the provider resource directly or CLI templates

## Supported IOS XE Versions

- **17.15.1**: Fully supported
- **17.12.1**: Fully supported

## Related Resources

- [terraform-provider-iosxe: iosxe_pim_ipv6](https://registry.terraform.io/providers/CiscoDevNet/iosxe/latest/docs/resources/pim_ipv6)
- [nac-iosxe schema documentation](../../schemas/schema.yaml)

