include_recipe 'opsworks_java::tomcat_service'

template 'tomcat environment configuration' do
  path ::File.join(node['opsworks_java']['tomcat']['system_env_dir'], "tomcat#{node['opsworks_java']['tomcat']['base_version']}")
  source 'tomcat_env_config.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
  notifies :restart, 'service[tomcat]'
end

template 'tomcat server configuration' do
  path ::File.join(node['opsworks_java']['tomcat']['catalina_base_dir'], 'server.xml')
  source 'server.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
  notifies :restart, 'service[tomcat]'
end

directory '/mobs' do
  owner 'tomcat'
  group 'tomcat'
  action :create
end

directory '/uploads' do
  owner 'tomcat'
  group 'tomcat'
  action :create
end

link '/mobs/themes' do
  link_type :symbolic
  to '/usr/share/tomcat7/webapps/ROOT/themes'
  action :create 
end
