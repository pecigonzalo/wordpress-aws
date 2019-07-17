PWD ?= $(shell pwd)
PLAN_PATH=.terraform/terraform.plan
INIT_FILES=.terraform
OUTPUT_FILE=.terraform/output.tfvars.json
TF_FILES=$(wildcard *.tf) $(wildcard *.tfvars)

default: init get plan

clean-output:
	rm -f $(OUTPUT_FILE)

clean-plan:
	rm -f $(PLAN_PATH)

clean:
	rm -f $(PLAN_PATH)
	rm -rf .terraform

$(INIT_FILES):
	terraform init

init: $(INIT_FILES)

$(TF_FILES):
	terraform get

get: $(TF_FILES)

$(PLAN_PATH):
	terraform plan -var-file=base/.terraform/output.tfvars.json -out=$(PLAN_PATH)

plan: init get $(PLAN_PATH)

replan: clean-plan plan

$(OUTPUT_FILE):
	terraform apply $(PLAN_PATH)

apply: plan $(OUTPUT_FILE)

reapply: clean-output apply

destroy:
	terraform destroy -var-file=base/.terraform/output.tfvars.json
	$(MAKE) clean

.PHONY: default clean-output clean-plan clean init get plan replan apply reapply destroy
