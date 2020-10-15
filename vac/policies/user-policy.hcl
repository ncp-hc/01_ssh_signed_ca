path "sys/mounts" {
  capabilities = ["list", "read"]
}

path "ssh-client-signer/sign/clientrole" {
  capabilities = ["create", "update"]
}

path "ssh-client-signer/config/ca" {
  capabilities = ["read"]
}

path "ssh-host-signer/config/ca" {
  capabilities = ["read"]
}
