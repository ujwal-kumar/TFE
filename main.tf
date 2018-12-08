# Create VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

}

# Create the Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "ap-south-1a"

}

# Create the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "ap-south-1a"

}

# Create Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

}

# Create route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# Create the Security Group
resource "aws_security_group" "sgweb" {
  name = "vpc_test_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.CIDR}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.CIDR}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.CIDR}"]
  }
    
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["${var.CIDR}"]
  }
    
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
    
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks =  ["${var.CIDR}"]
  }

  vpc_id="${aws_vpc.default.id}"

}

# Create EC2 Instance
resource "aws_instance" "wb" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${var.key_name}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   
   # Copy the file to EC2 instance
   provisioner "file" {
   source="lamp.sh"
   destination="/tmp/lamp.sh"
   }
   
  # Copy the Application Zip file 
   provisioner "file" {
   source="Demo.zip"
   destination="/tmp/Demo.zip"
   }
  
   # Run the script to copy Install LAMP stack and copy the Application file to deployment path
   provisioner "remote-exec" {
      inline=[
     "sleep 300",
     "chmod +x /tmp/lamp.sh",
     "sudo /tmp/lamp.sh"
     ]
   }
  
   # Connecting to the EC2 instance
   connection {
   user="${var.instance_username}"
   private_key="${file("${var.key_path}")}"
   }
}

# Display the Public dns and Public IP
output "aws_instance_public_dns" {
  value = "${aws_instance.wb.public_dns}"
}

output "aws_instance_public_ip" {
  value = "${aws_instance.wb.public_ip}"
}
