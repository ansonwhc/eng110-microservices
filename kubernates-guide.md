# Kubernates
K8 is a pilot that's responsible for the orchestration of containers.

![](/imgs/Kubernetes-architecture-diagram-1-1.png)

Guide:
- Summary [here](#summary)
- Advantages [here](#advantages)
- Installation [here](#installation)
- Kubernetes Concepts [here](#k8-concepts)
- Our Current Repo Service Architecture [here](#our-current-repo-service-architecture)
- Command cheat sheet [here](#command-cheat-sheet)
- Quick K8 Usage [here](#quick-k8-usage)
- Resources [here](#resources)

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

## K8 Concepts
### K8 Object Construction
- **YAML file**
    - We construct K8 objects by using yaml files
    - There are 4 compulsary fields to every K8 yaml file
    - K8 objects: https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/
    - API conventions: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md
    - Docs: https://kubernetes.io/docs/reference/
        - `apiVersion`
            - version of K8 api are we using for this object 
            - usable API's: `v1`, `app/v1`
            - https://kubernetes.io/docs/concepts/overview/kubernetes-api/
        - `kind`
            - kind of object we are creating
            - Example:
                - Pod
                - Deployment
                - Service
                - Node
        - `metadata`
            - information about the object we care about
            - usable subfields: `name`, `namespace`, `labels`
                - `name` is the name `(str)` of the object
                - `namespace` provides a mechanism for isolating groups of resources within a single cluster
                    - names of resources need to be unique within a namespace
                    - https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
                - `labels` is a dictionary of *customised* key and value pairs that we want to tag onto the object
                    - Example

                            app: MyApp  
                            type: Python  
                            env: Dev  
        - `spec`
            - details on the object that we are creating
            - usable subfields: `containers`
                - for `containers`, we can use subfields of `name`, `image`
                - Example

                        spec:
                        containers:
                            - name: nginx
                            image: nginx

    - Note
        - multiple objects are individually specified in the subfields using `-` 


### Labels
- A field under metadata to identify the object using a key-value pair

### Selector
- A functionality for selecting ojects based on some conditions such as `matchLabels`

### Pods
- Create pods using commands
    - `kubectl run <name> --image=<image>`, to run a pod containing one container using the specified `<image>`

- Create pod yaml files without creating the pod resources
    - `kubectl run <name> --image=<image> --dry-run=client -o yaml`, yaml output
    - `kubectl run <name> --image=<image> --dry-run=client -o yaml > pod-definition.yml`, write the yaml output to a yaml file

- Editing existing pods
    - If we are given a pod definition file, edit that file and use it to create a new pod.
    - If we are not given a pod definition file, we may extract the definition to a file using the below command:
        - ```kubectl get pod <pod-name> -o yaml > pod-definition.yaml```
    - Then edit the file to make the necessary changes, delete and re-create the pod.
        - `kubectl edit pod <pod-name>` to edit pod properties.


### ReplicaSets
- It allows users to have access to the application at all times even when one or some of the pods being down for a short while by auto spawning a replica of the pod.
- It controls replicas within a single node and across multiple nodes
- ReplicationController example:

        apiVersion: v1
        kind: ReplicationController
        metadata: 
            name: myapp-rc
            labels:
            app: myapp
            type:front-end

        spec:
            template:  # a pod template to be used by the replication controller
            metadata:  # metadata of the pod (same as within the yaml file for a pod)
              ... 
            spec:  # spec of the pod (same as within the yaml file for a pod)
              ...

        replicas: 3  # how many replicas to create

- `kubectl get replicationcontroller` to see the replicas

- ReplicaSet example:

        apiversion: apps/v1  # different to ReplicationController
        kind: ReplicaSet
        metadata: 
          name: myapp-replicaset
          labels:
            app:myapp
            type: front-end

        spec:
          template:
            ...  # same logic as the replicationcontroller

        replicas: 3  # same logic as the replicationcontroller
        selector:  # identify what pods fall under this ReplicaSet
          matchLabels:
            type: front-end

- `kubectl get replicaset` to see the replicas

- Update the number of replicas
    1. update the YAML file, run `kubectl replace -f <replicaset-definition>.yml`
    2. `kubectl scale --replicas=<new num> -f <replicaset-definition>.yml`
        - NOTE: `kubectl scale` doesn't update the `<replicaset-definition>.yml`
    3. `kubectl scale --replicas=<new num> <kind> <name (under metadata)>`
        - NOTE: `kubectl scale` doesn't update the `<replicaset-definition>.yml`


### Deployment
- The yaml file setup is similar to the Replicaset one, but specified by `kind: Deployment`
- Create deployments using commands
    - `kubectl create deployment <name> --image=<image>`
    - `kubectl create deployment <name> --image=<image> --dry-run -o yaml > deployment-definition.yml`, write the deployment to a yaml file
    - `kubectl create deployment <name> --image=<image> --replicas=<num_of_replicas>`, specified the number of pod replicas
    - `kubectl scale deployment <name> --replicas=<num_of_replicas>`, scale the number of pod replicas of the deployment, *Note: this doesn't change the yaml file*

- *Rolling update*: when we want to update our deployment one by one instead of altogether to minimise the impact on the application users
- *Rollback*: reverse the recent updates
- *pause* & *resume*: have the changes rollout onto the deployment at the same time

### Service
- A way to create a kubernetes cluster
- Create services using commands
    - Create services of type `ClusterIP` to expose a pod on a port
        - `kubectl expose pod <pod-name> --port=<port> --name <service-anme> --dry-run=client -o yaml`, this will automatically use the `pod's labels` as selectors
        - `kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml`, this will **not** use the pods labels as selectors, instead it will assume selectors as `app=redis`
        - We cannot pass in selectors as an option. So it does not work very well if our pod has a different label set
            - So generate the file and modify the selectors before creating the service

    - Create services of type `NodePort` to expose a pod port on the nodes:
        - `kubectl expose pod <pod-name> --port=<pod-require-port> --name <service-name> --type=NodePort --dry-run=client -o yaml`, the service will run on port `30000 + <pod-require-port>` by default (this will automatically use the pod's labels as selectors, but we cannot specify the node port)
        - `kubectl create service nodeport <name> --tcp=<port-source>:<port-dest> --node-port=<service-port> --dry-run=client -o yaml`
        - Example:
            - `kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml`

### Namespace
It is used to isolate environments, such that different objects can be run seperately in self-contained environments. For example, we might want to have namespaces of `dev` and `prod` to specify the different envrionments.  

- Create a namespace, 
    1. write a yaml file of `apiVersion: v1`, `kind: Namespace`
        - For example:

                apiVersion: v1
                kind: Namespace
                metadata:
                name: dev

                $ kubectl create -f namespace-dev.yml

    2. `$ kubectl create namespace dev`

- Set the current namespace as the default namespace:
    - `kubectl config set-context $9kubectl config current-context) --namespace=dev`
            
- Action within a specific namespace: 
    - `kubectl [action] [object] --namespace=<desired_namespace>`
    - get all namespaces:
        - `kubectl [action] [object] --all-namespaces`
- Put an object in a specific namespace, within a yaml file:

        ...
        metadata:
          name: ...
          namespace: <you_namespace>
          labels:
            ...

### Resource Quota
We can limit our resources usage using a yaml file.
- For example

        apiVersion: v1
        kind: ResourceQuota
        metadata:
          name: compute-quota
          namespace: dev

        spec:
          hard:
            pods: "10"
            requests.cpu: "4"
            requests.memory: 5Gi
            limits.cpu: "10"
            limits.memory: 10Gi

        $ kubectl create -f compute-quota.yml

## Our Current Repo Service Architecture

![](/imgs/Screenshot%202022-05-26%20094809.png)

## Command cheat sheet
Reference: 
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- https://kubernetes.io/docs/reference/kubectl/

command | function | options
--- | --- | ---
`kubectl` | this is how we can use kubernetes | [run]<br>[get]<br>[delete]<br>[describe]<br>[create]<br>[edit]<br>etc.
`kubectl cluster-info` | show the information of the cluster
`kubectl run <pod_name> --image=<image>`
`kubectl create -f <file.yml/dir>` | create services specified within the yaml file
`kubectl get <resource> <name>` | show the summary of existing `resource` specified given `name`
`kubectl delete <resource> <name>` | delete the existing `resource` specified given `name`
`kubectl describe <resource> <name>` | show the details of existing `resource` specified given `name`
`kubectl edit <resource> <name>` | edit the details of existing `resource` specified given `name`

common flags | function | options
--- | --- | ---
`-f or --filename` | direct to a file or files 
`-o or --output` | output the details in different formats | [json]<br>[name]<br>[wide]<br>[yaml]
`--dry-run` | specified how the resource is created | `--dry-run=none` (default): as the command is run, the resource will be created<br>`--dry-run=client`: simply test the command without creating the resource<br>`--dry-run=server`: submit server-side request without persisting the resource
`--image` | specify what image to run
`--namespace` | specify the namespace of the object
`-A or --all-namespaces` | show all specified objects regardless of their namespaces

## Quick K8 Usage
1. create yaml file to deploy and create pods
2. create a service
3. connect that service to the pods using selector and matchlabels

## Resources
API: https://kubernetes.io/docs/reference/kubernetes-api/  
Deployment: https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/

