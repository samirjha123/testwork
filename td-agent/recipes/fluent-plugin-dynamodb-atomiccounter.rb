#
# Cookbook Name:: td-agent
# Recipe:: fluent-plugin-dynamodb-atomiccounter
#
# Copyright 2013, teamLan Inc.
#

include_recipe 'td-agent::default'

package "git"

bash "dynamodb-atomiccounter-install" do
  cwd "#{Chef::Config[:file_cache_path]}/fluent-plugin-dynamodb-atomiccounter"
  user "root"
  group "root"
  code <<-EOH
    rake
    #{node['td-agent']['gem_bin']} install "pkg/fluent-plugin-dynamodb-atomiccounter-*.gem"
    rm -rf "#{Chef::Config[:file_cache_path]}/fluent-plugin-dynamodb-atomiccounter"
  EOH
  action :nothing
end

git "#{Chef::Config[:file_cache_path]}/fluent-plugin-dynamodb-atomiccounter" do
  repository "#{node['td-agent']['fluent-plugin-dynamodb-atomiccounter']['url']}"
  action :sync
  user "root"
  group "root"
  notifies :run, "bash[dynamodb-atomiccounter-install]", :immediately
  not_if "#{node['td-agent']['gem_bin']} list | grep fluent-plugin-dynamodb-atomiccounter"
end

template "/etc/td-agent/td-agent.conf" do
  mode "0644"
  source "td-agent.conf.fluent-plugin-dynamodb-atomiccounter.erb"
  notifies :restart, 'service[td-agent]'
end
