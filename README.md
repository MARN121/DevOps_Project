# DevOps Final Project – Scalable AWS Infrastructure with Terraform

## 📌 Objective

The objective of this project is to build a scalable, secure, and containerized AWS infrastructure using Terraform. The environment includes Auto Scaling EC2 instances running Nginx, Docker, and Node.js 20, private RDS databases, and an Application Load Balancer with HTTPS support. It also involves deploying multi-stage Dockerized frontend and backend applications, integrating a BI tool (Redash or Metabase), setting up domain and SSL certificates, enabling SSH tunneling for secure database access, and delivering a live-updating dashboard connected to the database.

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

Project/<br>
├── main.tf # 🔧 Root Terraform file to define all modules and infrastructure<br>
├── outputs.tf # 📤 Exposes values like ALB DNS or RDS endpoints<br>
├── providers.tf # 🌍 Configures AWS provider and region<br>
├── terraform.tfvars # 📝 Defines input variables (e.g., domain name, RDS credentials, ACM certs)<br>
├── variables.tf # 📥 Declares input variables and their types<br>
├── README.md # 📘 Documentation and usage guide for the project<br>
├── modules/ # 📦 Reusable, modular Terraform components<br>
│ ├── network/ # 🌐 VPC, subnets, route tables<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf  <br>
│ ├── security_groups/ # 🔒 Security groups for EC2, RDS, and ALB<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ ├── target_group/ # 🎯 Target group to connect EC2 instances with ALB<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ ├── ec2/ # 💻 EC2 Auto Scaling Group for frontend app<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ ├── ec2-bi/ # 📊 EC2 instance for Metabase BI tool<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ ├── rds/ # 🛢️ MySQL and PostgreSQL RDS setup in private subnets<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ ├── alb/ # 🌐 ALB for main application (frontend/backend)<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ ├── alb-bi/ # 🌐 ALB for Metabase BI tool (bi.nendo.fun)<br>
│ │ ├── main.tf<br>
│ │ ├── outputs.tf<br>
│ │ └── variables.tf<br>
│ └── route53/ # 🌍 Route 53 DNS records for app and BI tool<br>
│ ├── main.tf<br>
│ ├── outputs.tf<br>
│ └── variables.tf<br>
├── userdata/ # 🧩 EC2 user data scripts<br>
│ ├── userdata-app.sh # ⚙️ Installs React app with NGINX and Docker<br>
│ └── userdata-bi.sh # 📊 Installs Metabase Docker container<br>
├── docker/ # 🐳 (Optional) Dockerfiles or supporting config if maintained here<br>
└── snapshot-and-destroy.sh # 💥 Script to snapshot RDS DB and run `terraform destroy`<br>

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

1. Clone the repo<br>
   git clone https://github.com/MARN121/reactapp-devops.git #Application Repository <br>

2. Configure your `terraform.tfvars` with:<br>
   project_name = "your-project" #Set Project Name <br>
   domain_name = "XYZ.com" #Domain Name <br>
   hosted_zone_id = "Z01XXXXXX" # Your Route 53 Hosted Zone <br>
   alb_zone_id = "Z35SXDOTRQ7X7K" # ALB Zone ID (us-east-1) <br>
   db_username = "admin" # DB Name <br>
   db_password = "StrongPassword123" # DB Password <br>
   acm_certificate_arn= "arn:aws:acm:..." #ACM Certificate <br>
   key_name = "your-key-pair" #Key Name from Key Pairs <br>
   aws_region = "us-east-1" #AWS Region <br>

3. Initialize and apply:<br>
   terraform init # Initializes Terraform in the current directory <br>
   terraform plan # Shows the execution plan (what Terraform will do) <br>
   terraform apply # Provisions the resources defined in .tf files <br>
   terraform destroy # Destroys all Terraform-managed infrastructure <br>

# 👨‍💻 Author

Muhammad Asad ur Rehman Nadeem <br>
DevOps Final Project @ IBA | 2025 <br>
GitHub: @MARN121 <br>
