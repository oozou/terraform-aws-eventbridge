locals {
  name                      = format("%s-%s-%s", var.prefix, var.environment, var.name)
  is_input_transformer      = var.input_transformer != null ? true : false
  is_retry_policy           = var.retry_policy != null ? true : false
  is_dead_letter_config_arn = var.dead_letter_config_arn != null ? true : false

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}

/* -------------------------------------------------------------------------- */
/*                               Raise Conidtion                              */
/* -------------------------------------------------------------------------- */
locals {
  raise_task_role_arn_required = var.input != null && var.input != var.input_transformer ? file("Input and Input transformer are conflict together, Please use the only one") : "pass"
}