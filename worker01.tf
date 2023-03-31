resource "null_resource" "setup_worker01" {
  triggers = {
    order = null_resource.init_master.id
  }

  connection {
    type     = "ssh"
    host     = var.worker01_hostname
    user     = var.worker01_user
    password = var.worker01_password
    timeout  = "40s"
  }

  provisioner "file" {
    source      = "./scripts/centos/setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      type     = "ssh"
      host     = var.worker01_hostname
      user     = var.worker01_user
      password = var.worker01_password
      timeout  = "40s"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh ${var.kube_version}",
    ]
  }
}

resource "null_resource" "join_worker01" {
  triggers = {
    order = null_resource.setup_worker01.id
  }

  connection {
    type     = "ssh"
    host     = var.worker01_hostname
    user     = var.worker01_user
    password = var.worker01_password
    timeout  = "40s"
  }

  provisioner "file" {
    source      = "./scripts/centos/worker_init.sh"
    destination = "/tmp/worker_init.sh"

    connection {
      type     = "ssh"
      host     = var.worker01_hostname
      user     = var.worker01_user
      password = var.worker01_password
      timeout  = "40s"
    }
  }

  provisioner "file" {
    source      = "/token.txt"
    destination = "/tmp/token.txt"

    connection {
      type     = "ssh"
      host     = var.worker01_hostname
      user     = var.worker01_user
      password = var.worker01_password
      timeout  = "40s"
    }
  }

  provisioner "file" {
    source      = "/hash.txt"
    destination = "/tmp/hash.txt"
    connection {
      type     = "ssh"
      host     = var.worker01_hostname
      user     = var.worker01_user
      password = var.worker01_password
      timeout  = "40s"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/worker_init.sh",
      "/tmp/worker_init.sh ${var.apiserver_advertise_address}"
    ]
  }

}