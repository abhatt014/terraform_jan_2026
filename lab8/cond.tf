# key pair
# resource "aws_key_pair" "terraform_key_pair" {
#   key_name   = "terraform_key_pair"
#   public_key = file("/home/student/.ssh/id_rsa.pub")
# }

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
  depends_on = [aws_security_group.terraform_security_group]
  for_each = tomap({
    instance1-micro  = "t3.micro"
    instance2-medium = "t3.medium"
  })
  ami           = "ami-0685bcc683dadb6b9"
  instance_type = each.value
  # key_name        = aws_key_pair.terraform_key_pair.key_name
  security_groups = [aws_security_group.terraform_security_group.name]
  root_block_device {
    volume_size = var.env == "prod" ? var.root_prod_storage_size : var.root_default_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }
}
resource "aws_instance" "test-server" {
  ami           = "ami-0e38835daf6b8a2b9"
  instance_type = "t3.micro"

  tags = {
    Name        = "test-server"
    Environment = "non-prod"

  }
}

# print public IP of the instance
output "instance_public_ip" {
  value = [for instance in aws_instance.terraform_ec2_instance : instance.public_ip]
}

# print public DNS of the instance
output "instance_public_dns" {
  value = [for instance in aws_instance.terraform_ec2_instance : instance.public_dns]
}
