<!-- BEGIN_TF_DOCS -->
# IOS-XE System Configuration Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

#### `system.nac.yaml`

```yaml
iosxe:
  devices:
    - name: Switch1
      host: 1.2.3.4
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
<!-- END_TF_DOCS -->