#!/bin/bash

# print help
function usage {
  echo ""
  echo "This will rebuild a storage host."
  echo "You will need the HOSTNAME (not FQDN) of the host"
  echo "./${0} <HOSTNAME> --force"
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi

if [ "${2}" != '--force' ]; then
  usage
fi
host=$1

# Use hostname not fqdn
if [[ $host == *.* ]] ; then
  usage
fi

IFS='-' read -r -a hostname <<< "$host"
location=${hostname[0]}

# Stop and destory all OSDs on target node
sudo ansible-playbook -e "myhosts=${host}" lib/osd_destroy.yaml
sudo ansible-playbook -e "myhosts=${location}-proxy-01 install_host=${host}" lib/prepare_reinstall.yaml
sudo ansible-playbook -e "myhosts=${host}" lib/reboot.yaml
sleep 120
sudo ansible-playbook -e "myhosts=${host}" lib/puppetrun.yaml
