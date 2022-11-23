locals {
  name         = format("%s-%s-%s", var.prefix, var.environment, var.name)
  service_name = substr("${local.name}", 0, min(29, length(local.name)))
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.custom_tags
  )
}
data "aws_caller_identity" "this" {}

module "vpc" {
  source       = "oozou/vpc/aws"
  version      = "1.2.4"
  prefix       = var.prefix
  environment  = var.environment
  account_mode = "spoke"

  cidr              = "172.17.171.0/24"
  public_subnets    = ["172.17.171.0/27", "172.17.171.32/27"]
  private_subnets   = ["172.17.171.128/26", "172.17.171.192/26"]
  database_subnets  = ["172.17.171.64/27", "172.17.171.96/27"]
  availability_zone = ["ap-southeast-1b", "ap-southeast-1c"]

  is_create_nat_gateway             = true
  is_enable_single_nat_gateway      = true
  is_enable_dns_hostnames           = true
  is_enable_dns_support             = true
  is_create_flow_log                = true
  is_enable_flow_log_s3_integration = false

  tags = var.custom_tags
}

module "fargate_cluster" {
  source  = "oozou/ecs-fargate-cluster/aws"
  version = "1.0.6"

  # Generics
  prefix      = var.prefix
  environment = var.environment
  name        = var.name

  # IAM
  allow_access_from_principals = [data.aws_caller_identity.this.account_id]

  # VPC Information
  vpc_id = module.vpc.vpc_id

  # ALB
  is_public_alb                  = true
  is_ignore_unsecured_connection = true
  alb_listener_port              = 80
  public_subnet_ids              = module.vpc.public_subnet_ids

  # ALB's DNS Record
  is_create_alb_dns_record = false # Default is `true`

  tags = var.custom_tags
}

/* -------------------------------------------------------------------------- */
/*                               Fargate service                              */
/* -------------------------------------------------------------------------- */
module "nginx" {
  source  = "oozou/ecs-fargate-service/aws"
  version = "v1.1.8"

  # Generics
  prefix      = var.prefix
  environment = var.environment
  name        = format("%s-nginx-service", var.name)

  # ALB
  is_attach_service_with_lb = true
  alb_listener_arn          = module.fargate_cluster.alb_listener_http_arn
  alb_paths                 = ["/"]
  alb_priority              = 100

  ## Target group that listener will take action
  vpc_id                            = module.vpc.vpc_id
  target_group_deregistration_delay = 10
  health_check = {
    interval            = 45
    path                = "/"
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }

  # Logging
  is_create_cloudwatch_log_group = true

  # Task definition
  service_info = {
    cpu_allocation = 256,
    mem_allocation = 512,
    port           = 80,
    image          = "nginx"
    mount_points   = []
  }

  # ECS service
  ecs_cluster_name            = module.fargate_cluster.ecs_cluster_name
  service_discovery_namespace = module.fargate_cluster.service_discovery_namespace
  is_enable_execute_command   = true
  application_subnet_ids      = module.vpc.private_subnet_ids
  security_groups             = [module.fargate_cluster.ecs_task_security_group_id]

  tags = var.custom_tags
}

/* -------------------------------------------------------------------------- */
/*                                 EventBridge                                */
/* -------------------------------------------------------------------------- */
resource "aws_ecs_task_definition" "spin_nginx" {
  family                   = "nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 1024

  container_definitions = <<EOF
[
  {
    "cpu": 256,
    "essential": true,
    "image": "nginx:latest",
    "memory": 512,
    "name": "nginxx"
  }
]
EOF
}

data "aws_iam_policy_document" "daily_report_eventbridge_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "daily_report_eventbridge_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:RunTask",
    ]
    resources = [
      "${replace(aws_ecs_task_definition.spin_nginx.arn, "/:\\d+$/", ":*")}",
      "${replace(aws_ecs_task_definition.spin_nginx.arn, "/:\\d+$/", "")}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "daily_report_eventbridge_role" {
  name                = format("%s-daily-report-evenbridge-role", local.name)
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.daily_report_eventbridge_assume_role_policy.json
  managed_policy_arns = null
  inline_policy {
    name   = format("%s-daily-report-evenbridge-inline-policy", local.name)
    policy = data.aws_iam_policy_document.daily_report_eventbridge_policy.json
  }
}

module "ecs_event" {
  source = "../../"

  prefix      = var.prefix
  environment = var.environment
  name        = var.name

  event_pattern = jsonencode({
    "source" : [
      "aws.s3"
    ],
    "detail-type" : [
      "Object Created"
    ],
    "account" : [
      "855546030651"
    ],
    "resources" : [
      "arn:aws:s3:::sbth-dev-cms-private-bucket-855546030651-hf5q7g"
    ],
    "detail" : {
      "bucket" : {
        "name" : [
          "sbth-dev-cms-private-bucket-855546030651-hf5q7g"
        ]
      },
      "object" : {
        "key" : [
          {
            "prefix" : "daily_report"
          }
        ]
      }
    }
  })
  cloudwatch_event_target_arn = module.fargate_cluster.ecs_cluster_arn
  role_arn                    = aws_iam_role.daily_report_eventbridge_role.arn
  cloudwatch_event_target = {
    ecs_target = {
      task_count          = 1
      task_definition_arn = replace(aws_ecs_task_definition.spin_nginx.arn, "/:\\d+$/", "")
      launch_type         = "FARGATE"
      network_configuration = {
        subnets         = module.vpc.private_subnet_ids
        security_groups = [module.fargate_cluster.ecs_task_security_group_id]
      }
    }
  }

  tags = var.custom_tags
}
