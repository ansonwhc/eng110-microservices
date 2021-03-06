# Docker
Docker is an open source containerization platform. It enables developers to package applications into containersâ€”standardized executable components combining application source code with the operating system (OS) libraries and dependencies required to run that code in any environment.  

## Content
Command guide - [here](#command-cheat-sheet)  
Dockerfile guide - [here](#dockerfile)  
Production guide - [here](#production)  
Microservices guide - [here](#microservices)  

## Docker ecosystem
- Docker Client (Docker CLI)
    - Tool that we use to send commands to the docker server
- Docker Server (Docker Daemon)
    - Tool that is responsible for creating images, running containers, etc
- Docker Image
    - lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings
- Docker Container
    - Standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another
- Docker Hub
    - Repository of container images with an array of content sources including container community developers, open source projects and independent software vendors (ISV) building and distributing their code in containers
<!-- - Docker Compose
    -  -->
npx create-react-app frontend
## Command cheat sheet
Command | Function | Options
--- | --- | ---
`docker ps` | current processes | [-a] show all
`docker images` | bring up all images available to us at the moment
`docker create <image>` | create a container
`docker start <id>` | start the running container
`docker stop <id>` | stop the running container (if still running after 10s, docker will use `docker kill` automatically)
`socker kill <id>` | kill the running container (similar to force stop)
`docker run <image>` | create and run a container from an image | [-d] detach <br>[-p] port <br>[-v] volume
`docker run -d -p 80:80 nginx` | create a container using a nginx image (docker official image) and run in the banckground on port 80
`docker run -d -p 90:80 nginx` | port mapping - map from 80 to port 90
`docker rm <id>` | remove the container | [-f] force remove
`docker system prune` | remove all stopped containers, networks not used, dagling images. build cache
`docker logs <id>` | show logs of the container
`docker exec <id> <command>` | execute a command in a running container | [-i] interact [-t] allocate a pseudo-TTY
`docker exec -it <id> bash` | interact with the container using bash
`docker cp <source> <container_id>:<destination>` | copy file from local to a docker container
`docker cp <container_id>:<source> <destination>` | copy file from docker container to local
`docker cp ~/<path>/index.html <container_id>://usr/share/nginx/html/index.html` | To copy local index.html to container for running a nginx homepage 
`docker build <dir>` | build a new image | [-t] tag the image
`docker build -t <user_name>/<repo>:<tag> .` | build a new image from the current directory with the specified tag in the repo
`docker login --username=<docker_username>` | login to docker
`docker commit <container ID> <user_name>/<repo>` | commit an image of a container 
`docker push <user_name>/<repo>:<tag>` | push the image to DockerHub
`docker-compose <compose.yml> up` | start containers using the "compose.yml" | [-d] detached mode
`docker-compose <compose.yml> down` | stop containers started with the "compose.yml"

## Dockerfile
Dockerfile is used for creating a new image from a base image. This new image can contain all the abtracted and encapsulated information required for our applications, and then can be used for running a container.

- Structure
    - Specify a base image
    - Run commands to install the required packages and dependencies
    - Command to run on container start-up

1. We need to create a `Dockerfile`  
The reference guide for `Dockerfile`: https://docs.docker.com/engine/reference/builder/

For example:

    $ nano Dockerfile
    > FROM <base_image>
    > LABEL <key>=<value> (optional)
    > WORKDIR /<path>/<to>/<default working directory>
    > COPY <source> <destination>
    > ADD <source> <destination>
    > RUN <command>
    > EXPOSE <port>
    > CMD [<package>, <application>]

    $ docker build -t <user_name>/<repo>:<tags> .`

Official example on building an image for node.js: https://docs.docker.com/language/nodejs/build-images/

2. (Optional) We can create a `.dockerignore` file to ignore particular files or folders when copying from localhost to the container.

For example:  

    $ nano .dockerignore
    > node_modules

## Production
Once the microservice is running as purposed in a development environment, we can use more lightweight base image to put our application onto. This reduces the size of the image and thus more suitable for production.

For example

    $ nano Dockerfile

    # make the app available in a production environment
    > FROM node:alpine as app # name our application as app
    > RUN ...
    > COPY --from=app /<path>/<to>/<app> /<path>/<to>/<app>
    > CMD ...

    $ docker build -t <name>/<repo> .
    # the production ready image is done

    $ docker commit <image id> <name>/<repo>:prod-ready
    $ docker push <name>/<repo>:prod-ready

## Microservices
We can utilise docker-compose to read a .yml file for instructions on how the containers should communicate with each other.

For example, when we want to deploy an application and a database as two separate services, we can set up a stack.yml as shown [here](stack.yml) or below:  

    $ nano stack.yml
    > services:
    
    > mongodb:
    >   image: mongo
    >   restart: always
    >   ports:
    >     - "27017:27017"

    > app:
    >   image: app-image
    >   restart: always
    >   ports:
    >     - "3000:3000"
    >   links:
    >     - mongodb

    # to start
    $ docker-compose -f stack.yml up -d

    # to stop
    $ docker-compose -f stack.yml down
