#!/usr/bin/env sh

# check for static website
if [ ! -f "/var/www/html/index.html" ]; then
	echo "[INFO] copying static website..."
	mv /tmp/website/* /var/www/html/
fi
