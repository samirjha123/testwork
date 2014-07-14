include_recipe "yum::epel"
include_recipe "yum::elrepo"
include_recipe "yum::ius"
include_recipe "yum::repoforge"
include_recipe "yum::yum"
include_recipe "yum::remi"

%w{add create}.each do |act|
  file "/etc/yum.repos.d/zenoss-#{act}.repo" do
    action :create
  end

  yum_repository "zenoss-#{act}" do
    description "Zenoss Stable repo"
    url "http://dev.zenoss.com/yum/stable/"
    key "RPM-GPG-KEY-zenoss"
    action act.to_sym
  end
end
