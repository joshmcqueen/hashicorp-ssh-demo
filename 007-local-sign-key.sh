#!/bin/sh

set -e
PATH=`pwd`/bin:$PATH
if [ -f 000-setup.sh ]; then
    . ./000-setup.sh
fi

# generate new key
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

# get the public key from vault
sudo curl -o ~/.ssh/vault-public-key http://${VAULT_IP}:8200/v1/audits-ca/public_key

# login
curl \
    --request POST \
    --data '{"password":"password123"}' \
    http://35.164.148.29:8200/v1/auth/userpass/login/joe | jq '.auth'

# sign key
curl \
    --header "X-Vault-Token: s.LWJ22Jhen5g6CHs3vMsUQxVM" \
    --request POST \
    --data @payload_pub_key.json \
    http://35.164.148.29:8200/v1/audits-ca/sign/sign-key | jq '.data.signed_key' > ~/.ssh/signed-cert.pub


payload_pub_key
{
  "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDINC69y7j+O2l5DHXE0aQHVMlJQH6psAe45ITELxbqL+gRwXBGalM2HXxZ3EklgCFZ/3vklUp03WRyS8m0+HFCxHVORwnTtr2yYj8MMA+xnRJmWAYDeXz80PXl4q9wAVeDvov7cK1kntHZ3H+T8pUxHoJBA+O225ub2gwrIFyhHQGxBUHkC/mAaD+PRfUfG8rJ4kYY5+O2RsJVwrpXA9WZzGAv8mlGFnPa38ryPd1JtB4Kes+rpl/lQ2dCiamHz3Ed+GdXYXx0sPu4K7vs+mqdtqSyKBgWQzGN5VNAGZCrB7yjk6Hk5OT1N/pWLACx3W/qOIoDcluedOnuHzcI9tlGZmtuIHONWRvxNOBVIYpXsFSRHi1IJ7NmsxysAmJvp+c+qSCeAyt8F08d0fF6qVUgwrlcBl2tL7SAyHvuHs7rRiao+Iy0CyTo86ej5uo8dyridv3Bq1ws0Owf3c9h9F+WMenndWbodVkKL2qyLPKP35aGA6XyUjR5mnWouoHumxs= user@example.com"
}