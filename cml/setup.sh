#/bin/sh

DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" | sudo tee -a /etc/apt/apt.conf.d/90assumeyes

sudo apt remove unattended-upgrades
systemctl disable apt-daily-upgrade.service

sudo add-apt-repository universe -y
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update && sudo apt-get install -y git
sudo curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh &&
  sudo usermod -aG docker ubuntu
sudo setfacl --modify user:ubuntu:rw /var/run/docker.sock

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt-get install -y terraform

curl -sL https://deb.nodesource.com/setup_12.x | sudo bash
sudo apt update && sudo apt-get install -y nodejs

sudo apt install -y ubuntu-drivers-common git
sudo ubuntu-drivers autoinstall

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update && sudo apt install -y nvidia-docker2 jq moreutils

cat /etc/docker/daemon.json | jq '.+{"default-runtime": "nvidia"}' | sudo sponge /etc/docker/daemon.json

sudo systemctl restart docker

sudo nvidia-smi
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
