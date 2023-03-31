

Prerequisiti: 
1. hostname dei worker presenti in file `/etc/hosts`
2. `mkdir -p ./install/src/scripts/centos`
3. Trasferire files

```
chmod +x config.sh
./config.sh
terraform init
terraform apply --auto-approve
```