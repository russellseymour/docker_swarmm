
name "docker_swarmm"
maintainer "The Authors"
maintainer_email "you@example.com"
license "all_rights"
description "Installs/Configures docker-swarmm"
long_description "Installs/Configures docker-swarmm"
version "0.1.0"

chef_version ">= 12"

issues_url "https://github.com/company/cookbook/issues"
source_url "https://github.com/company/cookbook"

# Set the platforms that this will run on
supports "ubuntu"

# Define the dependencies
depends "docker", "~> 2.15.6"
