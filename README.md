# 2015DebianJessieWebserverProject
A setup script for a Debian LAMP Webserver.
Building with a security focus & geared towards higher performance than stock.


Initially this will be in implemented with bash until I arrive at an end result I am happy with.

I will use the bash script as a roadmap to build an Ansible playbook.


TODO:

configure DKIM

a script to add a new virtualhost & new 'website' system users

a script to add human user acccounts (new VHOST fires this if 'person' user doesn't exist by default)

a note displays to ensure users are added to groups appropriately

make security improvement changes to apache
(like hiding version & whatnot, much guided by securityheaders.com)

install global webdev resources like composer, node, fonts

improve troubleshooting resources

remedy broken GUI SFTP -- works fine CLI

update troubleshooting resources on github

improve readability

break into modular scripts

THANKS:

simplified logging - http://reddit.com/user/cheaphomemadeacid
