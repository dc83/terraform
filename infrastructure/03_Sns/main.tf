module "sns" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-sns.git?ref=718832512ecfd0af00311a181537692003ddc1bb"
  #version = "6.0.0"

  name                = "LambdaLightSailSnapshotsSnsTopic"
  create_topic_policy = true
  subscriptions = {
    sms = {
      protocol = "sms"
      endpoint = var.sms
    }
  }
  //tags = local.tags
}