default[:td_agent][:api_key] = ''

default[:td_agent][:plugins] = []

default[:td_agent][:includes] = false
default[:td_agent][:default_config] = true
default[:td_agent][:version] = '1.1.19'
default[:td_agent][:pinning_version] = false
default['td-agent']['log_rotate'] = '31'
default['td-agent']['gem_bin'] = '/usr/lib64/fluent/ruby/bin/fluent-gem'
default['td-agent']['fluent-plugin-dynamodb-atomiccounter']['url'] = 'git://github.com/bageljp/fluent-plugin-dynamodb-atomiccounter.git'
default['td-agent']['fluent-plugin-dynamodb-atomiccounter']['access_key'] = nil
default['td-agent']['fluent-plugin-dynamodb-atomiccounter']['secret_key'] = nil
default['td-agent']['fluent-plugin-dynamodb-atomiccounter']['endpoint'] = 'dynamodb.ap-northeast-1.amazonaws.com'
default['td-agent']['fluent-plugin-dynamodb-atomiccounter']['table'] = nil
default['td-agent']['fluent-plugin-dynamodb-atomiccounter']['interval'] = '5s'