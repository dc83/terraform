include {
    path = "../backend.hcl"
}

terraform {
    source = "git::https://github.com/kunduso/add-aws-elb-ec2-private-subnet-terraform.git?ref=main"
}
inputs = {
    vpc_cidr = "145.90.10.0/24"
    subnet_cidr_private = ["145.90.10.0/27", "145.90.10.32/27", "145.90.10.64/27"]
    subnet_cidr_public = ["145.90.10.96/27", "145.90.10.128/27", "145.90.10.160/27"]
    availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
    instance_type = "t2.small"
}