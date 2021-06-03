#!/bin/bash

apt update -y
apt upgrade -y

apt install apache2 -y

service apache2 restart