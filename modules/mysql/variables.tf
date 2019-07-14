# General Settings
variable "name" {
  default = "wp"
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  type        = "map"

  default = {
    terraform = true
  }
}

# Database
variable "instance_class" {
  description = "Database instance EG: db.t1.micro, db.t1.large, ..."
  default     = "db.t2.small"
}

variable "engine_version" {
  description = "Database engine version, depends on engine type"
  default     = "5.6"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "standard"
}

variable "allocated_storage" {
  description = "The allocated storage in GBs"
  default     = "10"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. Default is 0 if rds storage type is not 'io1'"
  default     = "0"
}

variable "storage_encrypted" {
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified"
  default     = true
}

variable "multi_az" {
  description = "Set to true if multi AZ deployment must be supported"
  default     = true
}

# Maintenance
variable "maintenance_window" {
  description = "Time window for maintenance."
  default     = "Mon:01:00-Mon:02:00"
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

# Backups
variable "backup_window" {
  description = "Time window for backups."
  default     = "00:00-01:00"
}

variable "backup_retention_period" {
  description = "Backup retention, in days"
  default     = 30
}

variable "snapshot_identifier" {
  description = "Snapshot name to create DB from e.g: rds:production-2015-06-26-06-05"
  default     = ""
}

variable "deletion_protection" {
  description = "If true is specified, the DB instance can't be deleted"
  default     = false                                                    # TODO: This should be true for production environments
}

# Route53

variable "zone_id" {
  description = "Zone ID where we create the R53 DB alias"
}

# Network Security
variable "vpc_id" {
  description = "VPC Id"
  type        = "string"
}

variable "subnet_ids" {
  description = "List of subnets for the DB"
  type        = "list"
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
