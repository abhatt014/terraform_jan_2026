resource "aws_ssm_parameter" "my_param" {
  name  = "/devcore/db/password"
  type  = "SecureString"
  value = "supersecret123"
}

resource "aws_ssm_parameter" "my_other_param" {
  name  = "/devcore/db/user"
  type  = "String"
  value = "admin"
}
