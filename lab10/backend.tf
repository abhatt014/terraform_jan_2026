terraform {
  backend "s3" {
    bucket         = "devcore-tf-state-unique-1234" # Must match Step 1
    key            = "global/s3/terraform.tfstate"  # The path inside the bucket
    region         = "ap-south-1"
    dynamodb_table = "devcore-tf-locks"             # Must match Step 1
    encrypt        = true                           # Enables S3 encryption
  }
}
