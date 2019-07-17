#!/bin/bash
set -euo pipefail
set -x # Print message so its easier to troublshoot

# Ensure docker is running
systemctl daemon-reload
systemctl enable docker.service
systemctl start docker.service

# Mount EFS
mkdir -p /var/www/
printf "${EFS}:/  /var/www/    nfs defaults,_netdev    0   0\n" >>/etc/fstab
mount \
  -t nfs4 \
  -o defaults,_netdev \
  "${EFS}:/" \
  /var/www/

# Get Secrets
curl -L \
  https://github.com/segmentio/chamber/releases/download/v2.3.3/chamber-v2.3.3-linux-amd64 \
  -o /usr/local/bin/chamber
chmod +x /usr/local/bin/chamber
mkdir -p /etc/wordpress
chamber export ${NAME}/wordpress | jq -r 'to_entries[] | (.key|ascii_upcase) + "=" + (.value|tostring)' >/etc/wordpress/config.env

# Start Wordpress
docker run -d \
  --restart=unless-stopped \
  --name=wordpress-fpm \
  --env-file=/etc/wordpress/config.env \
  -v /var/www/html/:/var/www/html/ \
  -p 80:80 \
  wordpress:5.2

wp-cli() {
  docker run -it --rm \
    --volumes-from wordpress-fpm \
    --network container:wordpress-fpm \
    wordpress:cli "$@"
}

# Bootstrap WP if first time
if mkdir /var/www/html/lock; then
  # Configure HTTPS proto if https as source
  sed -i "/\$table_prefix = 'wp_';/aif (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') \$_SERVER['HTTPS']='on';" /var/www/html/wp-config.php

  # Configure URL/User/etc
  wp-cli core install \
    --url="https://${DOMAIN}" \
    --title="${TITLE}" \
    --admin_user="${ADMIN_USER}" \
    --admin_password="${ADMIN_PASSWORD}" \
    --admin_email="${ADMIN_EMAIL}" \
    --skip-email
fi
