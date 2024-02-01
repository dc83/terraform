module "create_lightsail_snapshots_cloudwatch_invocation_alarm" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch//modules/metric-alarm?ref=d0f3343d631e57e4708c2ebbe7d558fcfdfde57a"
  #version = "5.0.0"

  alarm_name          = "CreateLightSailSnapshotsCloudWatchInvocationAlarm"
  alarm_description   = "This metric triggers if the Lambda function is not triggered as expected."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Invocations"
  threshold           = 1
  period              = "86400" // Seconds
  unit                = "Count"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  alarm_actions       = [var.alarm_actions]

  dimensions = {
    FunctionName = var.fn_snapshot_name
  }
}

module "create_lightsail_snapshots_cloudwatch_error_alarm" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch//modules/metric-alarm?ref=d0f3343d631e57e4708c2ebbe7d558fcfdfde57a"
  #version = "5.0.0"

  alarm_name          = "CreateLightSailSnapshotsCloudWatchErrorAlarm"
  alarm_description   = "This metric triggers if there are any errors logged by Lambda function"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  threshold           = 0
  period              = "86400" // Seconds
  unit                = "Count"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  alarm_actions       = [var.alarm_actions]

  dimensions = {
    FunctionName = var.fn_snapshot_name
  }
}

module "prune_lightsail_snapshots_cloudwatch_invocation_alarm" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch//modules/metric-alarm?ref=d0f3343d631e57e4708c2ebbe7d558fcfdfde57a"
  #version = "5.0.0"

  alarm_name          = "PruneLightSailSnapshotsCloudWatchInvocationAlarm"
  alarm_description   = "This metric triggers if the Lambda function is not triggered as expected."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Invocations"
  threshold           = 1
  period              = "86400" // Seconds
  unit                = "Count"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  alarm_actions       = [var.alarm_actions]

  dimensions = {
    FunctionName = var.fn_prune_name
  }
}

module "prune_lightsail_snapshots_cloudwatch_error_alarm" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch//modules/metric-alarm?ref=d0f3343d631e57e4708c2ebbe7d558fcfdfde57a"
  #version = "5.0.0"

  alarm_name          = "PruneLightSailSnapshotsCloudWatchErrorAlarm"
  alarm_description   = "This metric triggers if there are any errors logged by Lambda function"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  threshold           = 1
  period              = "86400" // Seconds
  unit                = "Count"
  namespace           = "AWS/Lambda"
  statistic           = "Sum"
  alarm_actions       = [var.alarm_actions]

  dimensions = {
    FunctionName = var.fn_prune_name
  }
}
