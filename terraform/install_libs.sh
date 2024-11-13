#!/bin/bash

sudo yum update -y

sudo yum install docker -y

sudo systemctl start docker

sudo usermod -aG docker ec2-user

sudo chmod 666 /var/run/docker.sock

sudo docker pull

sudo docker run -d -p 3000:3000 -e CLOUD_FRONT_PREFIX=d3t9ebk0cx7jcb --pull always jonathanbruno/rails-aws-app