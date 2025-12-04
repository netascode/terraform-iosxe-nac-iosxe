<!-- BEGIN_TF_DOCS -->
# IOS-XE VRF EVPN-Mcast Configuration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `vrf_evpn_mcast.nac.yaml`

```yaml
iosxe:
  devices:
    - name: Switch1
      host: 1.2.3.4
      configuration:
        system:
          hostname: Switch1
          ip_routing: true
          ip_multicast_routing: true
        vrfs:
          - name: TRM_EVPN_MCAST_VRF
            description: "TRM VRF with EVPN-Mcast Configuration"
            route_distinguisher: "65000:100"
            address_family_ipv4:
              enable: true
              evpn_mcast:
                mdt_default_address: 225.25.25.25
                anycast: 61.61.1.11
                data_address: 225.25.25.26
                data_mask_bits: 0.0.0.255
```

#### `main.tf`

```hcl
module "iosxe" {
  source  = "netascode/nac-iosxe/iosxe"
  version = ">= 0.1.0"

  yaml_files = ["vrf_evpn_mcast.nac.yaml"]
}
```
<!-- END_TF_DOCS -->