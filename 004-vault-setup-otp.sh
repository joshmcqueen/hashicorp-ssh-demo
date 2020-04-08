#!/bin/sh

export VAULT_TOKEN=s.Ww6UDB5Jw7PJP2BlmzkXLpdV
export VAULT_ADDR="http://127.0.0.1:8200"

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