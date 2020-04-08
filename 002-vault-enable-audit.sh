#!/bin/sh

set -e
PATH=`pwd`/bin:$PATH
if [ -f 000-setup.sh ]; then
    . ./000-setup.sh
fi

export VAULT_TOKEN=${VAULT_ROOT_TOKEN}
export VAULT_ADDR=${VAULT_ADDR}

# create path for log file
sudo mkdir /var/log/vault
sudo chown -R vault:vault /var/log/vault
sudo chmod -R 777 /var/log/vault

# enable auditing
vault audit enable file file_path=/var/log/vault/vault_audit.log mode="0777" log_raw="true"

# enable monitoring and log shipping
sudo -u splunk /opt/splunkforwarder/bin/splunk add monitor /var/log/vault -auth admin:password123
sudo -u splunk /opt/splunkforwarder/bin/splunk add forward-server ${VAULT_IP}:9997 -auth admin:password123