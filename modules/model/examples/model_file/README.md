<!-- BEGIN_TF_DOCS -->
# Terraform *Network as Code* IOS-XE Model Module Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "model" {
  source  = "netascode/nac-iosxe/iosxe//modules/model"
  version = ">= 0.1.0"

  yaml_directories = ["data/"]
  write_model_file = "model.yaml"
}
```
<!-- END_TF_DOCS -->