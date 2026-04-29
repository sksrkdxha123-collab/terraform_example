# aws_infra/alb/data.tf

data "aws_vpc" "aws11_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnets" "aws11_public_subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-public-subnet*"]
  }
}
data "aws_security_group" "aws11_http_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}