#!/bin/bash

# Update and install required packages
yum update -y
amazon-linux-extras enable epel -y
amazon-linux-extras install docker -y
yum install -y git nginx

# Start and enable services
systemctl enable docker --now
systemctl enable nginx
usermod -aG docker ec2-user

# Clone app
cd /home/ec2-user
git clone https://github.com/MARN121/reactapp-devops.git
chown -R ec2-user:ec2-user reactapp-devops
cd reactapp-devops

# Build Docker image
docker build -t reactapp .

# Run Docker container on internal port (e.g., 3000)
docker run -d -p 3000:80 reactapp

# Configure Nginx reverse proxy to Docker container
cat <<EOF > /etc/nginx/conf.d/reactapp.conf
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Restart Nginx with new config
nginx -t && systemctl restart nginx
