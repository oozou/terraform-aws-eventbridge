/* -------------------------------------------------------------------------- */
/*                                   Locals                                   */
/* -------------------------------------------------------------------------- */
locals {
  name                      = format("%s-%s-%s", var.prefix, var.environment, var.name)
  is_retry_policy           = var.retry_policy != null ? true : false
  is_dead_letter_config_arn = var.dead_letter_config_arn != null ? true : false

  is_create_bus = var.bus_name == "default" ? false : true

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}

/* -------------------------------------------------------------------------- */
/*                                  Event Bus                                 */
/* -------------------------------------------------------------------------- */
data "aws_cloudwatch_event_bus" "this" {
  count = local.is_create_bus ? 0 : 1

  name = var.bus_name
}

resource "aws_cloudwatch_event_bus" "this" {
  count = local.is_create_bus ? 1 : 0

  name = var.bus_name
  tags = merge(local.tags, { "Name" = var.bus_name })
}

/* -------------------------------------------------------------------------- */
/*                                 Event Rule                                 */
/* -------------------------------------------------------------------------- */
resource "aws_cloudwatch_event_rule" "this" {
  name                = format("%s-event-rule", local.name)
  description         = var.event_description
  is_enabled          = var.cloudwatch_event_rule_is_enabled
  schedule_expression = var.schedule_expression
  role_arn            = var.role_arn

  event_pattern  = var.event_pattern
  event_bus_name = local.is_create_bus ? aws_cloudwatch_event_bus.this[0].name : var.bus_name

  tags = merge(local.tags, { "Name" : format("%s-event-rule", local.name) })
}

/* -------------------------------------------------------------------------- */
/*                                Event Target                                */
/* -------------------------------------------------------------------------- */
resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = var.cloudwatch_event_target_id
  arn       = var.cloudwatch_event_target_arn
  role_arn  = var.role_arn

  input      = var.input
  input_path = var.input_path
  dynamic "input_transformer" {
    for_each = var.input_transformer != null ? [true] : []

    content {
      input_paths    = var.input_transformer.input_paths
      input_template = var.input_transformer.input_template
    }
  }

  dynamic "run_command_targets" {
    for_each = var.run_command_targets

    content {
      key    = run_command_targets.value.key
      values = run_command_targets.value.values
    }
  }

  dynamic "ecs_target" {
    for_each = lookup(var.cloudwatch_event_target, "ecs_target", null) != null ? [lookup(var.cloudwatch_event_target, "ecs_target", null)] : []

    content {
      group               = lookup(ecs_target.value, "group", null)
      launch_type         = lookup(ecs_target.value, "launch_type", null)
      platform_version    = lookup(ecs_target.value, "platform_version", null)
      task_count          = lookup(ecs_target.value, "task_count", null)
      task_definition_arn = lookup(ecs_target.value, "task_definition_arn", null)

      dynamic "network_configuration" {
        for_each = lookup(ecs_target.value, "network_configuration", null) != null ? [lookup(ecs_target.value, "network_configuration", null)] : []

        content {
          subnets          = lookup(network_configuration.value, "subnets", null)
          security_groups  = lookup(network_configuration.value, "security_groups", null)
          assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
        }
      }
    }
  }

  dynamic "http_target" {
    for_each = lookup(var.cloudwatch_event_target, "http_target", null) != null ? [lookup(var.cloudwatch_event_target, "http_target", null)] : []

    content {
      path_parameter_values   = lookup(http_target.value, "path_parameter_values", null)
      query_string_parameters = lookup(http_target.value, "query_string_parameters", null)
      header_parameters       = lookup(http_target.value, "header_parameters", null)
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
}
