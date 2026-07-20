variable "environment" {
  description = "Environment name for tagging resources"
  type        = string
  default     = "student-lab"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "devops-student-cluster"
}


data "aws_availability_zones" "available" {
  state = "available"

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = "${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  # Uses the first 3 AZs available in the specified region
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Enable a single NAT Gateway to reduce lab costs while allowing private nodes internet access
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Essential tags required by EKS for dynamic load balancer provisioning
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
