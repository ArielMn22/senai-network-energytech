#!/bin/bash

echo "Type the Zabbix server IP: "
read SERVER_IP

echo "Hostname: $HOSTNAME"

apt update -y
apt upgrade -y

apt install zabbix-agent -y

cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bkp

echo "Server=$SERVER_IP" >> /etc/zabbix/zabbix_agentd.conf
echo "ServerActive=$SERVER_IP" >> /etc/zabbix/zabbix_agentd.conf
echo "Hostname=$HOSTNAME" >> /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent.service
zabbix_agent -p
