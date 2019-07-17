# Wordpress AWS Demo Stack

This projects creates a demo Wordpress stack, its not meant to be production ready, but rather demo AWS and cloud technologies.

## Instructions
- Check and apply the `base` which will create base resources required for this
- Run `make plan` and review the plan output
- If plan looks correct, run `make apply`

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
- Public modules ideas
  - https://github.com/cloudposse
  - https://github.com/terraform-aws-modules
