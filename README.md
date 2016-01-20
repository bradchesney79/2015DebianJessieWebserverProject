# 2015DebianJessieWebserverProject
A setup script for a Debian LAMP Webserver.
Building with a security focus & geared towards higher performance than stock.


Initially this will be in implemented with bash until I arrive at an end result I am happy with.

I will use the bash script as a roadmap to build an Ansible playbook.


TODO:

finish configuring sentinel

configure global webdev resources like composer, node, fonts to run tests & builds

improve troubleshooting resources

remedy broken GUI SFTP -- works fine CLI

update troubleshooting resources on github

improve readability

break into modular Ansible scripts


NICE TO HAVE:

disk partitions

THANKS:

simplified logging - http://reddit.com/user/cheaphomemadeacid


INSTRUCTIONS:

Start up a blank linode, initially provision it with Debian 8.1, SSH into the machine, cut/paste the monster concatenated list of commands below.

For someone else to try my mess:

wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/init.sh && chmod 770 init.sh && ./init.sh && cd /root/bin

--edit setup.conf vi, nano, emacs----

./build-script.sh

For me to test the whole thing as-is:

wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/init.sh && chmod 770 init.sh && ./init.sh && cd /root/bin && ./build-script.sh

--reboot--

rm /root/bin/load-script.sh /root/bin/scripts/back-end-build-chain.sh /root/bin/scripts/front-end-build-chain.sh /root/bin/scripts/sentinel.sh; pushd /root/bin/ && wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/load-script.sh && pushd /root/bin/scripts&& wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/scripts/back-end-build-chain.sh  && wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/scripts/front-end-build-chain.sh && wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/scripts/sentinel.sh && chmod 770 /root/bin/*.sh && chmod 770 /root/bin/scripts/*.sh && popd && popd && . /root/bin/load-script.sh

##Takes ... on a Linode 1024:
real    7m55.128s

real    9m49.525s

real    4m27.518s

real    3m56.291s

real    4m4.988s
(installs build tools)
real   23m23.967s

real   11m24.996s

real    6m36.334s + 