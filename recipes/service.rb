docker_swarm_network "russell"

docker_swarm_service "portainer" do
  networks [
    "russell",
  ]
  image "portainer/portainer"
  endpoints [
    "9000:9000",
  ]
  mounts [
    "type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock",
  ]

  constraints [
    "node.role == manager",
  ]
end
