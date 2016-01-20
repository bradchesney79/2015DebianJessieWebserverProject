#!/bin/bash

CONFIGURATION="${1:-'./setup.conf'}"

source $CONFIGURATION

printf "\n########## CONFIG PHP-FPM ###\n"

mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.original
cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}.conf
cp /etc/php5/fpm/pool.d/www.conf.original /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

printf "\n########## DEFAULT HTTP POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN\]/" /etc/php5/fpm/pool.d/${DOMAIN}.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN.sock|" /etc/php5/fpm/pool.d/${DOMAIN}.conf

sed -i "s/user = www-data/user = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf
sed -i "s/group = www-data/group = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}.conf

printf "\n########## DEFAULT HTTPS POOL ###\n"

sed -i "s/\[www\]/\[$DOMAIN-SSL\]/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s|listen =.*|listen = $WEBROOT/sockets/$DOMAIN-SSL.sock|" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/user = www-data/user = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf
sed -i "s/group = www-data/group = $USER/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

sed -i "s/;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/${DOMAIN}-ssl.conf

printf "\n########## CONFIGURE PHP ###\n"

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.original


sed -i "s/;*short_open_tag.*/short_open_tag = Off/" /etc/php5/fpm/php.ini

sed -i "s/;*post_max_size.*/post_max_size = 12M/" /etc/php5/fpm/php.ini


sed -i "s/;*upload_max_filesize.*/upload_max_filesize = 12M/" /etc/php5/fpm/php.ini


sed -i "s/;*session.cookie_secure.*/session.cookie_secure = 1/" /etc/php5/fpm/php.ini


sed -i "s/;*session.cookie_httponly.*/session.cookie_httponly = 1/" /etc/php5/fpm/php.ini


sed -i "s/;*disable_functions.*/disable_functions = apache_child_terminate, apache_setenv, define_syslog_variables, escapeshellarg, escapeshellcmd, eval, exec, fp, fput, ftp_connect, ftp_exec, ftp_get, ftp_login, ftp_nb_fput, ftp_put, ftp_raw, ftp_rawlist, highlight_file, ini_alter, ini_get_all, ini_restore, inject_code, mysql_pconnect, openlog, passthru, pcntl_alarm, pcntl_exec, pcntl_fork, pcntl_get_last_error, pcntl_getpriority, pcntl_setpriority, pcntl_signal, pcntl_signal_dispatch, pcntl_sigprocmask, pcntl_sigtimedwait, pcntl_sigwaitinfo, pcntl_strerror, pcntl_wait, pcntl_waitpid, pcntl_wexitstatus, pcntl_wifexited, pcntl_wifsignaled, pcntl_wifstopped, pcntl_wstopsig, pcntl_wtermsig, phpAds_XmlRpc, phpAds_remoteInfo, phpAds_xmlrpcDecode, phpAds_xmlrpcEncode, php_uname, popen, posix_getpwuid, posix_kill, posix_mkfifo, posix_setpgid, posix_setsid, posix_setuid, posix_uname, proc_close, proc_get_status, proc_nice, proc_open, proc_terminate, shell_exec, syslog, system, xmlrpc_entity_decode/" /etc/php5/fpm/php.ini