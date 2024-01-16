module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.BUCKET_NAME
}

