#!/usr/bin/env sh

# check for phpmyadmin
if [ ! -d "/var/www/html/phpmyadmin" ]; then
	echo "[INFO] installing phpmyadmin..."
	wget -q "https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip" || (echo "[ERROR] wget failed, installation failed")
	unzip -q "phpMyAdmin-5.0.2-all-languages.zip"
	rm "phpMyAdmin-5.0.2-all-languages.zip"
	mv "phpMyAdmin-5.0.2-all-languages" "phpmyadmin"
	cp "/var/www/html/phpmyadmin/config.sample.inc.php" "/var/www/html/phpmyadmin/config.inc.php"
	sed -i "s|localhost|$MYSQL_HOST|g" /var/www/html/phpmyadmin/config.inc.php
fi
