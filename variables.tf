variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name prefix for all resources"
  type        = string
  default     = "masadrn-devops-project"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "DevOps-TerraformKey"

}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for the ALB"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM SSL certificate"
  type        = string
}

variable "hosted_zone_id" {
  type = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID for the domain"
  type        = string
}

variable "alb_zone_id" {
  type = string
}

