include_recipe "rsync"
include_recipe "openssh"
include_recipe "sudo"

user node['rsnapshot']['client']['username'] do
  comment "System Backup"
  system true
  shell "/bin/bash"

  home "/home/#{node['rsnapshot']['client']['username']}"
  supports({:manage_home => true})
end

directory "/home/#{node['rsnapshot']['client']['username']}/.ssh" do
  owner node['rsnapshot']['client']['username']
  group node['rsnapshot']['client']['username']
  mode "0700"
end

cookbook_file "/home/#{node['rsnapshot']['client']['username']}/.ssh/validate-command.sh" do
  source "validate-command.sh"
  owner "root"
  group "root"
  mode "0755"
end

template "/etc/sudoers.d/rsnapshot" do
  source "rsnapshot.sudoers.erb"
  owner "root"
  group "root"
  mode "0440"
end

ssh_keys = []
search(:node, "roles:#{node['rsnapshot']['server_role']} AND rsnapshot_server_ssh_key:* NOT name:#{node.name}") do |server|
  prefix = "from=\"#{server['ipaddress']}\",command=\"/home/#{node['rsnapshot']['client']['username']}/.ssh/validate-command.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty"
  ssh_keys << "#{prefix} #{server['rsnapshot']['server']['ssh_key']}"
end

template "/home/#{node['rsnapshot']['client']['username']}/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner node['rsnapshot']['client']['username']
  group node['rsnapshot']['client']['username']
  mode "0400"
  variables(
    :ssh_keys => ssh_keys
  )
end
