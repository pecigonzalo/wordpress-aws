# Base Infrastructure

In many environments you would reuse the existing VPC and subnets. If you dont have one, this will create a 2-tier VPC and subnets config.


## Usage
**WARNING: This does not setup remote-state, as its used only as a demo**

1. Run `make plan` and review the plan output
2. If plan looks correct, run `make apply`

A file `.terraform/output.tfvars.json` will be stored with the output, it can be used as `terraform apply -var-file=.terraform/output.tfvars.json` to pass the output as input to other terraform code.
In case you have `remote-state` enabled, you can directly reference the remote state.
