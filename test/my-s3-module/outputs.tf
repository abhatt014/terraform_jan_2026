output "bucket_arn" {
  description = "The ARN of the newly created S3 bucket"
  value       = aws_s3_bucket.this.arn
}