terraform {
  source = "../../..//infrastructure/03_Sns"
}

inputs = {
  sms = "${include.config.locals.sms}"
}

include {
  path = find_in_parent_folders()
}