data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "ecs_app_autoscaling" {
  name = "ecsAutoscaleRole"
}

resource "aws_appautoscaling_target" "main" {
  min_capacity       = "${var.services-min}"
  max_capacity       = "${var.services-max}"
  resource_id        = "service/${var.ecs-cluster-name}/${var.ecs-service-name}"
  role_arn           = "${data.aws_iam_role.ecs_app_autoscaling.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "service-scale-up" {
  name               = "${var.name}-service-scale-up"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.main.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.main.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.main.service_namespace}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.service-scale-up-cooldown}"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = "${var.service-scale-up-metricIntervalLowerBound1}"
      metric_interval_upper_bound = "${var.service-scale-up-metricIntervalUpperBound1}"
      scaling_adjustment          = 1
    }

    step_adjustment {
      metric_interval_lower_bound = "${var.service-scale-up-metricIntervalLowerBound2}"
      scaling_adjustment          = 2
    }
  }
}

resource "aws_appautoscaling_policy" "service-scale-down" {
  name               = "${var.name}-service-scale-down"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.main.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.main.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.main.service_namespace}"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.service-scale-down-cooldown}"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = "0"
      metric_interval_upper_bound = "${var.service-scale-down-metricIntervalUpperBound1}"
      scaling_adjustment          = -1
    }

    step_adjustment {
      metric_interval_lower_bound = "${var.service-scale-down-metricIntervalUpperBound1}"
      scaling_adjustment          = -2
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "service-cpu-high" {
  alarm_name          = "${var.name}-service-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.service-cpu-high-period}"
  threshold           = "${var.service-cpu-high-threshold}"
  statistic           = "Average"

  dimensions {
    ClusterName = "${var.ecs-cluster-name}"
    ServiceName = "${var.ecs-service-name}"
  }

  alarm_actions = [
    "${aws_appautoscaling_policy.service-scale-up.arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "service-cpu-low" {
  alarm_name          = "${var.name}-service-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.service-cpu-low-period}"
  threshold           = "${var.service-cpu-low-threshold}"
  statistic           = "Average"

  dimensions {
    ClusterName = "${var.ecs-cluster-name}"
    ServiceName = "${var.ecs-service-name}"
  }

  alarm_actions = [
    "${aws_appautoscaling_policy.service-scale-down.arn}",
  ]
}
