<!-- BEGIN_TF_DOCS -->
# IPv6 PIM Configuration Example

This example demonstrates VRF-aware IPv6 PIM configuration for TRM (Tenant Routed Multicast) deployments.

## Features

- Global IPv6 PIM RP configuration
- VRF-aware IPv6 PIM with isolated multicast domains
- Interface-level IPv6 PIM on Loopbacks and VLANs
- Multiple VRFs with independent RP addresses
- Different multicast group ranges per VRF

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

## Configuration

#### `ipv6_pim.nac.yaml`

```yaml
---
iosxe:
  devices:
    - name: Router1
      host: 10.1.1.1
      configuration:
        system:
          hostname: Router1
          ipv6_unicast_routing: true
        
        # VRF Configuration
        vrfs:
          - name: BLUE
            address_family_ipv6:
              enable: true
          - name: GREEN
            address_family_ipv6:
              enable: true
        
        # Global and VRF-aware IPv6 PIM Configuration
        ipv6_pim:
          # Global IPv6 PIM RP
          rp_address: 2001:db8::100
          rp_address_access_list: ff70::/12
          rp_address_bidir: false
          
          # Per-VRF IPv6 PIM RP Configuration
          vrfs:
            - vrf: BLUE
              rp_address: 2001:db8:1::100
              rp_address_access_list: ff71::/12
              rp_address_bidir: false
            
            - vrf: GREEN
              rp_address: 2001:db8:2::100
              rp_address_access_list: ff72::/12
              rp_address_bidir: false
        
        # Interface Configuration
        interfaces:
          loopbacks:
            # Global RP Loopback
            - id: 100
              description: "IPv6 PIM RP - Global"
              ipv6:
                enable: true
                addresses:
                  - prefix: 2001:db8::100/128
                pim:
                  pim: true
                  dr_priority: 100
            
            # VRF BLUE RP Loopback
            - id: 101
              description: "IPv6 PIM RP - VRF BLUE"
              vrf_forwarding: BLUE
              ipv6:
                enable: true
                addresses:
                  - prefix: 2001:db8:1::100/128
                pim:
                  pim: true
                  dr_priority: 100
            
            # VRF GREEN RP Loopback
            - id: 102
              description: "IPv6 PIM RP - VRF GREEN"
              vrf_forwarding: GREEN
              ipv6:
                enable: true
                addresses:
                  - prefix: 2001:db8:2::100/128
                pim:
                  pim: true
                  dr_priority: 100
          
          vlans:
            # Global VLAN with IPv6 PIM
            - id: 10
              description: "IPv6 Multicast VLAN - Global"
              ipv6:
                enable: true
                addresses:
                  - prefix: 2001:db8:10::1/64
                pim:
                  pim: true
                  bfd: false
                  bsr_border: false
                  dr_priority: 10
            
            # VRF BLUE VLAN with IPv6 PIM
            - id: 20
              description: "IPv6 Multicast VLAN - VRF BLUE"
              vrf_forwarding: BLUE
              ipv6:
                enable: true
                addresses:
                  - prefix: 2001:db8:20::1/64
                pim:
                  pim: true
                  dr_priority: 20
            
            # VRF GREEN VLAN with IPv6 PIM
            - id: 30
              description: "IPv6 Multicast VLAN - VRF GREEN"
              vrf_forwarding: GREEN
              ipv6:
                enable: true
                addresses:
                  - prefix: 2001:db8:30::1/64
                pim:
                  pim: true
                  dr_priority: 30
```

#### `main.tf`

```hcl
module "iosxe" {
  source  = "netascode/nac-iosxe/iosxe"
  version = ">= 0.1.0"

  yaml_files = ["ipv6_pim.nac.yaml"]
}

```

## Scenario

This configuration demonstrates a complete TRM deployment with:
- 2 VRFs (BLUE, GREEN) with isolated multicast domains
- Global RP: 2001:db8::100 with group range ff70::/12
- VRF BLUE RP: 2001:db8:1::100 with group range ff71::/12
- VRF GREEN RP: 2001:db8:2::100 with group range ff72::/12
- 3 RP Loopbacks with high DR priority
- 3 Multicast VLANs with per-VRF isolation
<!-- END_TF_DOCS -->