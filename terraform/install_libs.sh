#!/bin/bash

sudo yum update -y

sudo yum install docker -y

sudo systemctl start docker

sudo docker run -d -p 3000:3000 jonathanbruno/rails-aws-app