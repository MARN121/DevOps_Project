output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "hosted_zone_id" {
  value = var.zone_id
}
