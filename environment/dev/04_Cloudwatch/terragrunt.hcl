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
  mock_outputs = {
    fn_name_snapshot = "temporary-function-snapshot"
    fn_name_prune    = "temporary-function-prune"
  }
}

dependency "sns" {
  config_path = "../03_Sns"
  mock_outputs = {
    arn_topic = "arn:aws:sns:eu-west-2:123456789012:myqueue-15PG5C2FC1CW8"
  }
}