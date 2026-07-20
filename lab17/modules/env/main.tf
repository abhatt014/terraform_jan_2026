# vpc
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

# subnets
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "${var.env_name}-private-subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_name}-public-subnet"
  }
}
# ec2
resource "aws_instance" "public_server" {
    ami = var.user_ami
    instance_type = var.user_instance_type
    subnet_id = aws_subnet.public.id
    tags = {
      Name = "${var.env_name}-public-server"
    }
   
}
resource "aws_instance" "private_server" {
    ami = var.user_ami
    instance_type = var.user_instance_type
    subnet_id = aws_subnet.private.id
    tags = {
      Name = "${var.env_name}-private-server"
    }
   
}