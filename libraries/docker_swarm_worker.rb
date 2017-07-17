require "mixlib/shellout"

module DockerSwarmCookbook
  # Docker Master class to configure the manager node
  class DockerSwarmWorker < DockerSwarmBase
    resource_name :docker_swarm_worker

    default_action :run

    # Get the properties to run with
    property :manager_address, String, name_property: true
    property :worker_token, String, required: true
    property :manager_port, Integer, default: 2377

    action :run do
      # Attempt to join the existing cluster
      execute "join swarm" do
        command format("docker swarm join --token %s %s:%s", worker_token, manager_address, manager_port)

        not_if 'docker info 2>/dev/null | grep "Swarm: active"'
      end
    end
  end
end
