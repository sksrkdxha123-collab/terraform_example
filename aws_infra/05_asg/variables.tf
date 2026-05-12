# aws_infra/asg/variables.tf
variable "region" { type = string }
variable "prefix" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }