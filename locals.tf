locals {
  name                      = format("%s-%s-%s", var.prefix, var.environment, var.name)
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
  # | ab\c | 0 | 1 |
  # |------|---|---|
  # | 00   |   |   |
  # | 01   |   | x |
  # | 11   | x | x |
  # | 10   |   | x |
  a_logic                      = var.input != null
  b_logic                      = var.input_path != null
  c_logic                      = var.input_transformer != null
  raise_task_role_arn_required = (local.a_logic && local.b_logic) || (local.b_logic && local.c_logic) || (local.a_logic && local.b_logic) ? file("Input and Input transformer are conflict together, Please use the only one") : "pass"
}
