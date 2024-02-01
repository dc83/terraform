module "lightsail" {
  source = "git::https://github.com/clouddrove/terraform-aws-lightsail.git?ref=a93867cceb9995ad72e96fc57e1f3be837ed335f"
  #version = "1.3.1"

  availability_zone    = var.availability_zone
  environment          = var.environment
  name                 = var.name
  label_order          = ["name", "environment"]
  public_key           = var.public_key
  use_default_key_pair = var.use_default_key_pair
  port_info = [
    {
      port     = 80
      protocol = "tcp"
      cidrs    = ["0.0.0.0/0"]
    },
    {
      port     = 22
      protocol = "tcp"
      cidrs    = ["0.0.0.0/0"]
    }
  ]
  create_static_ip = true
}
