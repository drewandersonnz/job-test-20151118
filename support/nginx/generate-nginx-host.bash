#!/bin/bash

# Cheat here:
ipaddress=`/usr/bin/docker inspect --format '{{ .NetworkSettings.IPAddress }}' node`

cat > ./default.conf << EndOfConfig
server {
    listen       80;
    server_name  localhost;

    location / {
        proxy_pass http://${ipaddress}:8080;
    }
}
EndOfConfig
