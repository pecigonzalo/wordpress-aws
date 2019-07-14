# VPC
output "igw_id" {
  description = "Internet Gateway ID"
  value       = "${aws_internet_gateway.default.id}"
}

output "vpc_id" {
  description = "VPC ID"
  value       = "${aws_vpc.default.id}"
}

output "vpc_main_route_rable_id" {
  description = "Main VPC Route Table ID"
  value       = "${aws_vpc.default.main_route_table_id}"
}

output "vpc_default_network_acl_id" {
  description = "Default Network ACL ID"
  value       = "${aws_vpc.default.default_network_acl_id}"
}

# Subnets
output "public_subnet_ids" {
  description = "The public subnets IDs"
  value       = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  description = "The private subnets IDs"
  value       = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_cidrs" {
  description = "Public subnets CIDRs"
  value       = ["${aws_subnet.public.*.cidr_block}"]
}

output "private_subnet_cidrs" {
  description = "Private subnets CIDRs"
  value       = ["${aws_subnet.private.*.cidr_block}"]
}

output "nat_gateway_ids" {
  description = "NAT Gateways IDs"
  value       = ["${aws_nat_gateway.default.*.id}"]
}

output "public_route_table_ids" {
  description = "Public route tables IDs"
  value       = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  description = "Private route tables IDs"
  value       = ["${aws_route_table.private.*.id}"]
}

output "internal_dns_zone_id" {
  description = "Internal DNS Zone ID"
  value       = "${aws_route53_zone.internal.id}"
}
