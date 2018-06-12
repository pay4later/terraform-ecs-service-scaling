# ECS Service Scaling module for Terraform

Module to attach auto-scaling rules to an existing service inside a ECS cluster.

# Example usage

Have a look at the [./examples](./examples) folder for a working example.

# Module details

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ecs-cluster-name | Name of the ECS cluster | string | - | yes |
| ecs-service-name | Name of the ECS service | string | - | yes |
| name | Name of the module instance | string | - | yes |
| service-cpu-high-period | Period when CloudWatch checks for high CPU usage | string | `60` | no |
| service-cpu-high-threshold | Threshold when CloudWatch reports high CPU usage | string | `60` | no |
| service-cpu-low-period | Period when CloudWatch checks for low CPU usage | string | `60` | no |
| service-cpu-low-threshold | Threshold when CloudWatch reports low CPU usage | string | `40` | no |
| service-scale-down-cooldown | Cooldown when scaling down the service | string | `120` | no |
| service-scale-down-metricIntervalUpperBound1 | metric_interval_lower_bound value for the single increment | string | `40` | no |
| service-scale-up-cooldown | Cooldown when scaling up the service | string | `60` | no |
| service-scale-up-metricIntervalLowerBound1 | metric_interval_lower_bound value for the single increment | string | `0` | no |
| service-scale-up-metricIntervalLowerBound2 | metric_interval_lower_bound value for the single increment | string | `40` | no |
| service-scale-up-metricIntervalUpperBound1 | metric_interval_lower_bound value for the double increment | string | `40` | no |
| services-max | Maximum amount of services to start | string | `1` | no |
| services-min | Minimum amount of services to start | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| scale-down-arn |  |
| scale-up-arn |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
