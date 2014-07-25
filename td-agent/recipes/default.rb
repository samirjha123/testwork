#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2011, Treasure Data, Inc.
#

group 'td-agent' do
  group_name 'td-agent'
  gid        403
  action     [:create]
end

user 'td-agent' do
  comment  'td-agent'
  uid      403
  group    'td-agent'
  home     '/var/run/td-agent'
  shell    '/bin/false'
  password nil
  supports :manage_home => true
  action   [:create, :manage]
end

directory '/etc/td-agent/' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0755'
  action :create
end

directory "/etc/profile.d" do
  owner   "root"
  mode    "0755"
end

template "/etc/profile.d/td-agent.sh" do
  owner   "root"
  mode    "0755"
end

case node['platform']
when "ubuntu"
  dist = node['lsb']['codename']
  source = (dist == 'precise') ? "http://packages.treasure-data.com/precise/" : "http://packages.treasure-data.com/debian/"
  apt_repository "treasure-data" do
    uri source
    distribution dist
    components ["contrib"]
    action :add
  end
when "centos", "redhat", "amazon"
  yum_repository "treasure-data" do
    url "http://packages.treasure-data.com/redhat/$basearch"
    action :add
  end
end

package "td-agent" do
  action :install
end

template "/etc/td-agent/td-agent.conf" do
  mode "0644"
  source "td-agent.conf.erb"
  notifies :restart, 'service[td-agent]'
end

service "td-agent" do
  action [ :enable, :start ]
end

template "/etc/logrotate.d/td-agent" do
  mode "0644"
  source "td-agent.logrotate.erb"
end
