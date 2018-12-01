variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-south-1"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        ap-south-1 = "ami-06bcd1131b2f55803"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "172.32.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "172.32.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "172.32.2.0/24"
}
