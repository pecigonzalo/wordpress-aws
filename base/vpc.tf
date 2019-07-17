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

resource "aws_vpc_dhcp_options" "default" {
  domain_name         = "${var.internal_domain_name}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = "${var.tags}"
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = "${aws_vpc.default.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.default.id}"
}
