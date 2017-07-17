
name "docker_swarmm"
maintainer       "Russell Seymour"
maintainer_email "russell.seymour@turtlesystems.co.uk"
license "All rights reserved"
description "Installs/Configures docker-swarmm"
long_description "Installs/Configures docker-swarmm"
version "0.1.5"

chef_version ">= 12.5" if respond_to?(:chef_version)

issues_url "" if respond_to?(:issues_url)
source_url "" if respond_to?(:source_url)

# Set the platforms that this will run on
supports "ubuntu"

# Define the dependencies
depends "docker", "~> 2.15.6"
