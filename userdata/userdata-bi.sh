#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -aG docker ec2-user
docker run -d -p 3000:3000 --name metabase metabase/metabase
