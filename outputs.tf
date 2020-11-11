output "scale-up-arn" {
  value = "${join("", aws_appautoscaling_policy.service-scale-up.*.arn)}"
}

output "scale-down-arn" {
  value = "${join("", aws_appautoscaling_policy.service-scale-down.*.arn)}"
}
