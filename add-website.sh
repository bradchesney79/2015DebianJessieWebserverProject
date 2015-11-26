DOMAIN=$1
DOMAINUSER=${`cat rustbeltrebellion.com "-web" | sed -e 's/\.//g'`}_"-web"

#cat rustbeltrebellion.com "-web" | sed -e 's/\.//g'

echo $DOMAINUSER

if [ -f /var/log/messages ]
  then
    echo "/var/log/messages exists."
fi