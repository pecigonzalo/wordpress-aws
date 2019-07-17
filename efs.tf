data "aws_region" "current" {}

resource "aws_efs_file_system" "wordpress" {
  tags = "${var.tags}"
}

resource "aws_efs_mount_target" "wordpress" {
  count           = "${length(var.private_subnet_ids)}"
  file_system_id  = "${aws_efs_file_system.wordpress.id}"
  subnet_id       = "${element(var.private_subnet_ids, count.index)}"
  security_groups = ["${aws_security_group.efs.id}"]
}

resource "aws_security_group" "efs" {
  name_prefix = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows traffic from and to the EFS instances"

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "TCP"
    security_groups = ["${aws_security_group.wordpress.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}
