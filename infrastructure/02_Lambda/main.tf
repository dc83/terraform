data "aws_iam_policy_document" "lambda_role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

module "iam_policy" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-policy?ref=e63dff8de9f6aee7e9ebfbe8c676fa980f5233c0"

  name   = "LamdbaModifyLightsailSnapshotsPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "LightsailFullAccess",
          "Effect": "Allow",
          "Action": [
              "lightsail:*"
          ],
          "Resource": "*"
        },
        {
            "Sid": "LogsFullAccess",
            "Effect": "Allow",
            "Action": "logs:*",
            "Resource": "*"
        }
    ]
}
EOF
}

module "iam_assumable_role_custom_trust_policy" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-assumable-role?ref=e63dff8de9f6aee7e9ebfbe8c676fa980f5233c0"

  create_role                     = true
  role_name                       = "LambdaModifyLightsailSnapshotsRole"
  role_description                = "Policy to Create / Delete Lightsail Snapshots"
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.aws_iam_policy_document.lambda_role.json
  custom_role_policy_arns         = [module.iam_policy.arn]
}

data "archive_file" "create_snapshots_lambda_zip" {
  type        = "zip"
  source_dir  = "../scripts/lightsail-create-instance-snapshots"
  output_path = "lightsail-create-instance-snapshots.zip"
}

data "archive_file" "prune_snapshots_lambda_zip" {
  type        = "zip"
  source_dir  = "../scripts/lightsail-prune-instance-snapshots"
  output_path = "lightsail-prune-instance-snapshots.zip"
}

module "create_instance_snapshot_lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=be31ada3e1330ea3bf7d784edd559980b07eb2c2"
  #version = "6.5.0"

  function_name                           = "createLightSailSnapshots"
  local_existing_package                  = data.archive_file.create_snapshots_lambda_zip.output_path
  depends_on                              = [data.archive_file.create_snapshots_lambda_zip]
  lambda_role                             = module.iam_assumable_role_custom_trust_policy.iam_role_arn
  handler                                 = "index.handler"
  create_current_version_allowed_triggers = false
  runtime                                 = "nodejs20.x"
  source_path                             = "./lightsail-create-instance-snapshots.zip"
  environment_variables = {
    ENV           = var.environment
    INSTANCE_NAME = "lambda-create-snapshot-${var.name}-${var.environment}"
  }

  allowed_triggers = {
    Config = {
      function_name = "createLightSailSnapshots"
      statement_id  = "AllowExecutionFromCloudWatch"
      action        = "lambda:InvokeFunction"
      principal     = "config.amazonaws.com"
      source_arn    = module.eventbridge.eventbridge_rule_arns["crons"]
    }
  }
}

module "prune_instance_snapshot_lambda" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-lambda.git?ref=be31ada3e1330ea3bf7d784edd559980b07eb2c2"
  #version = "6.5.0"

  function_name                           = "pruneLightSailSnapshots"
  local_existing_package                  = data.archive_file.prune_snapshots_lambda_zip.output_path
  depends_on                              = [data.archive_file.prune_snapshots_lambda_zip]
  lambda_role                             = module.iam_assumable_role_custom_trust_policy.iam_role_arn
  handler                                 = "index.handler"
  create_current_version_allowed_triggers = false
  runtime                                 = "nodejs20.x"
  source_path                             = "./lightsail-prune-instance-snapshots.zip"

  //source_code_hash = data.archive_file.prune_snapshots_lambda_zip.output_base64sha256
  environment_variables = {
    ENV              = var.environment
    INSTANCE_NAME    = "lambda-prune-snapshot-${var.name}-${var.environment}"
    RETENTION_PERIOD = "2"
  }
  allowed_triggers = {
    Config = {
      function_name = "pruneLightSailSnapshots"
      statement_id  = "AllowExecutionFromCloudWatch"
      action        = "lambda:InvokeFunction"
      principal     = "config.amazonaws.com"
      source_arn    = module.eventbridge.eventbridge_rule_arns["crons"]
    }
  }
}

module "eventbridge" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eventbridge.git?ref=6d2d61d7ec5781563648937319d018b01d4ddfe6"
  #version = "3.0.0"

  create_bus = false

  rules = {
    crons = {
      name                = "LightsailSnapshotSchedule"
      description         = "Trigger the createLightSailSnapshots and pruneLightSailSnapshots light to modify snapshots."
      schedule_expression = "rate(1 day)"
    }
  }

  targets = {
    crons = [
      {
        name      = "LightsailSnapshotSchedule_create"
        target_id = "TriggerCreateLightsailSnapshots"
        arn       = module.create_instance_snapshot_lambda.lambda_function_arn
        //      is_enabled = false
      },
      {
        name      = "LightsailSnapshotSchedule_prune"
        target_id = "TriggerPruneLightsailSnapshots"
        arn       = module.prune_instance_snapshot_lambda.lambda_function_arn
        //        is_enabled = false
      }
    ],
  }
}
