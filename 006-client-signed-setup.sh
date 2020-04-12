#!/bin/sh

set -e
PATH=`pwd`/bin:$PATH
if [ -f 000-setup.sh ]; then
    . ./000-setup.sh
fi

# get the public key from vault
sudo curl -o /etc/ssh/trusted-user-ca-keys.pem http://${VAULT_IP}:8200/v1/ssh-client-signer/public_key

# configure SSHD w/ new key
echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" | sudo tee -a /etc/ssh/sshd_config

# generate new key
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

vault write ssh-client-signer/sign/my-role \
    public_key=@$HOME/.ssh/id_rsa.pub