terraform {
  source = "../../..//infrastructure/01_Lightsail"
}

include "config" {
  path           = find_in_parent_folders("config.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  availability_zone = "${include.config.locals.aws_region}a"
  environment       = basename(get_terragrunt_dir())
  name              = "${include.config.locals.name}"
  domain_name       = "${include.config.locals.domain_name}"
}

include {
  path = find_in_parent_folders()
}