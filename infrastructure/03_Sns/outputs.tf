output "arn_topic" {
  description = "The ARN of the SNS topic, as a more obvious property (clone of id)"
  value       = module.sns.topic_arn
}
