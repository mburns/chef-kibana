# frozen_string_literal: true

template node['kibana']['service']['template_file'] do
  cookbook node['kibana']['service']['cookbook']
  source node['kibana']['service']['source']
  mode '0o0755'
  variables(
    version: node['kibana']['version'],
    bin_path: node['kibana']['service']['bin_path'],
    options: node['kibana']['service']['options'],
    recent_upstart: (node['platform_family'] != 'rhel')
  )
  notifies :restart, 'service[kibana]', :delayed
end

service 'kibana' do
  provider node['kibana']['service']['provider']
  supports start: true, restart: true, stop: true, status: true
  action %i[enable start]
end

poise_service 'kibana' do
  command "#{node['kibana']['service']['bin_path']}/current/bin/kibana #{node['kibana']['service']['options']}"
  uid node['kibana']['user']
  gid node['kibana']['user']
  options status_port: 8000
end
