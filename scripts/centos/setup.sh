#!/bin/bash

yum -y update

# disable firewall
systemctl disable firewalld && systemctl stop firewalld

# firewall-cmd --permanent --add-port=6443/tcp
# firewall-cmd --permanent --add-port=4443/tcp
# firewall-cmd --permanent --add-port=2379-2380/tcp
# firewall-cmd --permanent --add-port=10250/tcp
# firewall-cmd --permanent --add-port=10251/tcp
# firewall-cmd --permanent --add-port=10252/tcp
# firewall-cmd --permanent --add-port=10255/tcp
# firewall-cmd --permanent --add-port=4369/tcp # rabbitmq
# firewall-cmd --permanent --add-port=6783/tcp # weave
# firewall-cmd --permanent --add-port=6784/tcp # weave
# firewall-cmd --reload

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

sysctl --system

yum install -y git

# install docker
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# install containerd
dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y docker-ce --allowerasing

systemctl start docker
systemctl enable docker

tee /etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

dnf install -y kubeadm-$1 kubelet-$1 kubectl-$1 --disableexcludes=kubernetes
systemctl enable --now kubelet
systemctl start kubelet

swapoff -a
sed -i '$d' /etc/fstab

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl daemon-reload
systemctl restart docker

cat > /etc/containerd/config.toml <<EOF
[plugins."io.containerd.grpc.v1.cri"]
  systemd_cgroup = true
EOF

systemctl restart containerd

dnf install -y iproute-tc

exit 0