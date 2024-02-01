terraform {
    source = "../../..//infrastructure/03_Sns"
}

inputs = {
  sms = "07483846019"
}

include {
    path = find_in_parent_folders()
}