locals {
  nat_count = "${length(var.availability_zones)}"
}

resource "aws_eip" "default" {
  count = "${local.nat_count}"
  vpc   = true
  tags  = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = "${local.nat_count}"
  allocation_id = "${element(aws_eip.default.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  tags          = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "default" {
  count                  = "${local.nat_count}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id         = "${element(aws_nat_gateway.default.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}
