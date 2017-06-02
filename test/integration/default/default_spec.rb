
# Cookbook Name:: docker-swarmm
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# The following are only examples, check out https://github.com/chef/inspec/tree/master/docs
# for everything you can do.

# Check that the docker engine is running
describe service("docker") do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
