variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_path" {}
variable "key_name" {}
variable "instance_username" {}

variable "aws_region" {
  description = "Region for the VPC"
  default = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "0.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "0.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "0.0.0.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-06bcd1131b2f55803"
}
