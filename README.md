# Micro services
Microservices are small applications that the development teams create independently.  

The idea is to split application into a set of smaller, inter-connected services that are:
- Highly maintainable and testable
- loosely coupled
- Independently deployable
- Organised

## What is containerisation?
Containerisation is the idea of packaging a software along with all of its neccessary components, such as all dependencies. 

## What is Docker?
Docker is a tool to manage, create, run containers

## What is the difference between containerisation and virtualisation?
It is different to VMs such that we are not _emulating an operating system_ and then use that VM to perform tasks of running the the software; the containerised image contains all the abstracted and encapsulated information required to run the the application. 

One characteristics of containerisation is that it shares the resourses on the machine running the container instead of reserving the resources.

## What is a Docker image?
Docker image is a snapshot of a container state at one particular timestamp. The state of the container such as codes, files, installed packages and operating system is captured as an immutable state. This immutable state can then be reused to create a container with the exact same state as the image.

## Container lifecycle
Containers can be created from an image, once an container has been created, it can be started, stopped, or removed. Similar to once a song has been written, it can be played, paused, topped or deleted.

## How does docker work?
TODO: Explain docker architecture

### Docker REST API
Docker use the REST API to interact with DockerHub

### Docker Daemon

### Docker client

### Docker host

### Docker Engine

## Why adopt containerisation with Docker?
Docker runs on all operating systems and allow all images to run on all OS as well. Docker excels at abstracting and encapsulating the information of the containers as a very lightweight product. It is particular useful for web applications running on a server or console-based software. Docker is also the biggest market participant, it is being used in over 50% of the companies globally. 

## Docker
Docker is an open source containerization platform. It enables developers to package applications into containers—standardized executable components combining application source code with the operating system (OS) libraries and dependencies required to run that code in any environment.  

command | function | options
--- | --- | ---
`docker ps` | current processes | [-a] show all
`docker images` | bring up all images available to us at the moment
`docker run <image>` | create a container from an image | [-d] detach <br>[-p] port
`docker run -d -p 80:80 nginx` | create a container using a nginx image (docker official image) at the banckground on port 80
`docker run -d -p 90:80 nginx` | port mapping - map from 80 to port 90
`alias docker="winpty docker"` 
`docker exec -it <id> bash` | interact with the container using bash
`cat /usr/share/nginx/html/index.html` | localhost homepage with nginx
`docker stop <id>` | stop the running container
`docker start <id>` | start the running container
`docker rm <id>` | remove the container | [-f] force remove
`docker cp <source> <container_id>:<destination>` | copy file from local to a docker container
`docker cp <container_id>:<source> <destination>` | copy file from docker container to local
`docker cp ~/<path>/index.html <container_id>://usr/share/nginx/html/index.html` | To copy local index.html to container for running a nginx homepage 
`docker login --username=<docker_username>` | login to docker
`docker container commit <container ID> <user_name>/<repo>` | commit an image of a container 
`docker push <user_name>/<repo>:<tag>` | push the image to DockerHub

## Kubernates


