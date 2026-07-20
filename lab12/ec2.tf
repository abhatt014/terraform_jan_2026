
# EC2 instance
resource "aws_instance" "terraform_ec2_instance" {
  ami           = "ami-0685bcc683dadb6b9"
  instance_type = "t3.micro"
  user_data = file("steps.sh")
  key_name      = "terraform_key_pair-1"
  security_groups = ["terraform_security_group-1"]
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }
    tags = {
        Name = "${var.env}-Terraform-ec2-instance"
        Environment = var.env
    }
}

# print public IP of the instance
output "webserver_url" {
  value = "http://${aws_instance.terraform_ec2_instance.public_ip}"
}

# sample output  - 
# instance_public_ip = ['<public_ip>']
