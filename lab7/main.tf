variable "environment" {
  description = "The deployment environment (dev or prod)"
  type        = string
  default     = "dev"
}

variable "departments" {
  description = "List of departments needing buckets"
  type        = set(string)
  default     = ["finance", "engineering", "hr"]
}

# Create a local value to conditionally set a prefix
locals {
  bucket_prefix = var.environment == "prod" ? "mybucket-prod" : "mybucket-dev"
}

# Use a loop to create a bucket for each department
resource "aws_s3_bucket" "department_buckets" {
  for_each = var.departments

  # String interpolation combining the local variable and the loop value
  bucket = "${local.bucket_prefix}-${each.value}-data-2026"

  tags = {
    Environment = upper(var.environment)
    Department  = title(each.value) # Capitalizes the first letter
  }
}

# Output the names of all created buckets using a for loop
output "created_buckets" {
  value = [for bucket in aws_s3_bucket.department_buckets : bucket.bucket]
}
