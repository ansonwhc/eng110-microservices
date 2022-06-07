# Microservices
Microservices are small applications that the development teams create independently. Each microservice is responsible for one functionality of the entire application. When all microservices are combined, we have the final software that the end-users interact with.

The idea is to split application into a set of smaller, inter-connected services that are:
- Highly maintainable and testable
- loosely coupled
- Independently deployable
- Organised

Docker guide [here](docker-guide.md)  
Kubernates guide [here](kubernates-guide.md)

## What is containerisation?
Containerisation is the idea of packaging an application along with all of its neccessary components, such as all dependencies, into a small, lightweight, portable, format that can then be run on other machines when those machines do not neccessarily have to have that application preinstalled. By simply running the container on those machines, they will have access to the application as well.

## What is Docker?
Docker is a tool to manage, create, run containers, by using images or Dockerfiles, and can then be used for creating new images. DockerHub is a place where all published, public images created or can be used by docker is located.

## What is the difference between containerisation and virtualisation?
It is different to VMs such that we are not _emulating an compute unit_ and then use that VM to perform tasks of running the the software; the containerised image contains all the abstracted and encapsulated information required to run the the application. 

One characteristics of containerisation is that it shares the resourses on the machine running the container instead of reserving the resources. VMs emulate a computer, down to the hardwares, whereas containers share the resources with the host and only contain the dependencies required for running the application within the container

## What is a Docker image?
Docker image is a snapshot of a container state at one particular timestamp. The state of the container such as codes, files, installed packages and operating system is captured as an immutable state. This immutable state can then be reused to create a container with the exact same state as the image.

## Container lifecycle
Containers can be created from an image, once an container has been created, it can be started, stopped, or removed. Similar to once a song has been written, it can be played, paused, topped or deleted.

<!-- ## How does docker work?
TODO: Explain docker architecture

### Docker REST API
Docker use the REST API to interact with DockerHub

### Docker Daemon

### Docker client

### Docker host

### Docker Engine -->

## Why adopt containerisation with Docker?
Docker runs on all operating systems and allow all images to run on all OS as well. Docker excels at abstracting and encapsulating the information of the containers as a very lightweight product. It is particular useful for web applications running on a server or console-based software. Docker is also the biggest market participant, it is being used in over 50% of the companies globally. 




