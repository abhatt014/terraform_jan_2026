module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  name = "devops-vpc"
  cidr = "10.90.0.0/16"
  azs             = ["ap-south-1a"]
  private_subnets = ["10.90.1.0/24"]
  public_subnets  = ["10.90.101.0/24"]
}