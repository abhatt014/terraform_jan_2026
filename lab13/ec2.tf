module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"
  instance_type = "t3.micro"
  key_name      = "terraform_key_pair"
  vpc_security_group_ids = ["sg-0847f2068da1cd8ae"]
  subnet_id = "subnet-01fba3c7389e4292f"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
