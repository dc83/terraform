terraform {
  source = "../../..//infrastructure/02_Lambda"
}

include "config" {
   path           = find_in_parent_folders("config.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  name        = "${include.config.locals.name}"
  environment = "${include.config.locals.env}"
}

include {
  path = find_in_parent_folders()
}