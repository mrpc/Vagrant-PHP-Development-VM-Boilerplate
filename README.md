Vagrant PHP Development VM Boilerplate
======================================

A basic configuration for PHP development with vagrant. Based on precise64 box, it adds:

 * Apache 2.4
 * PHP 5.5
 * MySQL 5.5
 * The last version of phpMyAdmin (fetched by git, not the default apt-get version)
 * Composer
 * webgrind
 * The last version of phpUnit
 * An SQL startup file to create your databases etc.
 * A php.ini file and a configuration file for phpMyAdmin

You will find the VM at: http://192.168.2.100
phpMyAdmin: http://192.168.2.100/phpmyadmin
webgrind: http://192.168.2.100/webgrind

Your app will be located at: http://192.168.2.100/myapp

Also, there is a port forwarding, so you can visit http://localhost:8080 on your local machine.

MySQL username and password is root / root.

The default setup.sql script creates database "myApp" to use for your application.

Php.ini, phpMyAdmin configuration file, setup.sql and the provision bash script are all located under the _build/vagrant directory.

This is a good starting point for your projects. Just edit all the files and make your own configuration for your projects.


# Credits:
Inspired/based on [Vagrant PHP Dev Boilerplate](https://github.com/matthewbdaly/vagrant-php-dev-boilerplate) by matthewbdaly.
