#!/bin/bash

sudo yum -y install epel-release phpmyadmin rpm-build redhat-rpm-config;
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm;
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm;
sudo yum -y install httpd mysql-server mysql-devel php php-mysql php-fpm unzip;
sudo chmod 777 -R /var/www/;
sudo cp /tmp/Demo.zip /var/www/html;
cd /var/www/html;
sudo unzip Demo.zip;
sudo rm -rf Demo.zip;
sudo service mysqld restart;
sudo service httpd restart;
sudo chkconfig httpd on;
sudo chkconfig mysqld on;
