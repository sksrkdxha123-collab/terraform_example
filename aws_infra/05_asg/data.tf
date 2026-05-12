# 1. 태그로 AMI 찾기
data "aws_ami" "was_ami" {
  most_recent = true
  owners      = ["self"] # 내가 만든 AMI 중에서 찾음

  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-instance-ami"]
  }
}

# 2. VPC 및 서브넷 정보
data "aws_vpc" "aws11_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}

data "aws_subnets" "aws11_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.aws11_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-private-*"]
  }
}

data "aws_security_group" "aws11_was_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}

data "aws_iam_instance_profile" "aws11_ec2_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}

data "aws_lb_target_group" "aws11_was_tg" {
  name = "${var.prefix}-alb-was-group"
}