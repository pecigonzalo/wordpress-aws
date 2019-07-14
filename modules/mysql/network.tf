resource "aws_db_subnet_group" "default" {
  subnet_ids = ["${var.subnet_ids}"]
  tags       = "${merge(map("Name", var.name), var.tags)}"
}

resource "random_pet" "rds_dns_name" {
  separator = "-"
}

resource "aws_route53_record" "default" {
  zone_id = "${var.zone_id}"
  name    = "${random_pet.rds_dns_name.id}"
  type    = "CNAME"
  ttl     = 60

  records = ["${aws_db_instance.default.address}"]

  allow_overwrite = false
}
