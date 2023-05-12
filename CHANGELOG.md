# Change Log

All notable changes to this module will be documented in this file.

## [v1.1.0] - 2022-11-23

### Added

- New example at `examples/ecs-task`
- Add data `aws_cloudwatch_event_bus.this`
- Add resource `aws_cloudwatch_event_bus.this`
- Update resource `aws_cloudwatch_event_target.this`
    - Add support select event bus with `event_bus_name`
    - Add support select EC2 with `run_command_targets`
    - Add support ecs target with `ecs_target`
    - Add support http target with `http_target`
- Add variable `bus_name`, `cloudwatch_event_target`, `input_path` and `run_command_targets`

### Changed

- Update `.gitignore` to support better UX for examples folder
- Update example `examples/lambda-scheduling`
- Update non-comment variable `retry_policy`
- Update comment on variable `dead_letter_config_arn`

### Removed

- File `locals.tf` and move it to `main.tf`
- Logic validate input in `locals.tf`

## [v1.0.1] - 2022-09-16

### Added

- retry_policy, dead_letter_config_arn, input_transformer

## [v1.0.0] - 2022-07-20

### Added

- init terraform-aws-eventbridge module
