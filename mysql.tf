module "mysql" {
  source = "./modules/mysql"

  vpc_id     = "${var.vpc_id}"
  subnet_ids = "${var.private_subnet_ids}"
  zone_id    = "${var.internal_dns_zone_id}"
}
