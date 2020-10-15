resource "vault_mount" "ssh_client" {
    type = "ssh"
    path = "ssh-client-signer"
}

resource "vault_ssh_secret_backend_ca" "ssh_ca" {
    backend = vault_mount.ssh_client.path
    generate_signing_key = true
}

resource "local_file" "ssh_ca_key" {
    sensitive_content = vault_ssh_secret_backend_ca.ssh_ca.public_key
    filename = "./trusted-user-ca-keys.pem"
    file_permission = "0644"

    provisioner "file" {
        source      = "./trusted-user-ca-keys.pem"
        destination = "~/trusted-user-ca-keys.pem"

    connection {
        type     = "ssh"
        user     = "root"
        password = var.root_passwd
        host     = var.ssh_srv_public_ip
        }   
    }

    provisioner "file" {
        source      = "./policies/ssh_srv_config.sh"
        destination = "~/ssh_srv_config.sh"

    connection {
        type     = "ssh"
        user     = "root"
        password = var.root_passwd
        host     = var.ssh_srv_public_ip
        }    
    }

 provisioner "remote-exec" {
     inline = [
         "chmod +x ~/ssh_srv_config.sh",
         "cd ~ && ./ssh_srv_config.sh"
     ]
 connection {
        type     = "ssh"
        user     = "root"
        password = var.root_passwd
     host     = var.ssh_srv_public_ip
     }   
 }
}




# Apply Policy 
resource "vault_policy" "user_policy" {
  name = "user"

  policy = file("policies/user-policy.hcl")
}


resource "vault_auth_backend" "userpass" {
  type = "userpass"
}


# Create a user, 'vlt_user' to a Vault Server
# at the same time, OS User Account neeed to be added.
resource "vault_generic_endpoint" "vlt_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/vlt_user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["default", "user"],
  "password": "test"
}
EOT
}



# Configure client role
resource "vault_generic_endpoint" "client_role" {
  depends_on           = [vault_ssh_secret_backend_ca.ssh_ca]
  path                 = "ssh-client-signer/roles/clientrole"
  
  ignore_absent_fields = true

  data_json = <<EOT
{
    "allow_user_certificates": true,
    "allowed_extensions": "permit-pty,permit-port-forwarding",
    "allowed_users": "vlt_user",
    "default_extensions": [
      {
        "permit-pty": ""
      }
    ],
    "key_type": "ca",
    "default_user": "vlt_user",
    "ttl": "30m0s"
}
EOT
}
