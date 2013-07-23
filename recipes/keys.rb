#
# Cookbook Name:: manta
# Recipe:: keys
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

user = node["manta"]["user"]
ssh_key = data_bag_item("manta", "keys")
case node['manta']['user']
when "root"
  home_path = ""
else
  home_path = "/home"
end

directory "#{home_path}/#{user}/.ssh" do
  mode 600
end

template "#{home_path}/#{user}/.ssh/#{ssh_key["name"]}" do
  source "key.erb"
  owner user
  mode 0600
  variables :key_content => ssh_key["private_key"]
end

template "#{home_path}/#{user}/.ssh/#{ssh_key["name"]}.pub" do
  source "key.erb"
  owner user
  mode 0600
  variables :key_content => ssh_key["public_key"]
end
