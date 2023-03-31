resource "null_resource" "setup_master" {
  provisioner "local-exec" {
    command     = "chmod +x ./scripts/centos/setup.sh && ./scripts/centos/setup.sh ${var.kube_version}"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "init_master" {
  triggers = {
    order = null_resource.setup_master.id
  }
  provisioner "local-exec" {
    command     = "chmod +x ./scripts/centos/master_init.sh && ./scripts/centos/master_init.sh ${var.pod_network_cidr} ${var.apiserver_advertise_address} ${var.kube_version} ${var.worker01_ip_address} ${var.worker02_ip_address}"
    interpreter = ["/bin/bash", "-c"]
  }
}
