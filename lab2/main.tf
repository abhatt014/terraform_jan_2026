# 1. Define the Provider
provider "aws" {
  region = "ap-south-1"
}
# 2. Define the Resource
resource "aws_instance" "my_first_server" {
  ami           = "ami-0685bcc683dadb6b9" # Note: This is an Ubuntu AMI for ap-south-1. AMIs are region-specific!
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Lab-1"
  }
}
