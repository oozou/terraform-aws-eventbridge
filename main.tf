resource "aws_cloudwatch_event_rule" "this" {
  name                = format("%s-event-rule", local.name)
  description         = var.event_description
  is_enabled          = var.cloudwatch_event_rule_is_enabled
  schedule_expression = var.schedule_expression

  tags = merge(local.tags, { "Name" : format("%s-event-rule", local.name) })
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = var.cloudwatch_event_target_id
  arn       = var.cloudwatch_event_target_arn
  input     = var.input

  role_arn = var.role_arn
}
