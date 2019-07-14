variable "tags" {
  type        = "map"
  description = "Map of tags for resources"

  default = {
    terraform = true
  }
}

variable "cidr_block" {
  type        = "string"
  description = "CIDR for the VPC"
  default     = "10.128.0.0/16"
}

variable "availability_zones" {
  type        = "list"
  description = "Availability Zones where subnets will be created"
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "internal_domain_name" {
  description = "Internal DNS Name"
  default     = "local"
}
