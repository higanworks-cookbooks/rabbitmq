#
# Cookbook Name:: rabbitmq
# Recipe:: default_smartos
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2012, Opscode, Inc.
# Copyright 2012, Kevin Nuckolls <kevin.nuckolls@gmail.com>
# Copyright 2013, Yukihiko Sawanobori <sawanoboriyu@higanworks.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when "smartos"

  package "erlang" do
    action :install
    version node['rabbitmq']['er_version']
  end

  package "rabbitmq" do
    action :install
    version node['rabbitmq']['version']
  end

  service 'epmd' do
    action :start
  end

  service node['rabbitmq']['service_name'] do
    action :start
  end

end

template "#{node['rabbitmq']['config_root']}/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

template "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source "rabbitmq.config.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

if File.exists?(node['rabbitmq']['erlang_cookie_path'])
  existing_erlang_key =  File.read(node['rabbitmq']['erlang_cookie_path'])
else
  existing_erlang_key = ""
end

# if node['rabbitmq']['cluster'] and node['rabbitmq']['erlang_cookie'] != existing_erlang_key
if node['rabbitmq']['erlang_cookie'] != existing_erlang_key


  template node['rabbitmq']['erlang_cookie_path'] do
    source "doterlang.cookie.erb"
    owner "rabbitmq"
    group "rabbitmq"
    mode 00400
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end

  ## for rabbitmqctl_cmd
  template node['rabbitmq']['root_erlang_cookie_path'] do
    source "doterlang.cookie.erb"
    owner "root"
    group "root"
    mode 00400
  end

end

