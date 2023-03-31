#!/bin/bash

# firewall-cmd --zone=public --permanent --add-port={10250,6783,6784,30000-32767}/tcp
# firewall-cmd --reload

kubeadm join $1:6443 --token $(cat /tmp/token.txt) --discovery-token-ca-cert-hash sha256:$(cat /tmp/hash.txt)

exit 0