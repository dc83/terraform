output "arn" {
  description = "ARN of IAM role"
  value       = module.iam_assumable_role_custom_trust_policy.iam_role_arn
}

output "arn_ev" {
  description = "The ARN assigned by AWS to this policy"
  value = "${module.eventbridge.eventbridge_bus_arn}"
}

output "fn_name_snapshot" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.create_instance_snapshot_lambda.lambda_function_name
}

output "fn_name_prune" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.prune_instance_snapshot_lambda.lambda_function_name
}

output "eventbridge_rule_arns" {
  description = "The EventBridge Rule ARNs"
  value       = module.eventbridge.eventbridge_rule_arns
}