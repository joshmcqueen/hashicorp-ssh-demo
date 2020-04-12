#!/bin/sh

set -e
PATH=`pwd`/bin:$PATH
if [ -f 000-setup.sh ]; then
    . ./000-setup.sh
fi

export VAULT_TOKEN=${VAULT_ROOT_TOKEN}
export VAULT_ADDR=${VAULT_ADDR}

vault secrets enable -path=audits-ca ssh

vault write audits-ca/config/ca generate_signing_key=true

vault write audits-ca/roles/sign-key -<<"EOH"
{
  "allow_user_certificates": true,
  "allowed_users": "*",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "ubuntu",
  "ttl": "10m0s"
}
EOH


vault policy write audits-ca -<<"EOH"
path "audits-ca/sign/*" {
  capabilities = ["create", "read", "update"]
}
EOH

vault write auth/userpass/users/joe password="password123" policies="audits-ca"