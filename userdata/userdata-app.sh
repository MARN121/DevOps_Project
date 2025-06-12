#!/bin/bash

# Update system packages
yum update -y

# Enable Amazon Linux extras for nginx and install required packages
amazon-linux-extras enable nginx1 -y
yum install -y nginx docker git

# Start and enable Docker service
systemctl enable docker --now
usermod -aG docker ec2-user

# Clone your monorepo (frontend + backend)
cd /home/ec2-user
git clone https://github.com/MARN121/reactapp-devops.git
chown -R ec2-user:ec2-user reactapp-devops
cd reactapp-devops

# --- FRONTEND SETUP ---
cd frontend
docker build -t frontend-app .
docker run -d -p 3000:80 --name frontend-app frontend-app
cd ..

# --- BACKEND SETUP ---
cd backend
docker build -t backend-app .
docker run -d -p 5000:5000 --name backend-app backend-app
cd ..

# --- NGINX CONFIGURATION ---
cat <<EOF > /etc/nginx/conf.d/frontend.conf
server {
    listen 80;
    server_name app.nendo.fun;

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

cat <<EOF > /etc/nginx/conf.d/backend.conf
server {
    listen 80;
    server_name appback.nendo.fun;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Validate and restart NGINX
nginx -t && systemctl enable nginx --now && systemctl restart nginx
