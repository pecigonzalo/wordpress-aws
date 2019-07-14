# Internal DNS Zone
resource "aws_route53_zone" "internal" {
  name = "${var.internal_domain_name}"

  vpc {
    vpc_id = "${aws_vpc.default.id}"
  }

  comment = "Internal ${aws_vpc.default.id}"

  tags = "${var.tags}"
}
