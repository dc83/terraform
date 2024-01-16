terraform {
  source = "../../../modules/ec2"
}

include "root" {
  path = find_in_parent_folders()
}
