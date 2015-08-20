#
# Cookbook Name:: myenv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(emacs tree libXaw-devel).each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/colordiff-1.0.6a-2.el5.noarch.rpm" do
  source "http://dl.fedoraproject.org/pub/epel/5/x86_64/colordiff-1.0.6a-2.el5.noarch.rpm"
  not_if "rpm -qa | grep -q '^colordiff-release'"
  action :create
  notifies :install, "rpm_package[colordiff-release]", :immediately
end

rpm_package "colordiff-release" do
  source "#{Chef::Config[:file_cache_path]}/colordiff-1.0.6a-2.el5.noarch.rpm"
  action :nothing
end

package "colordiff" do
  action :install
end

node["parsonal_environment_users"].each do |user_name|
  home = "/home/#{user_name}"

  directory "#{home}/.rbenv/plugins" do
    owner user_name
    group user_name
    mode "0755"
  end

  git "#{home}/.rbenv/plugins/rbenv-binstubs" do
    repository "git://github.com/ianheggie/rbenv-binstubs.git"
    revision "master"
    user user_name
    group user_name
    action :sync
  end

  git "#{home}/.rbenv/plugins/ruby-build" do
    repository "git://github.com/sstephenson/ruby-build.git"
    revision "master"
    user user_name
    group user_name
    action :sync
  end

  git "#{home}/.rbenv/plugins/rbenv-gem-rehash" do
    repository "git://github.com/sstephenson/rbenv-gem-rehash.git"
    revision "master"
    user user_name
    group user_name
    action :sync
  end

  git "#{home}/dotfiles" do
    repository "https://github.com/swat9013/dotfiles.git"
    revision "master"
    user user_name
    group user_name
    action :sync
  end
end
