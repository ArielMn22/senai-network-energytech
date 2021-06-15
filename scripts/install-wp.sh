#!/bin/bash

clear

echo "Hello! How's your day going?";
echo ""
echo "This script was made to guide you through the darkness of the path to installing Wordpress and import 'joao-amaral-b's GitHub repository:";
echo ""
echo "You may be asking yourself 'What does this script does?'...";
echo "...And I'm here to answer."
echo ""
echo "This script installs:"
echo "- Apache2"
echo "- MariaDB"
echo "- Wordpress"
echo "- senai-wp/joao-amaral-b repository"

echo ""
echo "Press [ANY] key to start or Ctrl + C to close"
read;

clear;

echo "Network configuration"
echo "====================="

ip a

echo ""
echo "First of all:"
echo "Insert you IP Address:"
read ipaddress

echo -e "\n"

echo -e "MariaDB Variables\n"
echo "Insert the user to be created: "
read user

echo "Insert the user password: "
read userpassword

apt update -y

apt upgrade -y

apt install -y apache2 php7.3 libapache2-mod-php7.3 php7.3-common php7.3-mbstring php7.3-xmlrpc php7.3-soap php7.3-gd php7.3-xml php7.3-intl php7.3-mysql php7.3-cli php7.3-ldap php7.3-zip php7.3-curl

apt install -y default-mysql-server

clear;

echo "Now install MariaDB:"

mysql_secure_installation

echo -e "\nPlease, enter the password that you just used for the MariaDB root user once again: "
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

</VirtualHost>" > /etc/apache2/sites-available/wordpress.conf

ln -s /etc/apache2/sites-available/wordpress.conf /etc/apache2/sites-enabled/wordpress.conf
a2enmod rewrite

cd /etc/apache2/sites-available
a2dissite 000-default.conf

systemctl restart apache2
systemctl reload apache2

clear;

cd /tmp
echo "Wordpress has been installed successfully!!";
echo "";
echo "Now deploying senai-wp/joao-amaral-b repository...";

rm -rf /tmp/senai-wp

apt install git -y
git clone https://github.com/joao-amaral-b/senai-wp

sed -i -e "s/ec2-3-90-218-43.compute-1.amazonaws.com/$ipaddress/g" /tmp/senai-wp/full-backup-db-wp.sql

cp -r senai-wp/* /var/www/html/wordpress
echo "source senai-wp/full-backup-db-wp.sql" | mysql -u root -p$mariaDBRootUserPassword
echo "GRANT ALL PRIVILEGES on wp_database.* TO 'wpuser'@'localhost' IDENTIFIED BY 'Darede@132';" | mysql -u root -p$mariaDBRootUserPassword
