#!/bin/bash

set -e
set -o pipefail

# firewall-cmd --zone=public --permanent --add-port={6443,4443,2379,2380,10250,10251,10252,6783,6784}/tcp
# firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=$4/32 accept"
# firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=$5/32 accept"
# firewall-cmd --zone=public --permanent --add-rich-rule "rule family=ipv4 source address=$1 accept"
# firewall-cmd --reload

kubeadm init --pod-network-cidr $1 --apiserver-advertise-address=$2 --kubernetes-version $3 --ignore-preflight-errors=NumCPU

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# create a new token and take note
kubeadm token create > /token.txt

# take note of master hash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>> /dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' > /hash.txt

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$3&env.IPALLOC_RANGE=$1"

sleep 5

mkdir ./metrics-server && curl -L --output ./metrics-server/components.yaml https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml && \
        sed -i '/^      - args:/a \        - --kubelet-insecure-tls' ./metrics-server/components.yaml && \
        sed -i '/^        resources:/a \          limits:\n            cpu: 150m' ./metrics-server/components.yaml
        sed -i 's/.*--kubelet-preferred-address-types.*/        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname/' ./metrics-server/components.yaml

kubectl apply -f ./metrics-server/components.yaml

# add NamespaceLifecycle admission plugin for automatic namespace creation
# sed -i 's/.*--enable-admission-plugins.*/    - --enable-admission-plugins=NodeRestriction,NamespaceLifecycle/' /etc/kubernetes/manifests/kube-apiserver.yaml

sleep 5

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

exit 0