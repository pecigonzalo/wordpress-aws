resource "aws_vpc" "default" {
  cidr_block                       = "${var.cidr_block}"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false
  tags                             = "${var.tags}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags   = "${var.tags}"
}
