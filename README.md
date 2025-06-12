# DevOps Final Project – Scalable AWS Infrastructure with Terraform

## 📌 Objective

Design and deploy a scalable, secure, containerized cloud infrastructure using AWS and Terraform. The solution includes full CI/CD-compatible deployment of a frontend, backend, databases, and a business intelligence (BI) dashboard with domain and SSL support.

---

## 🛠️ Tech Stack

- **Terraform** – Infrastructure as Code
- **AWS** – EC2, RDS, ALB, Route53, ACM, VPC
- **Docker** – App containerization
- **NGINX** – Reverse Proxy
- **Metabase** – BI tool
- **React** – Frontend (dummy)
- **Node.js** – Backend (dummy)
- **PostgreSQL & MySQL** – RDS Databases
- **DBeaver** – DB Client

---

## 📂 Project Structure

Project/
├── main.tf # 🔧 Root Terraform file to define all modules and infrastructure
├── outputs.tf # 📤 Exposes values like ALB DNS or RDS endpoints
├── providers.tf # 🌍 Configures AWS provider and region
├── terraform.tfvars # 📝 Defines input variables (e.g., domain name, RDS credentials, ACM certs)
├── variables.tf # 📥 Declares input variables and their types
├── README.md # 📘 Documentation and usage guide for the project
├── modules/ # 📦 Reusable, modular Terraform components
│ ├── network/ # 🌐 VPC, subnets, route tables
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf  
│ ├── security_groups/ # 🔒 Security groups for EC2, RDS, and ALB
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── target_group/ # 🎯 Target group to connect EC2 instances with ALB
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── ec2/ # 💻 EC2 Auto Scaling Group for frontend app
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── ec2-bi/ # 📊 EC2 instance for Metabase BI tool
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── rds/ # 🛢️ MySQL and PostgreSQL RDS setup in private subnets
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── alb/ # 🌐 ALB for main application (frontend/backend)
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── alb-bi/ # 🌐 ALB for Metabase BI tool (bi.nendo.fun)
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ └── route53/ # 🌍 Route 53 DNS records for app and BI tool
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── userdata/ # 🧩 EC2 user data scripts
│ ├── userdata-app.sh # ⚙️ Installs React app with NGINX and Docker
│ └── userdata-bi.sh # 📊 Installs Metabase Docker container
├── docker/ # 🐳 (Optional) Dockerfiles or supporting config if maintained here
└── snapshot-and-destroy.sh # 💥 Script to snapshot RDS DB and run `terraform destroy`

---

## ✅ Features Implemented

### 1. EC2 Auto Scaling Group

- Launches 2-3 EC2 instances using Launch Template
- Installs Nginx, Docker, Node.js via `userdata.sh`
- Runs frontend and backend apps in Docker containers on different ports

### 2. RDS

- MySQL & PostgreSQL instances in **private subnets**
- Secured via EC2-only security group access

### 3. Load Balancer (ALB)

- HTTPS listener with ACM Certificate
- HTTP-to-HTTPS redirection
- Target groups forward to app ports

### 4. BI Tool – Metabase

- Separate EC2 instance with Metabase running in Docker
- Accessible via `bi.nendo.fun` domain
- Connected to PostgreSQL database

### 5. Domain & SSL

- Registered domain: `nendo.fun`
- Subdomains: `app.nendo.fun`, `appback.nendo.fun`, `bi.nendo.fun`
- DNS managed via Route53
- SSL via AWS ACM

### 6. Database Access

- SSH tunneling used to connect DBeaver & Metabase to private RDS
- Dummy sales data inserted and live-linked to Metabase dashboard

---

## 🔐 Security

- Only ALB allows internet access (ports 80, 443)
- EC2 and RDS communicate internally via SG rules
- No public IPs on RDS instances

---

## 🔄 Cleanup & Persistence (Optional)

- Snapshots taken before `terraform destroy` to preserve Metabase state
- Optional shell script `snapshot-and-destroy.sh` automates snapshot and cleanup

---

## 📊 Dashboard Demo

- Sample dashboard built in Metabase
- Real-time updates shown with new inserts via DBeaver

---

## 🚀 Deployment Instructions

1. Clone the repo
   git clone https://github.com/MARN121/reactapp-devops.git #Application Repository

2. Configure your `terraform.tfvars` with:
   project_name = "your-project" #Set Project Name
   domain_name = "XYZ.com" #Domain Name
   hosted_zone_id = "Z01XXXXXX" # Your Route 53 Hosted Zone
   alb_zone_id = "Z35SXDOTRQ7X7K" # ALB Zone ID (us-east-1)
   db_username = "admin" # DB Name
   db_password = "StrongPassword123" # DB Password
   acm_certificate_arn= "arn:aws:acm:..." #ACM Certificate
   key_name = "your-key-pair" #Key Name from Key Pairs
   aws_region = "us-east-1" #AWS Region

3. Initialize and apply:
   terraform init # Initializes Terraform in the current directory
   terraform plan # Shows the execution plan (what Terraform will do)
   terraform apply # Provisions the resources defined in .tf files
   terraform destroy # Destroys all Terraform-managed infrastructure

# 👨‍💻 Author

Muhammad Asad ur Rehman Nadeem
DevOps Final Project @ IBA | 2025
GitHub: @MARN121
