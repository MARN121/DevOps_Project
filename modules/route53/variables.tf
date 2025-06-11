variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
  description = "The Route53 hosted zone ID for the domain"
}

variable "alb_zone_id" {
  type = string
  description = "The hosted zone ID of the ALB for alias records"
}

variable "bi_alb_dns_name" {
  description = "DNS name for the BI ALB"
  type        = string
}
