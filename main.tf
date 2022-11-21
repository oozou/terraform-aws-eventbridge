resource "aws_cloudwatch_event_rule" "this" {
  name                = format("%s-event-rule", local.name)
  description         = var.event_description
  is_enabled          = var.cloudwatch_event_rule_is_enabled
  schedule_expression = var.schedule_expression

  event_pattern = var.event_pattern

  tags = merge(local.tags, { "Name" : format("%s-event-rule", local.name) })
}

resource "aws_cloudwatch_event_target" "this" {

  rule      = aws_cloudwatch_event_rule.this.name
  target_id = var.cloudwatch_event_target_id
  arn       = var.cloudwatch_event_target_arn

  input      = var.input
  input_path = var.input_path
  dynamic "input_transformer" {
    for_each = var.input_transformer != null ? [true] : []

    content {
      input_paths    = var.input_transformer.input_paths
      input_template = var.input_transformer.input_template
    }
  }

  dynamic "retry_policy" {

    for_each = local.is_retry_policy ? [true] : []

    content {
      maximum_retry_attempts       = var.retry_policy.maximum_retry_attempts
      maximum_event_age_in_seconds = var.retry_policy.maximum_event_age_in_seconds
    }
  }

  dynamic "dead_letter_config" {

    for_each = local.is_dead_letter_config_arn ? [true] : []

    content {
      arn = var.dead_letter_config_arn
    }
  }

  role_arn = var.role_arn
}
