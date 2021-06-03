#!/bin/bash

apt update -y
apt upgrade -y

apt install gnupg -y

wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb
dpkg -i mysql-apt-config_0.8.13-1_all.deb

apt update -y
apt upgrade -y

apt install mysql-server
systemctl status mysql

wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+buster_all.deb
dpkg -i zabbix-release_5.0-1+buster_all.deb

apt update -y

apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent -y