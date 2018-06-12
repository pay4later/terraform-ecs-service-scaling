output "scale-up-arn" {
  value = "${aws_appautoscaling_policy.service-scale-up.arn}"
}

output "scale-down-arn" {
  value = "${aws_appautoscaling_policy.service-scale-down.arn}"
}
