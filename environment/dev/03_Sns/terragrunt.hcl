terraform {
  source = "../../..//infrastructure/03_Sns"
}

include "config" {
  path           = find_in_parent_folders("config.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  sms = "${include.config.locals.sms}"
}

include {
  path = find_in_parent_folders()
}