java_location = Opscode::OpenJDK.new(node).java_location

include_recipe 'java::set_java_home'

if platform_family?('debian', 'rhel', 'fedora')

  bash 'update-java-alternatives' do
    code <<-EOH.gsub(/^\s+/, '')
      update-alternatives --install /usr/bin/java java #{java_location} 1061 && \
      update-alternatives --set java #{java_location}
    EOH
    action :nothing
  end

end

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
    notifies :run, 'bash[update-java-alternatives]', :immediately if platform_family?('debian', 'rhel', 'fedora')
  end
end
