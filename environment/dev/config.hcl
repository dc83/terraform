# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  env         = "dev"
  aws_region  = "us-east-1"
  name        = "flick-loco"
  domain_name = "flickloco.com"
  sms         = "07483846019"
}