output "aws_cloudwatch_event_rule_id" {
  description = "The name of the rule"
  value       = aws_cloudwatch_event_rule.this.id
}

output "aws_cloudwatch_event_rule_arn" {
  description = "The Amazon Resource Name (ARN) of the rule."
  value       = aws_cloudwatch_event_rule.this.arn
}
