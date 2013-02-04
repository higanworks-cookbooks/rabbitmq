## smartmachine184 addon

if node[:platform] == 'smartos'
  default['rabbitmq']['version'] = '2.8'
  default['rabbitmq']['er_version'] = '15'
  default['rabbitmq']['ulimit_n'] = 65000
  default['rabbitmq']['root_erlang_cookie_path'] = '/root/.erlang.cookie'
end
