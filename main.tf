data "template_file" "user_data" {
  template = "${file("${path.module}/user_data/wordpress.yml")}"

  vars {
    NAME = "${var.name}"
  }
}

data "template_cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.user_data.rendered}"
  }
}
