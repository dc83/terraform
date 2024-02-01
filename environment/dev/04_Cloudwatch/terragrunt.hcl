terraform {
    source = "../../..//infrastructure/04_Cloudwatch"
}

inputs = {
  alarm_actions       = dependency.sns.outputs.arn_top
  fn_snapshot_name       = dependency.lambda.outputs.fn_name_snapshot
  fn_prune_name       = dependency.lambda.outputs.fn_name_prune
}

include {
    path = find_in_parent_folders()
}

dependency "lambda" {
  config_path = "../02_Lambda"
  mock_outputs        = {
    fn_name_snapshot = "sample-sg"
    fn_name_prune = "fn_prune_name"
  }
}

dependency "sns" {
  config_path = "../03_Sns"
  mock_outputs        = {
    arn_top = "arn:aws:sns:eu-west-1:835367859852:my-sns-queue"
  }
}