module "network" {
  source        = "./modules/network"
  aws_region    = var.aws_region
  project_name  = var.project_name
  key_name      = var.key_name
}

module "security_groups" {
  source       = "./modules/security_groups"
  vpc_id       = module.network.vpc_id
  project_name = var.project_name
}

module "ec2" {
  source        = "./modules/ec2"
  aws_region    = var.aws_region
  project_name  = var.project_name
  key_name      = var.key_name
  vpc_id        = module.network.vpc_id
  subnet_ids    = module.network.subnet_ids
  sg_id         = module.security_groups.ec2_sg_id 
  target_group_arn = module.target_group.target_group_arn
}

module "rds" {
  source        = "./modules/rds"
  project_name  = var.project_name
  subnet_ids    = module.network.private_subnet_ids
  rds_sg_id     = module.security_groups.rds_sg_id
  db_username   = var.db_username
  db_password   = var.db_password
}

module "target_group" {
  source      = "./modules/target_group"
  project_name = var.project_name
  vpc_id      = module.network.vpc_id
}

module "alb" {
  source               = "./modules/alb"
  project_name         = var.project_name
  subnet_ids           = module.network.public_subnet_ids
  alb_sg_id            = module.security_groups.alb_sg_id
  target_group_arn     = module.target_group.target_group_arn
  domain_name          = var.domain_name
  acm_certificate_arn  = var.acm_certificate_arn
}

module "route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  hosted_zone_id = var.hosted_zone_id
  alb_zone_id = var.alb_zone_id
  zone_id = var.alb_zone_id 
  bi_alb_dns_name = module.alb_bi.alb_dns_name
}

module "bi" {
  source       = "./modules/ec2-bi"
  aws_region   = var.aws_region
  project_name = var.project_name
  key_name     = var.key_name
  subnet_id    = module.network.subnet_ids[0]  # Single subnet
  sg_id        = module.security_groups.bi_sg_id
}

module "alb_bi" {
  source              = "./modules/alb-bi"
  project_name        = var.project_name
  subnet_ids          = module.network.public_subnet_ids
  vpc_id              = module.network.vpc_id
  alb_sg_id           = module.security_groups.alb_sg_id
  acm_certificate_arn = var.acm_certificate_arn
  instance_id = module.bi.instance_id  # This should come from your BI EC2 module
}
