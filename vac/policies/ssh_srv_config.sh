#!/bin/bash

cp ~/trusted-user-ca-keys.pem /etc/ssh/
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" | tee -a /etc/ssh/sshd_config
service sshd restart
