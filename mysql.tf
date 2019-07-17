module "mysql" {
  source = "./modules/mysql"

  vpc_id     = "${var.vpc_id}"
  subnet_ids = "${var.private_subnet_ids}"
  zone_id    = "${var.internal_dns_zone_id}"

  ingress_allow_security_groups = ["${aws_security_group.wordpress.id}"]
}

resource "aws_ssm_parameter" "wordpress_db_host" {
  name      = "/${var.name}/wordpress/wordpress_db_host"
  value     = "${module.mysql.hostname}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "aws_ssm_parameter" "wordpress_db_user" {
  name      = "/${var.name}/wordpress/wordpress_db_user"
  value     = "${module.mysql.database_user}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "aws_ssm_parameter" "wordpress_db_password" {
  name      = "/${var.name}/wordpress/wordpress_db_password"
  value     = "${module.mysql.database_password}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "aws_ssm_parameter" "wordpress_db_name" {
  name      = "/${var.name}/wordpress/wordpress_db_name"
  value     = "${module.mysql.database_name}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}
