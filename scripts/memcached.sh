
# These settings allow you to load balance for horizontal scaling-- this is for sharing your PHP Session data.

sed -i "s/session.save_handler =.*/session.save_handler = memcached/" /etc/php5/fpm/php.ini

# To share PHP Session data you have to specify that the session data is stored to all memcached instances on all servers
# Once stored on all hosts, reading is just a matter of hitting the local memcached.
# Security Note: Only specifying listening on IP:port of private networks behind firewalls

sed -i "s/;session.save_path =.*/session.save_path = \"127.0.0.1:11211\"\nmemcached.sess_prefix = \"\"/" /etc/php5/fpm/php.ini

# Problems with session_destroy() are solved with this:
# memcached.sess_prefix = \"\"
# added after editing session.save_path above

sed -i "s/session.gc_maxlifetime =.*/session.gc_maxlifetime = 720/" /etc/php5/fpm/php.ini


# You may need to modify the memcached settings if more machines are pooled

# listen on a port of a firewalled/private network IP
# memcached -l 127.0.0.1:11211,10.1.2.3:11211
# or go straight for the config file to edit the service 
# vi /etc/memcached.conf

# service memcached restart