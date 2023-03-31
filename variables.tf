variable "pod_network_cidr" {
  default     = "10.10.0.0/16"
  description = "Pod CIDR, default 10.10.0.0/16"
}

variable "apiserver_advertise_address" {
  description = "IP address of master node"
}

variable "kube_version" {
  default     = "1.24.0"
  description = "Kubernetes version, es 1.24.0"
}

variable "worker01_hostname" {
  description = "Hostname of worker node 01, it must match the one in /etc/hosts"
}

variable "worker01_ip_address" {
  description = "IP address of worker node 01"
}

variable "worker01_user" {
  description = "User for ssh connection on worker node 01"
}

variable "worker01_password" {
  description = "Password for ssh connection on worker node 01"
}

variable "worker02_hostname" {
  description = "Hostname of worker node 02, it must match the one in /etc/hosts"
}

variable "worker02_ip_address" {
  description = "IP address of worker node 02"
}


variable "worker02_user" {
  description = "User for ssh connection on worker node 02"
}

variable "worker02_password" {
  description = "Password for ssh connection on worker node 02"
}

