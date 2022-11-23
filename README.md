# terraform-aws-eventbridge

## Usage

```terraform
module "schedule" {
  source = "git::ssh://git@github.com/oozou/terraform-aws-eventbridge.git?ref=<version>"

  prefix      = "oozou"
  environment = "devops"
  name        = "subulu"

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

  tags = {
    "Workspace" = "xxx-yyy-zzz"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.00  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.23.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                    | Type        |
|-----------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_cloudwatch_event_bus.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus)       | resource    |
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)     | resource    |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource    |
| [aws_cloudwatch_event_bus.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_event_bus)    | data source |

## Inputs

| Name                                                                                                                                       | Description                                                                                                                                                                                                                                                                                                                                            | Type                                                                                                                  | Default                                                                                         | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|:--------:|
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name)                                                                               | A unique name for your EventBridge Bus                                                                                                                                                                                                                                                                                                                 | `string`                                                                                                              | `"default"`                                                                                     |    no    |
| <a name="input_cloudwatch_event_rule_is_enabled"></a> [cloudwatch\_event\_rule\_is\_enabled](#input\_cloudwatch\_event\_rule\_is\_enabled) | Whether the rule should be enabled.                                                                                                                                                                                                                                                                                                                    | `bool`                                                                                                                | `true`                                                                                          |    no    |
| <a name="input_cloudwatch_event_target"></a> [cloudwatch\_event\_target](#input\_cloudwatch\_event\_target)                                | A map of objects with EventBridge Target definitions.                                                                                                                                                                                                                                                                                                  | `any`                                                                                                                 | `{}`                                                                                            |    no    |
| <a name="input_cloudwatch_event_target_arn"></a> [cloudwatch\_event\_target\_arn](#input\_cloudwatch\_event\_target\_arn)                  | The Amazon Resource Name (ARN) associated of the target.                                                                                                                                                                                                                                                                                               | `string`                                                                                                              | n/a                                                                                             |   yes    |
| <a name="input_cloudwatch_event_target_id"></a> [cloudwatch\_event\_target\_id](#input\_cloudwatch\_event\_target\_id)                     | The unique target assignment ID. If missing, will generate a random, unique id.                                                                                                                                                                                                                                                                        | `string`                                                                                                              | `null`                                                                                          |    no    |
| <a name="input_dead_letter_config_arn"></a> [dead\_letter\_config\_arn](#input\_dead\_letter\_config\_arn)                                 | (Optional) Parameters used when you are providing a dead letter config. Documented below. A maximum of 1 are allowed.                                                                                                                                                                                                                                  | `string`                                                                                                              | `null`                                                                                          |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)                                                                        | Environment Variable used as a prefix                                                                                                                                                                                                                                                                                                                  | `string`                                                                                                              | n/a                                                                                             |   yes    |
| <a name="input_event_description"></a> [event\_description](#input\_event\_description)                                                    | The description of the rule.                                                                                                                                                                                                                                                                                                                           | `string`                                                                                                              | `""`                                                                                            |    no    |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern)                                                                | (Optional) The event pattern described a JSON object. At least one of schedule\_expression or event\_pattern is required.                                                                                                                                                                                                                              | `string`                                                                                                              | `null`                                                                                          |    no    |
| <a name="input_input"></a> [input](#input\_input)                                                                                          | Valid JSON text passed to the target. Conflicts with input\_path and input\_transformer.                                                                                                                                                                                                                                                               | `string`                                                                                                              | `null`                                                                                          |    no    |
| <a name="input_input_path"></a> [input\_path](#input\_input\_path)                                                                         | (Optional) The value of the JSONPath that is used for extracting part of the matched event when passing it to the target. Conflicts with input and input\_transformer.                                                                                                                                                                                 | `string`                                                                                                              | `null`                                                                                          |    no    |
| <a name="input_input_transformer"></a> [input\_transformer](#input\_input\_transformer)                                                    | Parameters used when you are providing a custom input to a target based on certain event data<br>  example:<br>  input\_transformer = {<br>  input\_paths = {<br>    severity="$.detail.severity",<br>    Finding\_Type="$.detail.type"<br>  }<br>  input\_template = "\"You have a severity <severity> GuardDuty finding type <Finding\_Type>\""<br>} | <pre>object({<br>    input_paths    = map(any)<br>    input_template = string<br>  })</pre>                           | `null`                                                                                          |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                             | Name of the ECS cluster to create                                                                                                                                                                                                                                                                                                                      | `string`                                                                                                              | n/a                                                                                             |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                       | The prefix name of customer to be displayed in AWS console and resource                                                                                                                                                                                                                                                                                | `string`                                                                                                              | n/a                                                                                             |   yes    |
| <a name="input_retry_policy"></a> [retry\_policy](#input\_retry\_policy)                                                                   | (Optional) Parameters used when you are providing retry policies. Documented below. A maximum of 1 are allowed.                                                                                                                                                                                                                                        | <pre>object({<br>    maximum_retry_attempts       = number<br>    maximum_event_age_in_seconds = number<br>  })</pre> | <pre>{<br>  "maximum_event_age_in_seconds": 3600,<br>  "maximum_retry_attempts": 100<br>}</pre> |    no    |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn)                                                                               | (Optional) The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. Required if ecs\_target is used or target in arn is EC2 instance, Kinesis data stream, Step Functions state machine, or Event Bus in different account or region.                                                                     | `string`                                                                                                              | `""`                                                                                            |    no    |
| <a name="input_run_command_targets"></a> [run\_command\_targets](#input\_run\_command\_targets)                                            | (Optional) Parameters used when you are using the rule to invoke Amazon EC2 Run Command. Documented below. A maximum of 5 are allowed.                                                                                                                                                                                                                 | <pre>list(object({<br>    key    = string<br>    values = list(string)<br>  }))</pre>                                 | `[]`                                                                                            |    no    |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression)                                              | (Optional) The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes)                                                                                                                                                                                                                                                               | `string`                                                                                                              | `null`                                                                                          |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                             | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys                                                                                                                                                                                                                                           | `map(any)`                                                                                                            | `{}`                                                                                            |    no    |

## Outputs

| Name                                                                                                                                | Description                                 |
|-------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|
| <a name="output_aws_cloudwatch_event_rule_arn"></a> [aws\_cloudwatch\_event\_rule\_arn](#output\_aws\_cloudwatch\_event\_rule\_arn) | The Amazon Resource Name (ARN) of the rule. |
| <a name="output_aws_cloudwatch_event_rule_id"></a> [aws\_cloudwatch\_event\_rule\_id](#output\_aws\_cloudwatch\_event\_rule\_id)    | The name of the rule                        |
<!-- END_TF_DOCS -->
