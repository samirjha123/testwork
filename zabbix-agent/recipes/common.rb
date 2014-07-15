root_dirs = [
  node['zabbix']['etc_dir'],
]

# Create root folders
case node['platform_family']
when 'windows'
  root_dirs.each do |dir|
    directory dir do
      owner 'Administrator'
      rights :read, 'Everyone', :applies_to_children => true
      recursive true
    end
  end
else
  root_dirs.each do |dir|
    directory dir do
      owner 'root'
      group 'root'
      mode '755'
      recursive true
    end
  end
end
