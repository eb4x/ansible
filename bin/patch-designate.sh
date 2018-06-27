#!/bin/bash

# print help
function usage {
  echo
  echo 'Run this script to patch the designate nova notification_handler'
  echo 'bin/patch-designate.sh <location>-dns-01'
  echo
  exit 1
}

host=$1

if [ $# -ne 1 ]; then
  usage
fi

sudo ansible-playbook -e "hosts=${host}" lib/designate_patch_notification_handler.yaml
