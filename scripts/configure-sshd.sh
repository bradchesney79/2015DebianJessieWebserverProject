
printf "\n########## CONFIGURE SSH TO USE SUPPLEMENTAL ALGORITHMS ###\n"

printf "\n# Additional encryption algorithms for connecting via SSH" >> /etc/ssh/sshd_config
printf "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1" >> /etc/ssh/sshd_config

service sshd restart