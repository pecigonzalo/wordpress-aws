locals {
  private_subnet_count = "${length(data.aws_availability_zones.available.names)}"
}

#
resource "aws_subnet" "private" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  cidr_block = "${
    cidrsubnet(
      signum(length(var.cidr_block)) == 1 ? var.cidr_block : var.cidr_block,
      ceil(log(local.private_subnet_count * 2, 2)),
      count.index
    )}"

  tags = "${merge(map("Name", "private"), var.tags)}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.default.id}"

  tags = "${merge(map("Name", "private"), var.tags)}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
