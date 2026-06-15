variable "some_data" {
  default = "Alice, BOB, charlie.brown , DAVE  "
}

locals {
  clean_user_list = [for user in split(",", var.some_data) : trimspace(lower(user))]
}

resource "aws_iam_user"   "new_users" {
  for_each = toset(local.clean_user_list)
  name     = each.value
}


output "processed_users" {
  description = "The cleaned list of user accounts created"
  value       = local.clean_user_list
}
