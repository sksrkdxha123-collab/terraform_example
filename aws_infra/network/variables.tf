#variables.tf
variable "region" { type = string }
variable "availability_zone" { type = list(string) }
variable "vpc_cidr_block" { type = string }
variable "public_subnet_cidr_blocks" { type = list(string) }
variable "private_subnet_cidr_blocks" { type = list(string) }
variable "prefix" { type = string }
variable "key_name" { type = string }
variable "instance_type" { type = string }
variable "ami_id" { type = string }