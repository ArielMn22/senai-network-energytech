#!/bin/bash

apt update -y

apt upgrade -y

apt install default-jre -y

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

apt update -y

apt install jenkins -y

systemctl start jenkins

ufw allow 8080