java_location = Opscode::OpenJDK.new(node).java_location

include_recipe 'java::set_java_home'

if platform_requires_license_acceptance?
  file "/opt/local/.dlj_license_accepted" do
    owner "root"
    group "root"
    mode "0400"
    action :create
    only_if { node['java']['accept_license_agreement'] }
  end
end

node['java']['openjdk_packages'].each do |pkg|
  package pkg do
    action :install
    notifies :run, 'bash[update-java-alternatives]'
  end
end
