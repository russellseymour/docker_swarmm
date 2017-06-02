
module DockerSwarmCookbook
  # Class to manager services in the docker swarm cluster
  class DockerSwarmService < DockerSwarmBase
    resource_name :docker_swarm_service

    # Set the default action
    default_action :create

    # Properties for the resource
    property :service_name, String, name_property: true
    property :networks, Array, default: []
    property :image, String
    property :mounts, Array, default: []
    property :user, String, default: ""
    property :environment_vars, Array, default: []
    property :logname, String, default: "json-file"
    property :logfiles, Integer, default: 3
    property :logsize, String, default: "10M"
    property :constraints, Array, default: []
    property :memory, Integer, default: 104_857_600
    property :reservations, Hash, default: {}
    property :restart_condition, String, default: "on-failure"
    property :restart_delay, Integer, default: 1
    property :restart_attempts, Integer, default: 3
    property :replicas, Integer, default: 1
    property :delay, Integer, default: 1
    property :parallelism, Integer, default: 1
    property :failure_action, String, default: "pause"
    property :labels, Array, default: []

    # Set the property for accepting endpoints
    # this will be a string array with the format <proto>,<hostport>,<containerport>
    property :endpoints, Array, default: []

    # Set property that allows options to be passed to the image
    property :options, Array, default: []

    action :create do
      # create an array that will be used to hold the whole command
      cmd_parts = ["docker service create"]
      cmd_parts << format("--name %s", name)

      # iterate around the networks
      networks.each do |network|
        cmd_parts << format("--network %s", network)
      end

      # iterate around the mounts
      unless mounts.empty?
        mounts.each do |mount|
          cmd_parts << format('--mount "%s"', mount)
        end
      end

      # add a user if one has been specified
      cmd_parts << format("--user %s", user) unless user.empty?

      # add any environment variables
      unless environment_vars.empty?
        environment_vars.each do |env_var|
          cmd_parts << format("--env %s", env_var)
        end
      end

      # add contsraints
      unless constraints.empty?
        constraints.each do |constraint|
          cmd_parts << format("--constraint '%s'", constraint)
        end
      end

      # add labels for the container
      unless labels.empty?
        labels.each do |label|
          cmd_parts << format("--label '%s'", label)
        end
      end

      # add publish ports
      unless endpoints.empty?
        endpoints.each do |endpoint|
          cmd_parts << format("--publish %s", endpoint)
        end
      end

      # Add defaulted options
      cmd_parts << format("--replicas %s", replicas)
      cmd_parts << format('"%s"', image)

      # If any options have been set add them to the command
      unless options.empty?
        options.each do |option|
          cmd_parts << option
        end
      end

      # join the cmd_parts
      cmd = cmd_parts.join(" ")

      guard = format('docker service ls --format "{{.Name}}" | grep %s', name)

      execute "create service #{name}" do
        command cmd

        not_if guard
      end
    end
  end
end
