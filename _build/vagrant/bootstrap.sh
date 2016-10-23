#!/usr/bin/env bash

# Vagrant PHP Development VM Boilerplate
# Copyright (C) 2014-2016  Yannis - Pastis Glaros
# ------------------------------------------
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
#( at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Update apt
apt-get update

#add php 5.5
yes | apt-get install python-software-properties
yes | apt-add-repository ppa:ondrej/apache2
yes | add-apt-repository ppa:ondrej/php5
apt-get update

# Install requirements
apt-get install -y apache2 build-essential checkinstall php5 php5-cli php5-mcrypt php5-gd php-apc git sqlite php5-sqlite curl php5-curl php5-dev php-pear php5-xdebug vim-nox ruby rubygems sqlite3 libsqlite3-dev memcached php5-memcache htop php5-memcached


# Install MySQL
sudo debconf-set-selections <<< 'mysql-server-<version> mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-<version> mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server



# Setup hosts file
VHOST=$(cat <<EOF
    <VirtualHost *:80>
            ServerAdmin info@pramhost.com
            DocumentRoot /var/www/html
            Alias /webgrind /var/www/webgrind


            <Directory />
                    Options FollowSymLinks
		    Require all denied
                    AllowOverride None
            </Directory>

            <Directory /var/www/html/myapp/>
		    Require all granted
                    Options Indexes FollowSymLinks MultiViews
                    AllowOverride All
                    Order allow,deny
                    allow from all
            </Directory>

            DirectoryIndex index.html index.php


    </VirtualHost>

EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/default.conf


# Configure XDebug
XDEBUG=$(cat <<EOF
zend_extension=xdebug.so
xdebug.profiler_enable=1
xdebug.profiler_output_dir="/tmp"
xdebug.profiler_append=0
xdebug.profiler_output_name = "cachegrind.out.%t.%p"
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_host=192.168.2.100
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_log=/tmp/php5-xdebug.log
EOF
)
echo "${XDEBUG}" > /etc/php5/apache2/conf.d/20-xdebug.ini

# Install webgrind if not already present
if [ ! -d /var/www/webgrind ];
then
    git clone https://github.com/jokkedk/webgrind.git /var/www/webgrind
fi


# Install Composer globally
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

#Install pecl memcache
yes | sudo pecl install memcache
echo "extension=memcache.so" | sudo tee /etc/php5/conf.d/memcache.ini

# Enable mod_rewrite
sudo a2enmod rewrite

# Restart Apache
sudo a2dissite *default
sudo a2ensite default
sudo service apache2 reload


# Install latest phpmyadmin
cd /var/www/html
sudo git clone --depth=1 --branch=STABLE git://github.com/phpmyadmin/phpmyadmin.git

# Configure phpMyAdmin
sudo cp /var/www/html/myapp/_build/vagrant/phpmyadmin.php /var/www/html/phpmyadmin/config.inc.php
sudo mysql -uroot -proot < /var/www/html/phpmyadmin/sql/create_tables.sql

# Additional PHP stuff (needs cleanup)
sudo apt-get install -y php5-mysql php5-intl php5-imagick php5-imap php5-ps php5-pspell php5-recode php5-snmp php5-tidy php5-xmlrpc php5-xsl

# Custom php.ini
sudo rm /etc/php5/apache2/php.ini
sudo cp /var/www/html/myapp/_build/vagrant/php.ini /etc/php5/apache2

# Server Name
echo "ServerName localhost" | sudo tee --append /etc/apache2/apache2.conf


# Final apache restart
sudo service apache2 stop
sudo service apache2 start

# Create the database
mysql -uroot -proot < /var/www/html/myapp/_build/vagrant/setup.sql

# Permisions (somehow php tries to write session files in that directory, that is read only)
sudo chmod 1777 /var/lib/php5

# phpUnit
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit
sudo chmod +x /usr/local/bin/phpunit

# And some ascii art
myArt() {
cat <<"EOT"
 ____                      _   _           _
|  _ \ _ __ __ _ _ __ ___ | | | | ___  ___| |_   ___ ___  _ __ ___
| |_) | '__/ _` | '_ ` _ \| |_| |/ _ \/ __| __| / __/ _ \| '_ ` _ \
|  __/| | | (_| | | | | | |  _  | (_) \__ \ |_ | (_| (_) | | | | | |
|_|   |_|  \__,_|_| |_| |_|_| |_|\___/|___/\__(_)___\___/|_| |_| |_|
                                                   www.pramhost.com

EOT
}
myArt
