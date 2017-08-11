
module DockerSwarmCookbook
  # Docker swarm network class
  class DockerSwarmNetwork < DockerSwarmBase
    resource_name :docker_swarm_network

    # Set the default action
    default_action :create

    # Properties for the resource
    property :network_name, String, name_property: true

    action :create do
      # attempt to create the named network
      execute "create docker network" do
        command format("docker network create --driver overlay %s", new_resource.network_name)

        not_if format('docker network ls --format "{{.Name}}" | grep %s', new_resource.network_name)
      end
    end
  end
end
