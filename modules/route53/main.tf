# resource "aws_route53_zone" "main" {
#   name = var.domain_name  # "nendo.fun"
# } # New Hosted Zone using TF

resource "aws_route53_record" "app" {
  zone_id = var.hosted_zone_id 
  name = "app.${var.domain_name}"  # app.nendo.fun
  type = "A"
  
  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id  # us-east-1 
    evaluate_target_health = true
  }
}

# A Record for BI Tool — EC2 instance (optional for Metabase)
resource "aws_route53_record" "bi" {
  zone_id = var.hosted_zone_id
  name    = "bi.${var.domain_name}" # bi.nendo.fun
  type    = "A"

  alias {
    name = var.bi_alb_dns_name
    zone_id = var.alb_zone_id 
    evaluate_target_health = true
  }
}
