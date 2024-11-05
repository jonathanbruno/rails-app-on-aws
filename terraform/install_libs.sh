#!/bin/bash

sudo yum update -y

sudo yum install docker -y
sudo usermod -a -G docker ec2-user

sudo systemctl start docker

sudo docker pull

sudo docker run -d -p 3000:3000 -e CLOUD_FRONT_PREFIX=dxrciqvh7zt8i --pull always jonathanbruno/rails-aws-app