module "marketing_team_bucket" {
  source      = "./my-s3-module"      # Where the blueprint lives
  bucket_name = "acme-corp-marketing" # The input variable
}

module "finance_team_bucket" {
  source      = "./my-s3-module"
  bucket_name = "acme-corp-finance-secure" 
}