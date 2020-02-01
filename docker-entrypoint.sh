#!/bin/bash
set -e

export KONG_NGINX_DAEMON=off

if [[ "$1" == "kong" ]]; then
  
  if [[ "$2" == "docker-start" ]]; then
    envsubst "\$PORT" < /etc/kong/kong.conf.template > /etc/kong/kong.conf
    mkdir -p /usr/local/kong/conf
    cp /usr/local/openresty/nginx/conf/mime.types /usr/local/kong/conf
    envsubst "\$PORT" < /usr/local/openresty/nginx/conf/nginx.conf.template > /usr/local/kong/conf/nginx.conf

    kong start
  fi
fi

exec "$@"
