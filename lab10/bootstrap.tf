resource "aws_s3_bucket" "terraform_state" {
  bucket = "devcore-tf-state-unique-1234" # Change this to be globally unique!
  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "devcore-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # This exact string is required by Terraform

  attribute {
    name = "LockID"
    type = "S" # String
  }
}
