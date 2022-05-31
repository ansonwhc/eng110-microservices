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
    1. Single node  
        `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb`  
        `sudo dpkg -i minikube_latest_amd64.deb`   
        ```curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl```
        `chmod +x ./kubectl`  
        `sudo mv ./kubectl /usr/local/bin/kubectl`  
        `sudo apt-get install conntrack`  
        `sudo minikube start --driver=none`  
        `sudo kubectl create -f k8/app_db_ec2_single_node/`  

    2. Multi-node  
        Reference: 
        - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
        - https://medium.com/geekculture/deploying-multi-node-kubernetes-cluster-on-aws-using-ansible-automation-7d8a5eb25c53
        - https://github.com/kubernetes/kubernetes/issues/70202

        - https://florientdogbe.medium.com/setting-up-kubernetes-multi-node-cluster-on-the-top-of-amazon-ec2-instance-7d3e11336381  
        allow for agent access port, e.g. 6443  

        - create a ***controller*** ec2-instance
        - update & upgrade  
            [ec2-controller ~] `sudo apt-get install update -y`  
            [ec2-controller ~] `sudo apt-get install upgrade -y`  
        - install docker   
            [ec2-controller ~] `sudo apt-get install docker.io -y`
        - install kubeadm, kubelet, kubectl, iproute2
            [ec2-controller ~] `sudo apt-get update`  
            [ec2-controller ~] `sudo apt-get install -y apt-transport-https ca-certificate curl`  
            [ec2-controller ~] `sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg`  
            [ec2-controller ~] `echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list`   
            [ec2-controller ~] `sudo apt-get update`  
            [ec2-controller ~] `sudo apt-get install -y kubelet kubeadm kubectl`   
            [ec2-controller ~] `sudo apt-mark hold kubelet kubeadm kubectl`    
            [ec2-controller ~] `sudo apt-get install iproute2`  
        - set up controller
            [ec2-controller ~] `sudo systemctl restart docker`  
            [ec2-controller ~] `sudo systemctl enable docker`  
            [ec2-controller ~] `sudo systemctl restart kubelet`  
            [ec2-controller ~] `sudo systemctl enable kubelet`  
            [ec2-controller ~] `sudo echo {"exec-opts": ["native.cgroupdriver=systemd"]} >> /etc/docker/daemon.json`  
            [ec2-controller ~] `sudo systemctl restart docker`  
            [ec2-controller ~] `kubeadm init --pod-network-cidr=<VPC CIDR>`  
            [ec2-controller ~] `mkdir -p $HOME/.kube`  
            [ec2-controller ~] `sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`  
            [ec2-controller ~] ```sudo chown $(id -u):$(id -g) $HOME/.kube/config```  
            [ec2-controller ~] `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`  

        - create a ***agent*** ec2-instance
        - update & upgrade  
            [ec2-agent ~] `sudo apt-get install update -y`  
            [ec2-agent ~] `sudo apt-get install upgrade -y`  
        - install docker   
            [ec2-agent ~] `sudo apt-get install docker.io -y`
        - install kubeadm, kubelet, kubectl, iproute2
            [ec2-agent ~] `sudo apt-get update`  
            [ec2-agent ~] `sudo apt-get install -y apt-transport-https ca-certificate curl`  
            [ec2-agent ~] `sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg`  
            [ec2-agent ~] `echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list`   
            [ec2-agent ~] `sudo apt-get update`  
            [ec2-agent ~] `sudo apt-get install -y kubelet kubeadm kubectl`   
            [ec2-agent ~] `sudo apt-mark hold kubelet kubeadm kubectl`    
            [ec2-agent ~] `sudo apt-get install iproute2`  
        - set up agent
            [ec2-agent ~] `sudo systemctl restart docker`  
            [ec2-agent ~] `sudo systemctl enable docker`  
            [ec2-agent ~] `sudo systemctl restart kubelet`  
            [ec2-agent ~] `sudo systemctl enable kubelet`  
            [ec2-agent ~] `sudo echo {"exec-opts": ["native.cgroupdriver=systemd"]} >> /etc/docker/daemon.json`  
            [ec2-agent ~] `sudo systemctl restart docker`  
            [ec2-agent ~] `sudo echo net.bridge.bridge-nf-call-ip6tables = 1 >> /etc/sysctl.d/k8s.conf`  
            [ec2-agent ~] `sudo echo net.bridge.bridge-nf-call-iptables = 1 >> /etc/sysctl.d/k8s.conf`  
            [ec2-agent ~] `sudo sysctl --system`  
        - configure the agent
            [ec2-agent ~] `mkdir -p $HOME/.kube`
            - copy the admin.conf to /.kube/config
                [ec2-controller ~] `sudo cat /etc/kubernetes/admin.conf`  
                copy the output to config  
                [ec2-agent ~] `sudo nano $HOME/.kube/config`  
                [ec2-agent ~/.kube/config] `<paste>`  
            [ec2-agent ~] `sudo nano /run/flannel/subnet.env`

                    FLANNEL_NETWORK=<VPC CIDR>  
                    FLANNEL_SUBNET=<subnet CIDR>  
                    FLANNEL_MTU=1450  
                    FLANNEL_IPMASQ=true  

        - join the host
            [ec2-controller ~] `kubeadm token create  --print-join-command`  
            copy the output
            [ec2-agent ~] `<paste the join instructions>`

