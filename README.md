# Micro services
Microservices are small applications that your development teams create independently. Since they communicate via messaging if at all, they're not dependent on the same coding language.  

The idea is to split application into a set of smaller, inter-connected services that are:
- Highly maintainable and testable
- loosely coupled
- Independently deployable
- Organised


## Usage


## Docker
Docker is an open source containerization platform. It enables developers to package applications into containers—standardized executable components combining application source code with the operating system (OS) libraries and dependencies required to run that code in any environment.  

command | function | options
--- | --- | ---
`docker ps` | current processes | [-a] show all
`docker images` | bring up all images available to us at the moment
`docker run <image>` | docker runs an image | [-d] detach <br>[-p] port
`docker run -d -p 80:80 nginx` | run a nginx image (docker official image) at the banckground on port 80
`docker run -d -p 90:80 nginx` | port mapping - map to port 90 from 80 
`alias docker="winpty docker"` 
`docker exec -it <id> bash` | interact with the container using bash
`cat /usr/share/nginx/html/index.html` | localhost homepage with nginx
`docker stop <id>`
`docker start <id>`
`docker rm <id>` | remove the container | [-f] force remove
`docker cp <source> <container_id>:<destination>` | copy file from local to a docker container
`docker cp <container_id>:<source> <destination>` | copy file from docker container to local
`docker cp ~/<path>/index.html <container_id>://usr/share/nginx/html/index.html` | To copy local index.html to container for running a nginx homepage 
`docker login --username=<docker_username>` | login to docker
`docker container commit <container ID> <user_name>/<repo>` | commit a container 
`docker push <user_name>/<repo>:<tag>`

## Kubernates


