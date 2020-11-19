# Create new workspace

```
$ terraform workspace new [name]
```

# Build infra as code

```
$ terraform init
$ terraform workspace select [dev]
$ terraform apply -var-file dev.tfvars -auto-approve [-lock=false]
```

# Destroy infra as code

```
$ terraform destroy -var-file dev.tfvars -auto-approve [-lock=false]
```
