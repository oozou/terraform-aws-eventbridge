data "aws_caller_identity" "this" {}

module "lambda" {
  source  = "oozou/lambda/aws"
  version = "1.1.2"

  prefix      = var.prefix
  environment = var.environment
  name        = "demo"

  is_edge = false

  # Source code
  source_code_dir           = "./src"
  file_globs                = ["main.py"]
  compressed_local_file_dir = "./outputs"

  # Lambda Env
  runtime = "python3.8"
  handler = "main.handler"

  # IAM
  additional_lambda_role_policy_arns = {}

  # Resource policy
  lambda_permission_configurations = {
    allow_trigger_from_eventbridge = {
      pricipal = "events.amazonaws.com"
      # source_arn     = "(Optional)" # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html
      source_account = data.aws_caller_identity.this.account_id
    }
  }

  tags = var.custom_tags
}

module "schedule" {
  source = "../../"

  prefix      = var.prefix
  environment = var.environment
  name        = var.name

  schedule_expression = "cron(0/5 * ? * MON-FRI *)"
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

  cloudwatch_event_target_arn = module.lambda.arn

  tags = var.custom_tags
}
