locals {
  public_subnet_count = "${length(data.aws_availability_zones.available.names)}"
}

#
resource "aws_subnet" "public" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  cidr_block = "${
    cidrsubnet(
      signum(length(var.cidr_block)) == 1 ? var.cidr_block : var.cidr_block,
      ceil(log(local.public_subnet_count * 2, 2)),
      local.public_subnet_count + count.index
    )}"

  map_public_ip_on_launch = true

  tags = "${merge(map("Name", "public"), var.tags)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags = "${merge(map("Name", "public"), var.tags)}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}
