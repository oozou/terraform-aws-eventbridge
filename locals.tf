locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}
