variable "project_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "alb_sg_id" {}
variable "target_group_arn" {}
variable "domain_name" {}
variable "acm_certificate_arn" {}
