<!-- BEGIN_TF_DOCS -->
# IOS-XE L2VPN EVPN Profile Configuration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `evpn_profile.nac.yaml`

```yaml
iosxe:
  devices:
    - name: Switch1
      host: 10.1.1.1
      configuration:
        evpn_profile:
          profiles:
            - name: DC_PROFILE_1
              evi_base: 1000
              l2vni_base: 10000
            - name: CAMPUS_PROFILE
              evi_base: 2000
              l2vni_base: 20000
    - name: Switch2
      host: 10.1.1.2
      configuration:
        evpn_profile:
          profiles:
            - name: DC_PROFILE_1
              evi_base: 1000
              l2vni_base: 10000
```

#### `main.tf`

```hcl
module "iosxe" {
  source = "../../"

  yaml_files = ["evpn_profile.nac.yaml"]

  write_default_values_file = "./defaults.yaml"
}
```
<!-- END_TF_DOCS -->