#!/bin/bash
# =========================================
# Automated Setup Script for DVWA on Ubuntu
# by Ibnu Hibban
# =========================================

# Update & install dependencies
echo "Updating system and installing packages..."
sudo apt update
sudo apt install apache2 mariadb-server php php-mysqli php-gd git unzip -y

# Enable apache mod_rewrite
echo "Enabling mod_rewrite..."
sudo a2enmod rewrite
sudo systemctl restart apache2

# Configure MariaDB: create database and user
echo "Setting up MariaDB database and user..."
sudo mysql -e "CREATE DATABASE dvwa;"
sudo mysql -e "CREATE USER 'dvwauser'@'localhost' IDENTIFIED BY 'dvwapass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwauser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Clone DVWA
echo "Cloning DVWA into /var/www/html/dvwa..."
cd /var/www/html
sudo git clone https://github.com/digininja/DVWA.git dvwa

# Copy and configure config.inc.php
echo "Configuring DVWA..."
cd dvwa/config
sudo cp config.inc.php.dist config.inc.php

# Replace DB config using sed
sudo sed -i "s/'db_user'.*;/'db_user'     ] = 'dvwauser';/" config.inc.php
sudo sed -i "s/'db_password'.*;/'db_password' ] = 'dvwapass';/" config.inc.php
sudo sed -i "s/'db_database'.*;/'db_database' ] = 'dvwa';/" config.inc.php
sudo sed -i "s/'db_server'.*;/'db_server' ] = '127.0.0.1';/" config.inc.php
sudo sed -i "s/'default_security_level'.*;/'default_security_level' ] = 'low';/" config.inc.php

# Adjust permissions
echo "Setting permissions..."
sudo chmod -R 755 /var/www/html/dvwa
sudo chmod -R 777 /var/www/html/dvwa/hackable/uploads
sudo chmod -R 777 /var/www/html/dvwa/config

# Restart Apache
echo "Restarting Apache server..."
sudo systemctl restart apache2

echo "VWA installation completed!"
echo "Access it via: http://<your-ip>/dvwa/setup.php"
echo "Then click 'Create / Reset Database' to finish."
