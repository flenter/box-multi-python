#
# Cookbook Name:: multi-python
# Recipe:: default
#
# Copyright 2013, Jacco Flenter
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# ["/var/local/nodeenv", "/var/local/sites", "/home/vagrant/switchboard"].each do |dir|
#   directory dir do
#     user "vagrant"
#     group "vagrant"

#     recursive true

#     action :create
#   end
# end



# nodeenv_nodejs "/var/local/nodeenv/#{node[:wercker_devbox][:nodejs]}" do
#   user "vagrant"
#   group "vagrant"

#   node_version node[:wercker_devbox][:nodejs]

#   action :install
# end

# ["ruby1.9.3", "git", "libxml2-dev", "libxslt-dev"].each do |pkg|
#   package pkg do
#     action :install
#   end
# end

# if node[:wercker_devbox][:editor] == "vim"
#   package "vim" do
#     action :install
#   end

#   execute "update-alternatives --set editor /usr/bin/vim.basic" do
#     user "root"
#     action :run
#   end
# end

# if node[:wercker_devbox][:editor] == "nano"
#   execute "update-alternatives --set editor /bin/nano" do
#     user "root"
#     action :run
#   end
# end

# ["jshint", "migrate", "coffee-script", "coffeelint", "nodeunit"].each do |pkg|
#   nodeenv_npm_package pkg do
#     nodeenv "/var/local/nodeenv/#{node[:wercker_devbox][:nodejs]}"
#     global true
#   end
# end

# nodeenv_npm_package "coffee-script" do
#   nodeenv "/var/local/nodeenv/#{node[:wercker_devbox][:nodejs]}"
#   version "1.5"
#   global true
# end

# if node[:wercker_devbox][:use_supervisor] == true
#   nodeenv_npm_package "supervisor" do
#     nodeenv "/var/local/nodeenv/#{node[:wercker_devbox][:nodejs]}"
#     global true
#   end
# end

# script "autoload-nodeenv" do
#   user "vagrant"
#   group "vagrant"
#   interpreter "bash"
#   code <<-EOH
#   echo ". /var/local/nodeenv/#{node[:wercker_devbox][:nodejs]}/bin/activate" >> /home/vagrant/.bashrc
#   touch /home/vagrant/.autoload-nodeenv
#   EOH
#   not_if {File.exists?("/home/vagrant/.autoload-nodeenv")}
# end

["build-essential",
"libncursesw5-dev",
"libreadline-dev",
"libssl-dev",
"libgdbm-dev",
"libc6-dev",
"libsqlite3-dev", #,
"tar",
"wget"
# "tk-dev"
].each do |pkg|
  package pkg do
    action :install
  end
end

version = "3.3.2"
version_short = version[0, version.length - 2]
configure_options = ""


# install python 3.3
remote_file "#{Chef::Config[:file_cache_path]}/Python-#{version}.tar.bz2" do
  source "http://www.python.org/ftp/python/#{version}/Python-#{version}.tar.bz2"
  checksum "7dffe775f3bea68a44f762a3490e5e28"
  mode "0644"
  # not_if { ::File.exists?(install_path) }
end

bash "build-and-install-python" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -jxvf Python-#{version}.tar.bz2
    (cd Python-#{version} && ./configure #{configure_options})
    (cd Python-#{version} && make && make install)
  EOF
  creates "/usr/local/bin/python#{version}"
  # not_if { ::File.exists?(install_path) }
end

remote_file "#{Chef::Config[:file_cache_path]}/setuptools-0.8.tar.gz" do
  source "https://pypi.python.org/packages/source/s/setuptools/setuptools-0.8.tar.gz"
  checksum "7dffe775f3bea68a44f762a3490e5e28"
  mode "0644"
end

bash "setup easy_install" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    cd setuptools-0.8
    python#{version_short} ez_setup.py --user
  EOF
end

version = "2.7.5"
verion_short = version[0, version.length - 2]
configure_options = ""


# install python 2.7
remote_file "#{Chef::Config[:file_cache_path]}/Python-#{version}.tar.bz2" do
  source "http://www.python.org/ftp/python/#{version}/Python-#{version}.tar.bz2"
  checksum "7dffe775f3bea68a44f762a3490e5e28"
  mode "0644"
  # not_if { ::File.exists?(install_path) }
end

bash "build-and-install-python" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -jxvf Python-#{version}.tar.bz2
    (cd Python-#{version} && ./configure #{configure_options})
    (cd Python-#{version} && make && make install)
  EOF
  creates "/usr/local/bin/python#{version}"
  # not_if { ::File.exists?(install_path) }
end

# remote_file "#{Chef::Config[:file_cache_path]}/Python-#{version}.tar.bz2" do
bash "setup easy_install" do
  code <<-EOF
    wget https://bitbucket.org/pypa/setuptools/raw/0.8/ez_setup.py -O - | python#{version_short}
  EOF
end

remote_file "#{Chef::Config[:file_cache_path]}/setuptools-0.8.tar.gz" do
  source "https://pypi.python.org/packages/source/s/setuptools/setuptools-0.8.tar.gz"
  checksum "7dffe775f3bea68a44f762a3490e5e28"
  mode "0644"
end

bash "setup easy_install" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    cd setuptools-0.8
    python#{version_short} ez_setup.py --user
  EOF
end

# easy_install_package "pip" do
#   action :install
# end
