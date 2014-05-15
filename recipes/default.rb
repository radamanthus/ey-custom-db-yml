if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  node.engineyard.apps.each do |app|
    ey_cloud_report "Custom database.yml" do
      message "Customizing database.yml for #{app.name}"
    end

    template "/data/#{app.name}/shared/config/database.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      backup false
      mode 0644
      source 'database.yml.erb'
      variables({
        :environment => node['environment']['framework_env'],
        :adapter => 'mysql2',
        :database => node['engineyard']['environment'].first['database_name'],
        :username => node['owner_name'],
        :password => node['owner_pass'],
        :host => node['db_host']
      })
    end
  end
end
