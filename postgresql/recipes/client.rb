pg_packages = case node['platform']
when "ubuntu","debian"
  %w{postgresql-client libpq-dev}
when "fedora","suse","amazon"
  %w{postgresql-devel}
when "redhat","centos","scientific"
  case
  when node['platform_version'].to_f >= 6.0
    %w{postgresql-devel}
  else
    [ "postgresql#{node['postgresql']['version'].split('.').join}-devel" ]
  end
end

pg_packages.each do |pg_pack|
  package pg_pack do
    action :nothing
  end.run_action(:install)
end

gem_package "pg" do
  action :nothing
end.run_action(:install)
