variable "name" {
  description = "Name of this wordpress stack"
  default     = "demo"
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  type        = "map"

  default = {
    terraform = true
  }
}

variable "vpc_id" {
  description = "Input from ./base output"
  type        = "string"
}

variable "private_subnet_ids" {
  description = "Input from ./base output"
  type        = "list"
}

variable "public_subnet_ids" {
  description = "Input from ./base output"
  type        = "list"
}

variable "internal_dns_zone_id" {
  description = "Input from ./base output"
  type        = "string"
}

variable "chamber_key_id" {
  description = "Chamber KMS Key ID"
  type        = "string"
}

variable "chamber_key_arn" {
  description = "Chamber KMS Key ARN"
  type        = "string"
}

variable "image_id" {
  description = "AMI ID to use"
  default     = "ami-0c15064daa40f95b5"
}

variable "instance_type" {
  description = "The instance type to use, e.g t2.small"
  default     = "t3.small"
}

variable "ssh_key_name" {
  description = "The aws ssh key name."
  default     = ""
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 20
}

variable "ingress_allow_security_groups" {
  description = "A list of security group IDs to allow traffic from"
  type        = "list"
  default     = []
}

variable "ingress_allow_cidr_blocks" {
  description = "A list of CIDR blocks to allow traffic from"
  type        = "list"
  default     = []
}

variable "wordpress_site_title" {
  description = "Wordpress Site default Title"
  default     = "Demo Wordpress Site"
}

variable "wordpress_admin_email" {
  description = "Wordpress Admin email"
  default     = "null@null.com"
}
