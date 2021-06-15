#!/bin/bash

cd /tmp
echo "Wordpress has been installed successfully!!";
echo "";
echo "Now deploying senai-wp/joao-amaral-b repository...";

apt install git -y
git clone https://github.com/joao-amaral-b/senai-wp

sed -i -e 's/ec2-3-90-218-43.compute-1.amazonaws.com/192.168.15.8/g' /tmp/file.txt

cp -r senai-wp/* /var/www/html/wordpress
echo "source senai-wp/full-backup-db-wp.sql" | mysql -u root -p$mariaDBRootUserPassword
echo "GRANT ALL PRIVILEGES on wp_database.* TO 'wpuser'@'localhost' IDENTIFIED BY 'Darede@132';" | mysql -u root -p$mariaDBRootUserPassword