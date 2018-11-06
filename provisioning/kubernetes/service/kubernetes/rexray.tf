variable "rexray_s3_url" {
  type = "string"
}

variable "rexray_s3_accesskey" {
  type = "string"
}

variable "rexray_s3_secret" {
  type = "string"
}

resource "null_resource" "rexray" {
  count = "${var.count}"

  depends_on = ["null_resource.kubectl"]

  connection {
    host  = "${element(var.connections, count.index)}"
    user  = "root"
    agent = true
  }

  provisioner "remote-exec" {
    inline = <<EOF
  ${element(data.template_file.install_rexray.*.rendered, count.index)}
  EOF
  }
}

data "template_file" "install_rexray" {
  template = "${file("${path.module}/scripts/install.sh")}"

  vars {
    rexray_s3_url = "${var.rexray_s3_url}"
    rexray_s3_accesskey = "${var.rexray_s3_accesskey}"
    rexray_s3_secret = "${var.rexray_s3_secret}"
  }
}
