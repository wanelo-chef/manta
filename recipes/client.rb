#
# Cookbook Name:: manta
# Recipe:: client
#
# Copyright 2013, Wanelo, Inc
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

include_recipe "nodejs::default"
include_recipe "manta::keys"

npm_package "manta"

user = node["manta"]["user"]
install_path = node["manta"]["install_path"]
ssh_key = data_bag_item("manta", "keys")
manta_user = ssh_key['name']

template "#{install_path}/.manta_config" do
  source "manta_config.erb"
  owner user
  mode 0600
  variables :manta_user => manta_user,
            :user => user,
            :key_name => ssh_key["name"]
end

bash "load manta config from bashrc" do
  code %Q{echo "source ~/.manta_config" >> ~#{user}/.bashrc}
  user user
  not_if "grep .manta_config ~#{user}/.bashrc"
end
