resource "aws_kms_key" "chamber" {
  description             = "KMS key for chamber"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = "${var.tags}"
}

resource "aws_kms_alias" "chamber" {
  name          = "alias/chamber_parameter_store_key"
  target_key_id = "${aws_kms_key.chamber.id}"
}
