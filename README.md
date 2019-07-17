# Wordpress AWS Demo Stack

This projects creates a demo Wordpress stack, its not meant to be production ready, but rather demo AWS and cloud technologies.

## Instructions
- Check and apply the `base` which will create base resources required for this
- Configure required or desired variables in `local.auto.tfvars`
- Run `make plan` and review the plan output
- If plan looks correct, run `make apply`
- Get default credentials with `terraform output`
- Use `make destroy` to destroy created resources

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| chamber\_key\_arn | Chamber KMS Key ARN | string | n/a | yes |
| chamber\_key\_id | Chamber KMS Key ID | string | n/a | yes |
| internal\_dns\_zone\_id | Input from ./base output | string | n/a | yes |
| private\_subnet\_ids | Input from ./base output | list | n/a | yes |
| public\_subnet\_ids | Input from ./base output | list | n/a | yes |
| vpc\_id | Input from ./base output | string | n/a | yes |
| image\_id | AMI ID to use | string | `"ami-0c15064daa40f95b5"` | no |
| instance\_type | The instance type to use, e.g t2.small | string | `"t3.small"` | no |
| name | Name of this wordpress stack | string | `"demo"` | no |
| ssh\_key\_name | The aws ssh key name. | string | `""` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | map | `<map>` | no |
| wordpress\_admin\_email | Wordpress Admin email | string | `"null@null.com"` | no |
| wordpress\_site\_title | Wordpress Site default Title | string | `"Demo Wordpress Site"` | no |
| wordpress\_version | Wordpress Docker image version | string | `"5.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_dns\_name |  |
| lb\_dns\_name |  |
| wordpress\_password | Wordpress password |
| wordpress\_user | Wordpress username |

## Notes
The wordpress ASG is currently in the public subnet with mapped IPs, the only reason for this is to avoid the aditional bastion host for this demo.

## Tech Stack
- Terraform
- Cloud-Init
- Chamber
- AWS
  - EC2 ASG
  - S3
  - RDS - MySQL
  - ALB
  - VPC
  - Subnets
  - Security Groups
  - SSM Parameter Store
- Wordpress
- Docker

## References
- https://d1.awsstatic.com/whitepapers/wordpress-best-practices-on-aws.pdf
- https://cloudonaut.io/wordpress-on-aws-you-are-holding-it-wrong/
- https://cloudonaut.io/wordpress-on-aws-smooth-and-pain-free/
- Public modules ideas
  - https://github.com/cloudposse
  - https://github.com/terraform-aws-modules
