resource "aws_lb" "wordpress" {
  name_prefix = "${var.name}"

  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  internal                         = false

  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.loadbalancer.id}"]

  tags = "${var.tags}"
}

resource "random_id" "loadbalancer" {
  keepers {
    name   = "${var.name}"
    vpc_id = "${var.vpc_id}"
  }

  byte_length = 2
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.wordpress.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.wordpress.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "wordpress" {
  # A random_id are required to avoid recreation problems when settings change
  name        = "${var.name}-${random_id.loadbalancer.hex}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  health_check {
    path                = "/"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    matcher             = "200-399"
  }

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["name"]
  }
}

resource "aws_autoscaling_attachment" "wordpress" {
  autoscaling_group_name = "${aws_autoscaling_group.wordpress.id}"
  alb_target_group_arn   = "${aws_lb_target_group.wordpress.arn}"
}

resource "aws_security_group" "loadbalancer" {
  name_prefix = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows traffic from and to the LB of the Wordpress cluster"

  ingress {
    from_port   = 80
    to_port     = 80
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
