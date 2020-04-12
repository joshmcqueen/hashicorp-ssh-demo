#!/bin/sh

set -e
PATH=`pwd`/bin:$PATH
if [ -f 000-setup.sh ]; then
    . ./000-setup.sh
fi

export VAULT_TOKEN=${VAULT_ROOT_TOKEN}
export VAULT_ADDR=${VAULT_ADDR}

# fetch, modify, and update default policy
vault read -field rules sys/policy/default >> ~/default.hcl

tee -a ~/default.hcl > /dev/null <<EOT
# To view in Web UI
path "sys/mounts" {
  capabilities = [ "read", "update" ]
}
# To configure the SSH secrets engine
path "ssh/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
# To enable secrets engines
path "sys/mounts/*" {
  capabilities = [ "create", "read", "update", "delete" ]
}
EOT

vault policy write default ~/default.hcl

# enable secrets engine
vault secrets enable ssh

vault write ssh/roles/consultants-otp key_type=otp default_user=ubuntu cidr_list=0.0.0.0/0

tee consultants-otp-role.hcl <<EOF
path "ssh/creds/consultants-otp" {
  capabilities = ["create", "read", "update"]
}
EOF

vault policy write consultants-otp ./consultants-otp-role.hcl

vault auth enable userpass

vault write auth/userpass/users/carol password="password123" policies="consultants-otp"