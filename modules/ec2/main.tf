resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  user_data = base64encode(file("${path.module}/../../userdata/userdata-app.sh"))

  vpc_security_group_ids = [var.sg_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-ec2"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.project_name}-asg"
  max_size                  = 3
  min_size                  = 3
  desired_capacity          = 3
  vpc_zone_identifier       = var.subnet_ids

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
