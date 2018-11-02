variable "count" {}

variable "connections" {
  type = "list"
}

variable "rexray_s3_url" {
  type = "string"
}

variable "rexray_s3_accesskey" {
  type = "string"
}

variable "rexray_s3_secret" {
  type = "string"
}

variable "overlay_interface" {
  default = "weave"
}

resource "null_resource" "rexray" {

  count = "${var.count}"

  connection {
    host  = "${element(var.connections, count.index)}"
    user  = "root"
    agent = true
  }

#  provisioner "remote-exec" {
#    inline = [
#      "systemctl daemon-reload",
#    ]
#  }

  provisioner "remote-exec" {
    inline = <<EOF
  ${element(data.template_file.install.*.rendered, count.index)}
  EOF
  }
}

data "template_file" "install" {
  template = "${file("${path.module}/scripts/install.sh")}"

  vars {
    rexray_s3_url = "${var.rexray_s3_url}"
    rexray_s3_accesskey = "${var.rexray_s3_accesskey}"
    rexray_s3_secret = "${var.rexray_s3_secret}"
  }
}

output "overlay_interface" {
  value = "${var.overlay_interface}"
}
