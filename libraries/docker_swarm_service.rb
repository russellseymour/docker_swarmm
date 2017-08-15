
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
    property :hostname, String, default: ""

    # Set the property for accepting endpoints
    # this will be a string array with the format <proto>,<hostport>,<containerport>
    property :endpoints, Array, default: []
    property :endpoint_mode, String, default: "vip"

    # Set how the service is to be created
    property :mode, String, default: "replicated"

    # Allow username and password to perform a login first and then user
    # the --with-registry-auth flag on the main service command
    property :username, String, default: ""
    property :password, String, default: ""

    # Specify what command should be run
    property :command, String, default: ""

    # Set property that allows options to be passed to the image
    property :options, Array, default: []

    action :create do

      # Create the array of commands
      cmd_parts = []

      # If the username and password have been set then perform a login
      # to the specified registry image
      registry_auth = false
      unless new_resource.username.empty? && new_resource.password.empty?
        
        # Determine the registry url
        registry_url = format("https://%s", new_resource.image.split(/\//)[0])
        cmd_parts << format("docker login -u %s -p %s %s; ", new_resource.username, new_resource.password, registry_url)
        registry_auth = true
      end

      # create an array that will be used to hold the whole command
      cmd_parts << "docker service create"
      cmd_parts << format("--name %s", new_resource.name)

      # iterate around the networks
      new_resource.networks.each do |network|
        cmd_parts << format("--network %s", network)
      end

      # iterate around the mounts
      unless new_resource.mounts.empty?
        new_resource.mounts.each do |mount|
          cmd_parts << format('--mount "%s"', mount)
        end
      end

      # add a user if one has been specified
      cmd_parts << format("--user %s", new_resource.user) unless new_resource.user.empty?

      # Set the hostname if it has been specified
      cmd_parts << format("--hostname %s", new_resource.hostname) unless new_resource.hostname.empty?

      # add any environment variables
      unless new_resource.environment_vars.empty?
        new_resource.environment_vars.each do |env_var|
          cmd_parts << format("--env %s", env_var)
        end
      end

      # add contsraints
      unless new_resource.constraints.empty?
        new_resource.constraints.each do |constraint|
          cmd_parts << format("--constraint '%s'", constraint)
        end
      end

      # add labels for the container
      unless new_resource.labels.empty?
        new_resource.labels.each do |label|
          cmd_parts << format("--label '%s'", label)
        end
      end

      # add publish ports
      unless new_resource.endpoints.empty?
        new_resource.endpoints.each do |endpoint|
          cmd_parts << format("--publish %s", endpoint)
        end
      end

      # Add the regsitry auth if it has been set
      cmd_parts << "--with-registry-auth" if registry_auth

      # Add defaulted options
      cmd_parts << format("--endpoint-mode %s", new_resource.endpoint_mode)
      cmd_parts << format("--mode %s", new_resource.mode)

      # Only add replicas if the mode is set correctly
      cmd_parts << format("--replicas %s", new_resource.replicas) if new_resource.mode == "replicated"

      cmd_parts << format('"%s"', new_resource.image)

      # If a command has been specified, add it here
      cmd_parts << new_resource.command unless new_resource.command.empty?

      # If any options have been set add them to the command
      unless new_resource.options.empty?
        new_resource.options.each do |option|
          cmd_parts << option
        end
      end

      # join the cmd_parts
      cmd = cmd_parts.join(" ")

      guard = format('docker service ls --format "{{.Name}}" | grep %s', new_resource.name)

      execute "create service #{new_resource.name}" do
        command cmd

        not_if guard
      end
    end
  end
end
