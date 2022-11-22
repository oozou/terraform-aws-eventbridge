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
/* -------------------------------- Event Bus ------------------------------- */
variable "bus_name" {
  description = "A unique name for your EventBridge Bus"
  type        = string
  default     = "default"
}

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
variable "cloudwatch_event_target" {
  description = "A map of objects with EventBridge Target definitions."
  type        = any
  default     = {}
}

variable "cloudwatch_event_target_id" {
  description = "The unique target assignment ID. If missing, will generate a random, unique id."
  type        = string
  default     = null
}

variable "cloudwatch_event_target_arn" {
  description = "The Amazon Resource Name (ARN) associated of the target."
  type        = string
}

variable "role_arn" {
  description = "(Optional) The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. Required if ecs_target is used or target in arn is EC2 instance, Kinesis data stream, Step Functions state machine, or Event Bus in different account or region."
  type        = string
  default     = ""
}

variable "input" {
  description = "Valid JSON text passed to the target. Conflicts with input_path and input_transformer."
  type        = string
  default     = null
}

variable "input_path" {
  description = "(Optional) The value of the JSONPath that is used for extracting part of the matched event when passing it to the target. Conflicts with input and input_transformer."
  type        = string
  default     = null
}

variable "input_transformer" {
  description = <<-EOT
    Parameters used when you are providing a custom input to a target based on certain event data
    example:
    input_transformer = {
    input_paths = {
      severity="$.detail.severity",
      Finding_Type="$.detail.type"
    }
    input_template = "\"You have a severity <severity> GuardDuty finding type <Finding_Type>\""
  }
  EOT
  type = object({
    input_paths    = map(any)
    input_template = string
  })
  default = null
}

variable "event_pattern" {
  description = "(Optional) The event pattern described a JSON object. At least one of schedule_expression or event_pattern is required."
  type        = string
  default     = null
}

variable "retry_policy" {
  description = "(Optional) Parameters used when you are providing retry policies. Documented below. A maximum of 1 are allowed."
  type = object({
    maximum_retry_attempts       = number
    maximum_event_age_in_seconds = number
  })
  default = {
    maximum_retry_attempts       = 100
    maximum_event_age_in_seconds = 3600
  }
}

variable "dead_letter_config_arn" {
  description = "(Optional) Parameters used when you are providing a dead letter config. Documented below. A maximum of 1 are allowed."
  type        = string
  default     = null
}
