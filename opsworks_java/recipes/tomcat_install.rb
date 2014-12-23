tomcat_pkgs = value_for_platform_family(
  'debian' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'libtcnative-1'],
  'rhel' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'tomcat-native']
)

if node['opsworks_java']['tomcat']['deploy_manager_apps']
  tomcat_pkgs << value_for_platform(
   %w{ debian ubuntu } => {
    'default' => "tomcat#{node['opsworks_java']['tomcat']['base_version']}-admin",
  }, 
  %w{ centos redhat fedora amazon scientific oracle } => {
    'default' => "tomcat#{node['opsworks_java']['tomcat']['base_version']}-admin-webapps",
  }
  )
end

unless node['opsworks_java']['tomcat']['deploy_manager_apps']
  directory "#{node['opsworks_java']['tomcat']['webapps_base_dir']}/manager" do
    action :delete
    recursive true
  end
  file "#{node['opsworks_java']['tomcat']['catalina_base_dir']}/Catalina/localhost/manager.xml" do
   action :delete
  end
  directory "#{node['opsworks_java']['tomcat']['webapps_base_dir']}/host-manager" do
    action :delete
    recursive true
  end
  file "#{node['opsworks_java']['tomcat']['catalina_base_dir']}/Catalina/localhost/host-manager.xml" do
    action :delete
  end
end

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# remove the ROOT webapp, if it got installed by default
include_recipe 'opsworks_java::remove_root_webapp'
