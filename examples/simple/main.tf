module "schedule" {
  source = "../../"

  prefix      = var.prefix
  environment = var.environment
  name        = var.name

  schedule_expression         = "cron(0/5 * ? * MON-FRI *)"
  cloudwatch_event_target_arn = "arn:aws:states:us-east-2:556611339911:stateMachine:menual-deo-steps-function"
  input = jsonencode(
    {
      cluster_name   = "oozou-devops-eks-cluster"
      nodegroup_name = "oozou-devops-eks-sabarakata-nodegroup"
      min            = 0,
      max            = 1,
      desired        = 0
      taint_key      = "dedicated"
      taint_value    = "stop"
    }
  )

  role_arn = "arn:aws:iam::556611339911:role/service-role/StepFunctions-menual-deo-steps-function-role-617c576c"

  tags = var.custom_tags
}
