locals {
  # Parse the file path we're in to read the env name: e.g., env will be "dev" in the dev folder, "stage" in the stage folder, etc.
  parsed = regex(".*/environment/(?P<env>.*?)/.*", get_terragrunt_dir())
  env    = local.parsed.env
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket = "example-buckekjkj66767687hjkkt-${local.env}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
    skip_credentials_validation = true
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
 required_providers {
    aws = {
      source = "aws"
      version = "5.33.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
EOF
}