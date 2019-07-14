resource "random_string" "auth_key" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "auth_key" {
  name      = "/${var.name}/wordpress/auth_key"
  value     = "${random_string.auth_key.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "secure_auth_key" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "secure_auth_key" {
  name      = "/${var.name}/wordpress/secure_auth_key"
  value     = "${random_string.secure_auth_key.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "logged_in_key" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "logged_in_key" {
  name      = "/${var.name}/wordpress/logged_in_key"
  value     = "${random_string.logged_in_key.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "nonce_key" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "nonce_key" {
  name      = "/${var.name}/wordpress/nonce_key"
  value     = "${random_string.nonce_key.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "auth_salt" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "auth_salt" {
  name      = "/${var.name}/wordpress/auth_salt"
  value     = "${random_string.auth_salt.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "secure_auth_salt" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "secure_auth_salt" {
  name      = "/${var.name}/wordpress/secure_auth_salt"
  value     = "${random_string.secure_auth_salt.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "logged_in_salt" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "logged_in_salt" {
  name      = "/${var.name}/wordpress/logged_in_salt"
  value     = "${random_string.logged_in_salt.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}

resource "random_string" "nonce_salt" {
  length  = 65
  special = true
}

resource "aws_ssm_parameter" "nonce_salt" {
  name      = "/${var.name}/wordpress/nonce_salt"
  value     = "${random_string.nonce_salt.result}"
  type      = "SecureString"
  key_id    = "${var.chamber_key_id}"
  overwrite = true
}
