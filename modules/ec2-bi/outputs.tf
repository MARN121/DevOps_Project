output "ec2_public_ip" {
  value = aws_instance.metabase_instance.public_ip
}

output "instance_id" {
  value = aws_instance.metabase_instance.id
}
