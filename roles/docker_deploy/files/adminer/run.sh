#!/usr/bin/env sh

# check for adminer
if [ ! -f "/var/www/html/adminer.php" ]; then
	# adminer
	echo "[INFO] installing adminer..."
	wget -O "/var/www/html/adminer.php" "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php"
fi
