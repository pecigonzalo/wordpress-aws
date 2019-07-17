data "template_file" "user_data" {
  template = "${file("${path.module}/user_data/bootstrap.sh")}"

  vars {
    NAME = "${var.name}"
    EFS  = "${aws_efs_file_system.wordpress.id}.efs.${data.aws_region.current.name}.amazonaws.com"
  }
}

data "template_cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${file("${path.module}/user_data/wordpress.yml")}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.user_data.rendered}"
  }
}

data "aws_ami" "wordpress" {
  owners = ["379101102735"]

  filter {
    name   = "image-id"
    values = ["${var.image_id}"]
  }
}

resource "aws_launch_template" "wordpress" {
  name_prefix = "${var.name}"

  user_data = "${data.template_cloudinit_config.user_data.rendered}"

  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
  ebs_optimized = true

  key_name = "${var.ssh_key_name}"

  instance_initiated_shutdown_behavior = "terminate"

  tags = "${merge(map("Name", "${var.name}"), var.tags)}"

  iam_instance_profile {
    arn = "${aws_iam_instance_profile.wordpress.arn}"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    delete_on_termination       = true
    associate_public_ip_address = true                                   # TODO: Set to false for production usage
    security_groups             = ["${aws_security_group.wordpress.id}"]
  }

  tag_specifications {
    resource_type = "volume"
    tags          = "${merge(map("Name", "${var.name}"), var.tags)}"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = "${merge(map("Name", "${var.name}"), var.tags)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name_prefix = "${var.name}"

  termination_policies = ["OldestLaunchTemplate", "Default"]
  vpc_zone_identifier  = "${var.public_subnet_ids}"
  min_size             = 2
  max_size             = 3

  launch_template {
    id      = "${aws_launch_template.wordpress.id}"
    version = "${aws_launch_template.wordpress.latest_version}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }

  depends_on = [
    "aws_ssm_parameter.wordpress_db_host",
    "aws_ssm_parameter.wordpress_db_user",
    "aws_ssm_parameter.wordpress_db_password",
    "aws_ssm_parameter.wordpress_db_name",
    "aws_ssm_parameter.auth_key",
    "aws_ssm_parameter.secure_auth_key",
    "aws_ssm_parameter.logged_in_key",
    "aws_ssm_parameter.nonce_key",
    "aws_ssm_parameter.auth_salt",
    "aws_ssm_parameter.secure_auth_salt",
    "aws_ssm_parameter.logged_in_salt",
    "aws_ssm_parameter.nonce_salt",
  ]
}

data "aws_iam_policy_document" "chamber" {
  statement {
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = ["ssm:GetParametersByPath", "ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:*:*:parameter/${var.name}/wordpress",
      "arn:aws:ssm:*:*:parameter/${var.name}/wordpress/*",
    ]

    effect = "Allow"
  }

  statement {
    actions   = ["kms:Decrypt"]
    resources = ["${var.chamber_key_arn}"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "instance_profile" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "wordpress" {
  name_prefix        = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.instance_profile.json}"
}

resource "aws_iam_instance_profile" "wordpress" {
  name_prefix = "${var.name}"
  role        = "${aws_iam_role.wordpress.name}"
}

resource "aws_iam_role_policy" "wordpress" {
  role   = "${aws_iam_role.wordpress.name}"
  policy = "${data.aws_iam_policy_document.chamber.json}"
}

resource "aws_security_group" "wordpress" {
  name_prefix = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows traffic from and to the EC2 instances of the Wordpress cluster"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = ["${aws_security_group.loadbalancer.id}"]
  }

  ingress {
    from_port   = 22            # TODO: Remove this block for production usage
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
