module DockerSwarmCookbook
  # Docker Master class to configure the manager node
  class DockerSwarmMaster < DockerSwarmBase
    resource_name :docker_swarm_master

    default_action :run

    action :run do
      # Attemnpt to initialise the swarm
      # This will be done with the command line, so will use the execute task
      execute "initialize swarm" do
        command "docker swarm init"

        not_if 'docker node ls'
      end
    end
  end
end
