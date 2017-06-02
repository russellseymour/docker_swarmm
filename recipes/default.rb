
# Cookbook Name:: docker-swarmm
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Ensure that docker is installed and running
docker_service "default" do
  action [:create, :start]
end
