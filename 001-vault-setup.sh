#!/bin/sh

# set inital vault settings
sudo -u vault tee /etc/vault.d/vault.hcl <<EOF
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_disable   = 1
}
storage "file" {
  path = "/opt/vault/data"
}
ui = true
EOF

sudo systemctl restart vault

# setup splunk agent 
wget -O splunkforwarder-8.0.3-a6754d8441bf-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.3&product=universalforwarder&filename=splunkforwarder-8.0.3-a6754d8441bf-linux-2.6-amd64.deb&wget=true'

sudo dpkg -i splunkforwarder-8.0.3-a6754d8441bf-linux-2.6-amd64.deb

mkdir ~/.splunk

chmod -R 777 ~/.splunk

sudo -u splunk tee /opt/splunkforwarder/etc/system/local/user-seed.conf <<EOF
[user_info]
USERNAME = admin
PASSWORD = password123
EOF

sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes

