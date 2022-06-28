/* -------------------------------------------------------------------------- */
/*                                   Generic                                  */
/* -------------------------------------------------------------------------- */
variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "name" {
  description = "Name of the ECS cluster to create"
  type        = string
}

variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(any)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                              CloudWatch Event                              */
/* -------------------------------------------------------------------------- */
/* ----------------------------- CloudWatch Rule ---------------------------- */
variable "cloudwatch_event_rule_is_enabled" {
  type        = bool
  description = "Whether the rule should be enabled."
  default     = true
}

variable "event_description" {
  description = "The description of the rule."
  type        = string
  default     = ""
}

variable "schedule_expression" {
  description = "(Optional) The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes)"
  type        = string
  default     = null
}

/* ---------------------------- CLoudWatch Target --------------------------- */
variable "cloudwatch_event_target_id" {
  description = "The unique target assignment ID. If missing, will generate a random, unique id."
  type        = string
  default     = null
}

variable "cloudwatch_event_target_arn" {
  description = "The Amazon Resource Name (ARN) associated of the target."
  type        = string
}

variable "input" {
  description = "Valid JSON text passed to the target. Conflicts with input_path and input_transformer."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "(Optional) The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. Required if ecs_target is used or target in arn is EC2 instance, Kinesis data stream, Step Functions state machine, or Event Bus in different account or region."
  type        = string
  default     = ""
}
