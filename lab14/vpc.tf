data "aws_availability_zones" "available" {
  state = "available"

}

#---new vpc
resource "aws_vpc" "devops-vpc" {
  cidr_block = "10.128.0.0/16"
  tags = {
    Name = "devops-vpc"
  }
}

#---create subnets
resource "aws_subnet" "devops-subnet-public" {
  count                   = 3
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.devops-vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-subnet-public-${count.index + 1}"
  }

}

resource "aws_subnet" "devops-subnet-private" {
  count                   = 3
  vpc_id                  = aws_vpc.devops-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.devops-vpc.cidr_block, 8, count.index + 3)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "devops-subnet-private-${count.index + 1}"
  }

}
#---create ig and nat
resource "aws_internet_gateway" "devops-ig" {
  vpc_id = aws_vpc.devops-vpc.id
  tags = {
    Name = "devops-ig"
  }
}

resource "aws_eip" "devops-nat-eip" {
  domain = "vpc"
  tags = {
    Name = "devops-nat-eip"
  }
}

resource "aws_nat_gateway" "devops-nat-gw" {
  allocation_id = aws_eip.devops-nat-eip.id
  subnet_id     = aws_subnet.devops-subnet-public[0].id
  depends_on    = [aws_internet_gateway.devops-ig]
  tags = {
    Name = "devops-nat-gw"
  }
}


#---route tables
resource "aws_route_table" "devops-public-rt" {
  vpc_id = aws_vpc.devops-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-ig.id
  }
  tags = {
    Name = "devops-public-rt"
  }
}

resource "aws_route_table_association" "devops-public-rt-assoc" {
  count          = 3
  subnet_id      = aws_subnet.devops-subnet-public[count.index].id
  route_table_id = aws_route_table.devops-public-rt.id
}

resource "aws_route_table" "devops-private-rt" {
  vpc_id = aws_vpc.devops-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops-nat-gw.id
  }
  tags = {
    Name = "devops-private-rt"
  }
}

resource "aws_route_table_association" "devops-private-rt-assoc" {
  count          = 3
  subnet_id      = aws_subnet.devops-subnet-private[count.index].id
  route_table_id = aws_route_table.devops-private-rt.id
}

#---create security groups
resource "aws_security_group" "devops-public-sg" {
  name        = "devops-public-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.devops-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "devops-public-sg"
  }
}

resource "aws_security_group" "devops-private-sg" {
  name        = "devops-private-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.devops-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.128.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.128.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "devops-private-sg"
  }
}

#---deploy ec2 instances with testing keypair and use userdata
resource "aws_instance" "devops-instance-public" {
  depends_on             = [aws_vpc.devops-vpc, aws_nat_gateway.devops-nat-gw]
  count                  = 3
  ami                    = "ami-0685bcc683dadb6b9"
  instance_type          = "t3.micro"
  key_name               = "testing"
  subnet_id              = aws_subnet.devops-subnet-public[count.index].id
  vpc_security_group_ids = [aws_security_group.devops-public-sg.id]
  user_data              = <<-EOF
                #!/bin/bash
                # Install httpd
                sudo dnf install -y httpd
                # Start and enable httpd
                sudo systemctl enable --now httpd
                EOF
  tags = {
    Name = "devops-instance-public-${count.index + 1}"
  }
}

resource "aws_instance" "devops-instance-private" {
  depends_on             = [aws_vpc.devops-vpc, aws_nat_gateway.devops-nat-gw]
  count                  = 3
  ami                    = "ami-0685bcc683dadb6b9"
  instance_type          = "t3.micro"
  key_name               = "testing"
  subnet_id              = aws_subnet.devops-subnet-private[count.index].id
  vpc_security_group_ids = [aws_security_group.devops-private-sg.id]
  user_data              = <<-EOF
                #!/bin/bash
                # Install httpd
                sudo dnf install -y httpd
                # Start and enable httpd
                sudo systemctl enable --now httpd
                EOF
  tags = {
    Name = "devops-instance-private-${count.index + 1}"
  }
}

#---outputs for the public and private ip addresses of the instances
output "public_ips" {
  value = [for instance in aws_instance.devops-instance-public : instance.public_ip]
}
output "private_ips" {
  value = [for instance in aws_instance.devops-instance-private : instance.private_ip]
}