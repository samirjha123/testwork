include_recipe "yum::epel"

major = platform?("amazon") ? 6 : node['platform_version'].to_i
arch = (node['kernel']['machine'] == "i686" && major == 5) ? "i386" : node['kernel']['machine']
repoforge = node['yum']['repoforge_release']

remote_file "#{Chef::Config[:file_cache_path]}/rpmforge-release-#{repoforge}.el#{major}.rf.#{arch}.rpm" do
  source "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-#{repoforge}.el#{major}.rf.#{arch}.rpm"
  not_if "rpm -qa | grep -q '^rpmforge-release-#{repoforge}'"
  notifies :install, "rpm_package[rpmforge-release]", :immediately
end

rpm_package "rpmforge-release" do
  source "#{Chef::Config[:file_cache_path]}/rpmforge-release-#{repoforge}.el#{major}.rf.#{arch}.rpm"
  only_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/rpmforge-release-#{repoforge}.el#{major}.rf.#{arch}.rpm") }
  action :install
end

file "repoforge-release-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/rpmforge-release-#{repoforge}.el#{major}.rf.#{arch}.rpm"
  action :delete
end
