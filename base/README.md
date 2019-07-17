# Base Infrastructure

In many environments you would reuse the existing VPC and subnets. If you dont have one, this will create a 2-tier VPC and subnets config.


## Usage
**WARNING: This does not setup remote-state, as its used only as a demo**

- Run `make plan` and review the plan output
- If plan looks correct, run `make apply`

A file `.terraform/output.tfvars.json` will be stored with the output, it can be used as `terraform apply -var-file=.terraform/output.tfvars.json` to pass the output as input to other terraform code.
In case you have `remote-state` enabled, you can directly reference the remote state.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zones | Availability Zones where subnets will be created | list | `<list>` | no |
| cidr\_block | CIDR for the VPC | string | `"10.128.0.0/16"` | no |
| internal\_domain\_name | Internal DNS Name | string | `"local"` | no |
| tags | Map of tags for resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| chamber\_key\_arn | Key ARN |
| chamber\_key\_id | KMS key ID |
| igw\_id | Internet Gateway ID |
| internal\_dns\_zone\_id | Internal DNS Zone ID |
| nat\_gateway\_ids | NAT Gateways IDs |
| private\_route\_table\_ids | Private route tables IDs |
| private\_subnet\_cidrs | Private subnets CIDRs |
| private\_subnet\_ids | The private subnets IDs |
| public\_route\_table\_ids | Public route tables IDs |
| public\_subnet\_cidrs | Public subnets CIDRs |
| public\_subnet\_ids | The public subnets IDs |
| vpc\_default\_network\_acl\_id | Default Network ACL ID |
| vpc\_id | VPC ID |
| vpc\_main\_route\_rable\_id | Main VPC Route Table ID |
