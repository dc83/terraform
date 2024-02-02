terraform {
  source = "../../..//infrastructure/04_Cloudwatch"
}

inputs = {
  alarm_actions    = dependency.sns.outputs.arn_topic
  fn_snapshot_name = dependency.lambda.outputs.fn_name_snapshot
  fn_prune_name    = dependency.lambda.outputs.fn_name_prune
}

include {
  path = find_in_parent_folders()
}

dependency "lambda" {
  config_path = "../02_Lambda"
}

dependency "sns" {
  config_path = "../03_Sns"
}