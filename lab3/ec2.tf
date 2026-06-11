# key pair
resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_key_pair"
  public_key = file("/home/student/.ssh/id_rsa.pub")
}

# Default VPC
# resource "aws_default_vpc" "default" {

# }

# variables for port and protocol
variable "ssh_port" {
    type    = number
  default   = 22
}
variable "app_port" {
    type    = number
  default   = 5000
}
variable "http_port" {
    type    = number
  default   = 80
}
# security group 
resource "aws_security_group" "terraform_security_group" {
  name        = "terraform_security_group"
  description = "Allow SSH http 5000 inbound traffic and all outbound traffic"
  vpc_id      = "vpc-06046eda0ca7a5784"


  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #all protocols tcp or udp
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "terraform_ec2_instance" {
  count         = 2  # 0,1
  ami           = "ami-0685bcc683dadb6b9"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.terraform_key_pair.key_name
  security_groups = [aws_security_group.terraform_security_group.name]
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
    tags = {
        Name = "Terraform-ec2-instance-${count.index + 1}"
    }
}

# print public IP of the instance
output "instance_public_ip" {
  value = aws_instance.terraform_ec2_instance.*.public_ip
}

# sample output  - 
# instance_public_ip = ['<public_ip>']
