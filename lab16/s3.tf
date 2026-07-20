module "s3" {
  source = "./s3_module"
  bucket_name = "112233"
}

output "arn_name" {
  value = module.s3.bucket_arn
}