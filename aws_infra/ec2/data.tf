# aws_infra/ec2/data.tf
data "aws_vpc" "aws11_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnet" "aws11_public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-public-subnet1"]
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