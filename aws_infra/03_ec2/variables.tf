# aws_infra/ec2/variables.tf
variable "region" { type = string }
variable "prefix" { type = string }
variable "key_name" { type = string }
variable "instance_type" { type = string }
variable "ami_id" { type = string }