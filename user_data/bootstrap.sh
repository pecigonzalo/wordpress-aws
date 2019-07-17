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

# Start Wordpress Configuration
docker pull wordpress:${WP_VERSION}
docker pull wordpress:cli

# Create supporting functions to keep code a bit more DRY
start-wp() {
  docker run -d \
    --restart=unless-stopped \
    --name=wordpress-fpm \
    --env-file=/etc/wordpress/config.env \
    -v /var/www/html/:/var/www/html/ \
    -p 80:80 \
    wordpress:${WP_VERSION}
}

wp-cli() {
  docker run --rm \
    --user 33:33 \
    --volumes-from wordpress-fpm \
    --network container:wordpress-fpm \
    wordpress:cli "$@"
}

retry() {
  local retries=$1
  shift

  local count=0
  until "$@"; do
    exit=$?
    wait=$((2 ** $count))
    count=$(($count + 1))
    if [ $count -lt $retries ]; then
      echo "Retry $count/$retries exited $exit, retrying in $wait seconds..."
      sleep $wait
    else
      echo "Retry $count/$retries exited $exit, no more retries left."
      return $exit
    fi
  done
  return 0
}

sleep $((RANDOM % 10)) # Sleep random 0-10
# Lock for bootstrap or else
if mkdir /var/www/lock; then
  # Start WP and wait for WP bootstrapping
  start-wp
  retry 20 test -f /var/www/html/wp-config.php
  # Configure HTTPS proto if https as source
  # TODO: Used with a real domain
  # sed -i "/\$table_prefix = 'wp_';/aif (\$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') \$_SERVER['HTTPS']='on';" /var/www/html/wp-config.php
  sed -i "/\$table_prefix = 'wp_';/a\$_SERVER['HTTPS']='on';" /var/www/html/wp-config.php

  # Configure URL/User/etc
  wp-cli core install \
    --url="${DOMAIN}" \
    --title="${TITLE}" \
    --admin_user="${ADMIN_USER}" \
    --admin_password="${ADMIN_PASSWORD}" \
    --admin_email="${ADMIN_EMAIL}" \
    --skip-email

  touch /var/www/lock/ok
else
  # Otherwise wait for bootstrap and then start
  retry 20 test -f /var/www/lock/ok
  start-wp
fi
