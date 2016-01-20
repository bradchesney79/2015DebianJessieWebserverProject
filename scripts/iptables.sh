
echo "Creating the iptables directory in /etc"
mkdir -p /etc/iptables

printf "\n/etc/iptables exists!!\n\n"

ls /etc/iptables

printf "\n/PROOF!\n\n"

touch /etc/iptables/rules.v4
touch /etc/iptables/rules.v6

printf "\nBegin updating the IP tables rules\n\n"

printf "\nEXPECT - $EXPECT\n\n"

${EXPECT} <<EOD
set timeout 120
log_file -a /tmp/iptables-persistent.log
spawn apt-get -y install iptables-persistent
expect {
  timeout { send_user "\nFailed to find IPV4 prompt.\n"; exit 1 }
  eof { send_user "\nIPV4 failure for iptables-persistent setup\n"; exit 1 }
  "*Save current IPv4 rules"}
send "\r"
expect {
  timeout { send_user "\nFailed to find IPV6 prompt.\n"; exit 1 }
  eof { send_user "\nIPV6 failure for iptables-persistent setup\n"; exit 1 }
  "*Save current IPv6 rules"}
send "\r"
expect {
  timeout { send_user "\nFailsafe failed, timeout.\n"; exit 1 }
  eof { send_user "\nFailsafe failed.\n"; exit 1 }
  "*"}
send "\r"
EOD

#FIXME cat /tmp/iptables-persistent.log

#FIXME rm /tmp/iptables-persistent.log

printf "\nUpdate the IP tables rules\n\n"

echo "*filter
#
# Loaded by /root/bin/iptables.sh via crontab at reboot
#
#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT -d 127.0.0.0/8 -j REJECT
#  Accept all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#  Allow all outbound traffic - you can modify this to only allow certain traffic
-A OUTPUT -j ACCEPT
#  Allow HTTP and HTTPS connections from anywhere (the normal ports for websites and SSL).
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
#  Allow SSH connections
#
#  The -dport number should be the same port number you set in sshd_config
#
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
#  Allow ping
-A INPUT -p icmp --icmp-type echo-request -j ACCEPT
#  Log iptables denied calls
#-A INPUT -m limit --limit 5/min -j LOG --log-prefix \"iptables denied: \" --log-level 7
#  Drop all other inbound - default deny unless explicitly allowed policy
-A INPUT -j DROP
-A FORWARD -j DROP
COMMIT" > /root/bin/iptables.load

cat /root/bin/iptables.load > /etc/iptables/rules.v4

printf "\n########## APPLY THE IPTABLES RULES ###\n"

printf "\nApply the IP tables rules\n\n"

iptables-restore < /etc/iptables/rules.v4

printf "\nMake the IP tables rules persistent\n\n"

echo "#!/bin/bash

cat /root/bin/iptables.load > /etc/iptables/rules.autosave_v4

iptables-restore < /etc/iptables/rules.v4" > /root/bin/iptables.sh

chmod 700 /root/bin/iptables.sh

echo "@reboot root /root/bin/iptables.sh" >> /etc/crontab 


#echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
#echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

#iptables-save > /etc/iptables/rules.v4
#ip6tables-save > /etc/iptables/rules.v6