#!/bin/bash

function usage {
  echo ""
  echo "This will upgrade dashboard in a location, including deps"
  echo "./${0} <HOSTNAME> --<opt>"
  echo "Example: ./${0} test01-dashboard-01 --check"
  echo ""
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

host=$1

# Use hostname not fqdn
if [[ $host == *.* ]] ; then
  usage
fi

if [ -z $2 ]; then
  opt=""
else
  opt="$2"
fi

sudo ansible-playbook $opt -e "hosts=${host}" lib/upgrade/dashboard.yaml
sudo ansible-playbook $opt -e "hosts=${host} patchfile=${HOME}/ansible/files/patches/0001-Only-show-the-image-visibility-option-if-it-s-allowe.patch" lib/patch.yaml
sudo ansible-playbook $opt -e "hosts=${host} name=httpd.service" lib/systemd_restart.yaml
