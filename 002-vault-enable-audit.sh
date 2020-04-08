#!/bin/sh

export VAULT_TOKEN=s.Ww6UDB5Jw7PJP2BlmzkXLpdV
export VAULT_ADDR="http://127.0.0.1:8200"

# create path for log file
sudo mkdir /var/log/vault
sudo chown -R vault:vault /var/log/vault
sudo chmod -R 777 /var/log/vault

# enable auditing
vault audit enable file file_path=/var/log/vault/vault_audit.log mode="0777" log_raw="true"

# enable monitoring and log shipping
sudo -u splunk /opt/splunkforwarder/bin/splunk add monitor /var/log/vault -auth admin:password123
sudo -u splunk /opt/splunkforwarder/bin/splunk add forward-server 34.223.240.86:9997 -auth admin:password123