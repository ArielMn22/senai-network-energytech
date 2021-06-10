#!/bin/bash

echo "Insert you IP Adress:"
read ipaddress

echo -e "\n"

echo -e "MariaDB\n"
echo "Insert the user to be created: "
read user

echo "Insert the user password: "
read userpassword

apt install -y apache2 php7.3 libapache2-mod-php7.3 php7.3-common php7.3-mbstring php7.3-xmlrpc php7.3-soap php7.3-gd php7.3-xml php7.3-intl php7.3-mysql php7.3-cli php7.3-ldap php7.3-zip php7.3-curl

apt install -y default-mysql-server

clear;

echo "Now install MariaDB:"

mysql_secure_installation

echo "Please, enter the password that you just used for the MariaDB root user once again: "
read mariaDBRootUserPassword

echo "CREATE DATABASE wordpress;" | mysql -u root -p$mariaDBRootUserPassword
echo "GRANT ALL PRIVILEGES on wordpress.* TO '$user'@'localhost' IDENTIFIED BY '$userpassword';" | mysql -u root -p$mariaDBRootUserPassword
echo "FLUSH PRIVILEGES;" | mysql -u root -p$mariaDBRootUserPassword
echo "EXIT;" | mysql -u root -p$mariaDBRootUserPassword

cd /tmp/
wget -c https://wordpress.org/latest.tar.gz

tar -xvzf latest.tar.gz
mv wordpress/ /var/www/html/
chown -R www-data:www-data /var/www/html/wordpress/
chmod 755 -R /var/www/html/wordpress/

echo "
<VirtualHost *:80>
     ServerAdmin admin@$ipaddress_error.com
      DocumentRoot /var/www/html/wordpress
     ServerName $ipaddress

     <Directory /var/www/html/wordpress>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog ${APACHE_LOG_DIR}/$ipaddress_error.log
     CustomLog ${APACHE_LOG_DIR}/$ipaddress_error_access.log combined

</VirtualHost>" > /etc/apache2/sites-enabled/wordpress.conf

ln -s /etc/apache2/sites-available/wordpress.conf /etc/apache2/sites-enabled/wordpress.conf
a2enmod rewrite
systemctl restart apache2
