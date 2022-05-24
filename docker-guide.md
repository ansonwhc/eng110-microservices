# Docker
Docker is an open source containerization platform. It enables developers to package applications into containers—standardized executable components combining application source code with the operating system (OS) libraries and dependencies required to run that code in any environment.  

Dockerfile guide [here](#dockerfile)

Command | Function | Options
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

## Dockerfile
Dockerfile is used for creating a new image from a base image. This new image can contain all the abtracted and encapsulated information required for our applications.

1. We need to create a `Dockerfile`  
The reference guide for `Dockerfile`: https://docs.docker.com/engine/reference/builder/

For example:

    $ nano Dockerfile
    > FROM <base_image>
    > LABEL <key>=<value> (optional)
    > WORKDIR /<path>/<to>/<default directory>
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

    > FROM node as app   # name our application as app
    > RUN ...
    > CMD ...

    # make the app available in a production environment
    > FROM node:alpine
    > RUN ...
    > COPY --from=app /<path>/<to>/<app> /<path>/<to>/<app>
    > CMD ...

    $ docker build -t <name>/<repo> .
    # the production ready image is done

    $ docker container commit <image id> <name>/<repo>:prod-ready
    $ docker push <name>/<repo>:prod-ready
