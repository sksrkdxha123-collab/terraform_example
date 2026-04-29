# aws_infra/asg/data.tf
data "aws_vpc" "aws11_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnets" "aws11_private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-private-subnet*"]
  }
}
data "aws_security_group" "aws11_ssh_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-ssh-sg"]
  }
}
data "aws_security_group" "aws11_http_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}
data "aws_iam_instance_profile" "aws11_ec2_instance_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}
data "aws_ami" "aws11_instance" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["${var.prefix}-instance-ami"]
  }
}
data "aws_lb_was_group" "aws11_alb_was_group" {
    name   = "${var.prefix}-alb-was-group" 
}