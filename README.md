# 2015DebianJessieWebserverProject
A setup script for a Debian LAMP Webserver.
Building with a security focus & geared towards higher performance than stock.


Initially this will be in implemented with bash until I arrive at an end result I am happy with.

I will use the bash script as a roadmap to build an Ansible playbook.


TODO:

finish configuring sentinel

create one config file that holds all the configurations
break the script into smaller pieces
create a top level script that runs all the smaller subordinate scripts
'source' the config file into each script
either run the next script directly from the current script or output prepared suggestions

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

For me to test the whole thing as-is:

wget https://raw.githubusercontent.com/bradchesney79/2015DebianJessieWebserverProject/master/build-script.sh; ./build-script.sh 2>&1 | tee /var/log/auto-install.log; usermod -a --groups default-web bradchesney79 2>&1 | tee /var/log/auto-install.log

#Takes ... on a Linode 1024
#real    7m55.128s
#real    9m49.525s
#real    4m27.518s
#real    3m56.291s
#real    4m4.988s
#(installs build tools)
#real   23m23.967s
#real   11m24.996s