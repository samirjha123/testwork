unless node.recipe?('java::default')
  Chef::Log.warn("Using java::default instead is recommended.")

  # Even if this recipe is included by itself, a safety check is nice...
  [ node['java']['openjdk_packages'], node['java']['java_home'] ].each do |v|
    if v.nil? or v.empty?
      include_recipe "java::set_attributes_from_version"
    end
  end
end

jdk = Opscode::OpenJDK.new(node)

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
  package pkg
end


# We must include this recipe AFTER updating the alternatives or else JAVA_HOME
# will not point to the correct java.
include_recipe 'java::set_java_home'
