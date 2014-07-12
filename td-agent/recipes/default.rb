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

case node['platform']
when "ubuntu"
  dist = node['lsb']['codename']
  source = (dist == 'precise') ? "http://packages.treasuredata.com/precise/" : "http://packages.treasuredata.com/debian/"
  apt_repository "treasure-data" do
    uri source
    distribution dist
    components ["contrib"]
    key "http://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
when "centos", "redhat", "amazon"
  yum_repository "treasure-data" do
    url "http://packages.treasuredata.com/redhat/$basearch"
    gpgkey "http://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
end

template "/etc/td-agent/td-agent.conf" do
  mode "0644"
  source "td-agent.conf.erb"
end

if node['td_agent']['includes']
  directory "/etc/td-agent/conf.d" do
    mode "0755"
  end
end

package "td-agent" do
  if node[:td_agent][:pinning_version]
    action :install
    version node[:td_agent][:version]
  else
    action :upgrade
  end
end

node[:td_agent][:plugins].each do |plugin|
  if plugin.is_a?(Hash)
    plugin_name, plugin_attributes = plugin.first
    td_agent_gem plugin_name do
      plugin true
      %w{action version source options gem_binary}.each do |attr|
        send(attr, plugin_attributes[attr]) if plugin_attributes[attr]
      end
    end
  elsif plugin.is_a?(String)
    td_agent_gem plugin do
      plugin true
    end
  end
end

service "td-agent" do
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/td-agent/td-agent.conf")
end
