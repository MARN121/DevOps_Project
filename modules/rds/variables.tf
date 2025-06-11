variable "project_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {
  description = "Security group allowing access from EC2"
  type        = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
  sensitive = true
}
