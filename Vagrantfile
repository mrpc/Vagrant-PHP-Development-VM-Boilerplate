# Vagrant PHP Development VM Boilerplate
# Copyright (C) 2014  Yannis - Pastis Glaros
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

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.network :private_network, ip: "192.168.2.100"
    config.ssh.forward_agent = true
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 512]
    v.customize ["modifyvm", :id, "--name", "vagrant-php-dev-boilerplate-box"]
  end


  config.vm.synced_folder "./", "/var/www/html/myapp", id: "vagrant-root"
  config.vm.provision :shell, :path => "_build/vagrant/bootstrap.sh"
end