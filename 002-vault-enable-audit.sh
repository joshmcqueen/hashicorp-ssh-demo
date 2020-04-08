#!/bin/sh

# export VAULT_TOKEN=s.tUJ3hK3VsKyCuGnnmUfhUljp
# export VAULT_ADDR="http://127.0.0.1:8200"

./000-setup.sh

# create path for log file
sudo mkdir /var/log/vault
sudo chown -R vault:vault /var/log/vault
sudo chmod -R 777 /var/log/vault

# enable auditing
vault audit enable file file_path=/var/log/vault/vault_audit.log mode="0777" log_raw="true"

# enable monitoring and log shipping
sudo -u splunk /opt/splunkforwarder/bin/splunk add monitor /var/log/vault -auth admin:password123
sudo -u splunk /opt/splunkforwarder/bin/splunk add forward-server ${VAULT_IP}:9997 -auth admin:password123