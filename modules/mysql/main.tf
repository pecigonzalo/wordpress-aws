locals {
  database_port = 3306
}

resource "random_string" "rds_admin_user" {
  length  = 8
  special = false
  number  = false
}

resource "random_string" "rds_admin_password" {
  length  = 16
  special = true
}

resource "random_pet" "rds_db_name" {
  separator = "_"
}

resource "aws_db_instance" "default" {
  identifier_prefix = "${var.name}"

  name     = "${random_pet.rds_db_name.id}"
  username = "${random_string.rds_admin_user.result}"
  password = "${random_string.rds_admin_password.result}"
  port     = "${local.database_port}"

  engine                      = "mysql"
  engine_version              = "${var.engine_version}"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false

  multi_az             = "${var.multi_az}"
  parameter_group_name = "default.mysql${var.engine_version}"

  apply_immediately       = "${var.apply_immediately}"
  maintenance_window      = "${var.maintenance_window}"
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"
  copy_tags_to_snapshot   = true

  snapshot_identifier = "${var.snapshot_identifier}"

  instance_class    = "${var.instance_class}"
  allocated_storage = "${var.allocated_storage}"
  storage_type      = "${var.storage_type}"
  storage_encrypted = "${var.storage_encrypted}"
  iops              = "${var.iops}"

  final_snapshot_identifier = "${var.name}${random_pet.rds_dns_name.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.default.name}"
  publicly_accessible    = false

  deletion_protection = "${var.deletion_protection}"

  tags = "${merge(map("Name", var.name), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}
