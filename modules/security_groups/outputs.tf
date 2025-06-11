output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "bi_sg_id" {
  value = aws_security_group.bi_sg.id
}