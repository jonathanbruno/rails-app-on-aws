#!/bin/bash

sudo yum update -y

sudo yum install docker -y

sudo systemctl start docker

sudo docker pull

sudo docker run -d -p 3000:3000 --pull always jonathanbruno/rails-aws-app