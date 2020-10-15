data "template_file" "cn_client" {
template = file("${path.module}/templates/vault_agent.sh")

}

resource "ncloud_server" "cn_client" {
  name                      = "cn-client"
  server_image_product_code = var.ncloud.server_image_product_code
  server_product_code       = var.ncloud.server_product_code
  login_key_name            = ncloud_login_key.key.key_name
  zone                      = var.ncloud.zone
  user_data                 = data.template_file.cn_client.rendered

  tag_list {
    tag_key   = "owner"
    tag_value = "jsp@hashicorp.com"
  }

  depends_on = [
    ncloud_server.cn_host,
  ]
}

data "ncloud_root_password" "cn_client_rootpwd" {
  server_instance_no = ncloud_server.cn_client.id
  private_key        = ncloud_login_key.key.private_key
}

// resource "ncloud_port_forwarding_rule" "cn_client_forwarding" {
//   // port_forwarding_configuration_no = data.ncloud_port_forwarding_rules.rules.id
//   server_instance_no            = ncloud_server.cn_client.id
//   port_forwarding_external_port = var.ssh_external_port.cn_client
//   port_forwarding_internal_port = "22"
// }

resource "ncloud_public_ip" "cn_client_public_ip" {
  server_instance_no = ncloud_server.cn_client.id
}

# 데모 시 사용할 사용자 계정 추가
resource "null_resource" "cn_client_provisioner" {
  provisioner "remote-exec" {
    inline = [
      "groupadd mygrp",
      "useradd -d /home/vlt_user -m -G mygrp -s /bin/bash vlt_user",
      "echo 'vlt_user:welcome1!' | chpasswd"
    ]
  }

  connection {
    type     = "ssh"
    host     = ncloud_public_ip.cn_client_public_ip.public_ip
    user     = "root"
    port     = "22"
    password = data.ncloud_root_password.cn_client_rootpwd.root_password
  }


}

output "cn_client_pw" {
  value = "sshpass -p '${data.ncloud_root_password.cn_client_rootpwd.root_password}' ssh root@${ncloud_public_ip.cn_client_public_ip.public_ip} -oStrictHostKeyChecking=no"
}
