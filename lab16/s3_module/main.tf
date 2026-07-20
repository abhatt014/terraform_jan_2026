resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-my-devops-bucket"
  tags = {
    Name        = "${var.bucket_name}-my-devops-bucket"
  }
}