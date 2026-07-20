
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.0"

  name    = var.cluster_name
  kubernetes_version = "1.36" # Uses a stable Kubernetes version

  # Ensures the cluster API endpoint is accessible to the students
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Grant cluster creator administrative permissions automatically (simplifies lab access)
  enable_cluster_creator_admin_permissions = true

  # EKS Managed Node Groups configuration
  eks_managed_node_groups = {
    lab_nodes = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      # t3.medium provides a good balance of CPU/RAM for student deployments at a low cost
      instance_types = ["t3.medium", "t3a.medium"]
      capacity_type  = "SPOT" # Swap to "SPOT" for even lower lab costs if desired

      labels = {
        Role = "worker-node"
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}



