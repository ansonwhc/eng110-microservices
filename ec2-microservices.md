# Microservices on EC2

1. start instances

2. install Docker  
`sudo apt-get update -y`  
`sudo apt-get upgrade -y`  
`sudo apt-get install docker.io -y`  
`sudo systemctl status docker`  # check installation  
`docker --version`  # check installation  

3. Iteration 1 - deploy app using docker image
    1. grab image repo:node-app - run the app:
        `sudo docker run -d -p 3000:3000 ansonwhc/eng110-micro-services:node-app`

4. Iteration 2 - deploy app and db using docker-compose
    1. sudo nano `app_db_stack.yml` as [here](app_db_stack.yml)
    2. `sudo apt install docker-compose`
    3. run the yaml `sudo docker-compose app_db_stack.yml up -d`

5. Iteration 3 - use k8 deploy containers as a single node  
    - (minikube requires cpu>=2)  

    `scp -i ~/.ssh/eng119.pem -r ./k8 <user>@<ip>:~/.` (from localhost terminal)

    `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb`  
    `sudo dpkg -i minikube_latest_amd64.deb`   

    ```curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl```

    `chmod +x ./kubectl`
    `sudo mv ./kubectl /usr/local/bin/kubectl`

    `sudo apt-get install conntrack`

    `sudo minikube start --driver=none`
    `sudo kubectl create -f k8/app_db/`
