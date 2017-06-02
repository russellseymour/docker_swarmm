
# Cookbook Name:: docker-swarmm
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# Recipe to configure the docker master on the machine

# Call custom resource to initialise the master
docker_swarm_master "master node" do
  ipaddress node["ipaddress"]
end
