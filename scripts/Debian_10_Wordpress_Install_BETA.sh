#!/bin/bash
#
# Install WordPress on a Debian/Ubuntu VPS
#

clear;

echo -e "Antes de iniciar, certifique-se de ter instalado o MariaDB e Apache2, não é necessário ter criado um banco de dados, este script fará isto para você: \n\n";

echo "Aperte [ENTER] para começar...";
read;

apt update -y
apt upgrade -y
#apt install php libapache2-mod-php php-mcrypt php-mysql
apt install php libapache2-mod-php php-mysql -y
apt install git -y

# Echo config to file
echo "
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" > /etc/apache2/mods-enabled/dir.conf

# Create MySQL database
read -p "Enter your MySQL root password: " rootpass
read -p "Database name: " dbname
read -p "Database username: " dbuser
read -p "Enter a password for user $dbuser: " userpass
echo "CREATE DATABASE $dbname;" | mysql -u root -p$rootpass
echo "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$userpass';" | mysql -u root -p$rootpass
echo "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';" | mysql -u root -p$rootpass
echo "FLUSH PRIVILEGES;" | mysql -u root -p$rootpass
echo "New MySQL database is successfully created"

# Download, unpack and configure WordPress
read -r -p "Enter your WordPress URL? [e.g. mywebsite.com]: " wpURL
wget -q -O - "http://wordpress.org/latest.tar.gz" | tar -xzf - -C /var/www --transform s/wordpress/$wpURL/
chown www-data: -R /var/www/$wpURL && cd /var/www/$wpURL
cp wp-config-sample.php wp-config.php
chmod 640 wp-config.php
mkdir uploads
sed -i "s/database_name_here/$dbname/;s/username_here/$dbuser/;s/password_here/$userpass/" wp-config.php

# Create Apache virtual host
echo "
<VirtualHost *:80>
	ServerName $wpURL
	ServerAlias www.$wpURL
	DocumentRoot /var/www/$wpURL
	DirectoryIndex index.php

	Options FollowSymLinks

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/$wpURL.conf

git clone https://github.com/joao-amaral-b/senai-wp
cp -r senai-wp/* /var/www/$wpURL

# Enable the site
a2ensite $wpURL.conf
service apache2 restart

# Output
WPVER=$(grep "wp_version = " /var/www/$wpURL/wp-includes/version.php |awk -F\' '{print $2}')
echo -e "\nWordPress version $WPVER is successfully installed!"
echo -en "\aPlease go to http://$wpURL and finish the installation\n"
