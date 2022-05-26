# Kubernates
K8 is a pilot that's responsible for the orchestration of containers.

![](/imgs/Kubernetes-architecture-diagram-1-1.png)

## Summary
kubernetes a tool for managing and automating containerized workloads in the cloud.  

Imagine having an orchestra and think of each individual musician as a docker container, to create beautiful music we need a conductor to manage the musicians and set the tempo.  

Now imagine the conductor as kubernetes and the orchestra as an app like robinhood. When the markets are closed, an app like robinhood isn't doing much, but when they open it needs to fulfill millions of trades.  

K8 is the tool that orchestrates the infrastructure to handle the changing workload. It can scale containers across multiple machines and if one fails it knows how to replace it with a new one.  

A system deployed on kubernetes is known as a **cluster**, the brain of the operation is known as the **control plane**. It exposes an api server that can handle both internal and external requests to manage the cluster. It also contains its own key value database called *ETCD*, used to store important information about running the cluster. 

What it's managing is one or more worker machines called **nodes**. When we hear "node", think of a machine, each **node** is running something called a **cubelet**, which is a tiny application that runs on the machine to communicate back with the main control plane mother ship. Inside of each node we have multiple **pods** which is the smallest deployable unit in kubernetes.  

When we hear **pod** think of a pot of **containers** running together. As the workload increases,  kubernetes can automatically scale horizontally by adding more **nodes** to the cluster. In the process it takes care of complicated things like networking secret management, persistent storage, and so on. It's designed for *high availability*, and one way it achieves that is by maintaining a **replica set**, which is just a set of running pods or containers ready to go at any given time.

We define objects in **yaml** that describe the desired state of our cluster. For example we might have an nginx deployment that has a replica set with three pods in the spec field, we can define exactly how it should behave like its containers volumes, ports, and so on. We can then take this configuration and use it to provision, scale containers automatically, and ensure that they're always up and running and healthy.

## Advantages
- Self healing
- Load balancing and service discovery
- Automated rollouts and rollback
- Auto scaling
- Automatic bin packing
- Storage orchestration

## Installation
Docker desktop > settings > kubernetes > enable kubernetes  

We can check installation by running `kubectl` in the terminal.

## Our Service Architecture

![](/imgs/Screenshot%202022-05-26%20094809.png)

## Command cheat sheet
command | function | options
--- | --- | ---
`kubectl` | this is how we can use kubernetes | [get]<br>[delete]<br>[describe]<br>[create]<br>[edit]<br>etc.
`kubectl cluster-info` | show the information of the cluster
`kubectl create -f <file.yml/dir>` | create services specified within the yaml file
`kubectl get <resource> <name>` | show the summary of existing `resource` specified given `name`
`kubectl delete <resource> <name>` | delete the existing `resource` specified given `name`
`kubectl describe <resource> <name>` | show the details of existing `resource` specified given `name`
`kubectl edit <resource> <name>` | edit the details of existing `resource` specified given `name`

resource example:
- `service`
- `namespace`
- `deploy`
- `pods`
- `replicaset`  

![](/imgs/Screenshot%202022-05-25%20122835.png)

## Usage
1. create yaml file to deploy and create pods
2. create a service
3. connect that service to the pods using selector and matchlabels

## Resources
API: https://kubernetes.io/docs/reference/kubernetes-api/  
Deployment: https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/

