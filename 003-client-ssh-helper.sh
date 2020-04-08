#!/bin/sh

set -e
PATH=`pwd`/bin:$PATH
if [ -f 000-setup.sh ]; then
    . ./000-setup.sh
fi

wget https://releases.hashicorp.com/vault-ssh-helper/0.1.4/vault-ssh-helper_0.1.4_linux_amd64.zip

sudo apt-get -y install unzip
sudo unzip -q vault-ssh-helper_0.1.4_linux_amd64.zip -d /usr/local/bin

sudo chmod 0755 /usr/local/bin/vault-ssh-helper
sudo chown root:root /usr/local/bin/vault-ssh-helper

sudo mkdir /etc/vault-ssh-helper.d/

VAULT_ADDR=${VAULT_ADDR}
sudo tee /etc/vault-ssh-helper.d/config.hcl <<EOF
vault_addr = "${VAULT_ADDR}"
ssh_mount_point = "ssh"
ca_cert = "-dev"
tls_skip_verify = true
allowed_roles = "*"
allowed_cidr_list = "0.0.0.0/0"
EOF

# edit /etc/pam.d/sshd
sudo sed -i 's/@include common-auth/#@include common-auth/g' /etc/pam.d/sshd
echo 'auth requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -dev -config=/etc/vault-ssh-helper.d/config.hcl' | cat - /etc/pam.d/sshd > temp && sudo mv -f temp /etc/pam.d/sshd
echo 'auth optional pam_unix.so not_set_pass use_first_pass nodelay' | cat - /etc/pam.d/sshd > temp && sudo mv -f temp /etc/pam.d/sshd

# update /etc/ssh/sshd_config
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config

# restart sshd
sudo systemctl restart sshd