#!/usr/bin/env sh

if [ ! -f /etc/vsftpd/vsftpd.conf.old ]; then
	echo "[INFO] configuring ftp..."
	mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.old
	mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

	adduser $FTP_USER --disabled-password
	echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

	echo $FTP_USER >> /etc/vsftpd.userlist

	# wait for wordpress to finish installation
	#while [ ! -f "/var/www/html/$WP_FILE_ONINSTALL" ]; do
	while [ ! -f "/var/www/html/$WP_FILE_ONINSTALL" ] || [ ! -f "/var/www/html/index.html" ] || [ ! -f "/var/www/html/adminer.php" ] || [ ! -d "/var/www/html/phpmyadmin" ]; do
		echo "[INFO] waiting for all installation to finish..."
		sleep 5
	done

	mkdir -p /var/www/html
	chown -R $FTP_USER:$FTP_USER /var/www/html
fi

chown -R $FTP_USER:$FTP_USER /var/www/html

echo "[INFO] starting... FTP server"

vsftpd /etc/vsftpd/vsftpd.conf
