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

vault write ssh/roles/otp_key_role key_type=otp default_user=ubuntu cidr_list=0.0.0.0/0

tee test.hcl <<EOF
path "ssh/creds/otp_key_role" {
  capabilities = ["create", "read", "update"]
}
EOF

vault policy write test ./test.hcl

vault auth enable userpass

vault write auth/userpass/users/josh password="password123" policies="test"