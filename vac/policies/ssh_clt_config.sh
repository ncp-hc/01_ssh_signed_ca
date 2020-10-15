#!/bin/bash

# 1. Create key pair
echo "# 1. Create Key pair"
export SSH_USER="vlt_user" #(perform on ubuntu server)
export SSH_SERVER="Target_Host_IP" #(ssh host server ip address)
export VAULT_ADDR="http://IP_Address:8200" # Vault Server IP
rm -rf token ssh-ca.json ~/.ssh/id_rsa_${SSH_USER}*
ssh-keygen -t rsa -N "" -C "${SSH_USER}" -f ~/.ssh/id_rsa_${SSH_USER}
export PUB_KEY="$(cat ~/.ssh/id_rsa_${SSH_USER}.pub)"
echo ${PUB_KEY}

echo "Done: Create Key Pair"

# Login to Vault and export Vault Token
echo "2. login to Vault and export Vault Token"
curl --request POST --data '{"password": "test"}' ${VAULT_ADDR}/v1/auth/userpass/login/${SSH_USER} | jq -r .auth.client_token > token

export VAULT_TOKEN=$(cat token)

# Get the public key signed by Vault
tee ssh-ca.json <<EOF
{
    "public_key": "${PUB_KEY}",
    "valid_principals": "${SSH_USER}"
}
EOF
cat ssh-ca.json
curl -s \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request POST \
  --data @ssh-ca.json \
  $VAULT_ADDR/v1/ssh-client-signer/sign/clientrole | jq -r .data.signed_key > ~/.ssh/id_rsa_${SSH_USER}.signed.pub

chmod 400 ~/.ssh/id_rsa_${SSH_USER}*
echo "Perform SSH Login"
echo  "ssh -i ~/.ssh/id_rsa_${SSH_USER}.signed.pub -i ~/.ssh/id_rsa_${SSH_USER} ${SSH_USER}@${SSH_SERVER}"
