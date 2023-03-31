#!/bin/bash

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

chmod +x ./scripts/centos/setup.sh
chmod +x ./scripts/centos/worker_init.sh
chmod +x ./scripts/centos/master_init.sh

echo ""
echo "Ready to install with Terraform!"