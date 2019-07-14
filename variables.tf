variable "name" {
  description = "Name of this wordpress stack"
  default     = "demo"
}

variable "vpc_id" {
  description = "Input from ./base output"
  type        = "string"
}

variable "private_subnet_ids" {
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
