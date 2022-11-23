<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.0.0 |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.40.0  |

## Modules

| Name                                                                                | Source                        | Version |
|-------------------------------------------------------------------------------------|-------------------------------|---------|
| <a name="module_ecs_event"></a> [ecs\_event](#module\_ecs\_event)                   | ../../                        | n/a     |
| <a name="module_fargate_cluster"></a> [fargate\_cluster](#module\_fargate\_cluster) | oozou/ecs-fargate-cluster/aws | 1.0.6   |
| <a name="module_nginx"></a> [nginx](#module\_nginx)                                 | oozou/ecs-fargate-service/aws | v1.1.8  |
| <a name="module_vpc"></a> [vpc](#module\_vpc)                                       | oozou/vpc/aws                 | 1.2.4   |

## Resources

| Name                                                                                                                                                                      | Type        |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_ecs_task_definition.spin_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                                     | resource    |
| [aws_iam_role.daily_report_eventbridge_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                        | resource    |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                                | data source |
| [aws_iam_policy_document.daily_report_eventbridge_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.daily_report_eventbridge_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)             | data source |

## Inputs

| Name                                                                  | Description                                                                                                  | Type       | Default | Required |
|-----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|------------|---------|:--------:|
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | `map(any)` | `{}`    |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)   | Environment Variable used as a prefix                                                                        | `string`   | n/a     |   yes    |
| <a name="input_name"></a> [name](#input\_name)                        | Name of the ECS cluster and s3 also redis to create                                                          | `string`   | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                  | The prefix name of customer to be displayed in AWS console and resource                                      | `string`   | n/a     |   yes    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
