// General settings (required parameters)
variable "name" {
  type        = "string"
  description = "Name of the module instance"
}

variable "ecs-cluster-name" {
  type        = "string"
  description = "Name of the ECS cluster"
}

variable "ecs-service-name" {
  type        = "string"
  description = "Name of the ECS service"
}

variable "services-min" {
  type        = "string"
  description = "Minimum amount of services to start"
  default     = "1"
}

variable "services-max" {
  type        = "string"
  description = "Maximum amount of services to start"
  default     = "1"
}

// Auto-scaling options (pre-defined optional parameters)
variable "service-scale-up-cooldown" {
  type        = "string"
  description = "Cooldown when scaling up the service"
  default     = "60"
}

variable "service-scale-down-cooldown" {
  type        = "string"
  description = "Cooldown when scaling down the service"
  default     = "120"
}

variable "service-cpu-high-threshold" {
  type        = "string"
  description = "Threshold when CloudWatch reports high CPU usage"
  default     = "60"
}

variable "service-cpu-high-period" {
  type        = "string"
  description = "Period when CloudWatch checks for high CPU usage"
  default     = "60"
}

variable "service-cpu-low-threshold" {
  type        = "string"
  description = "Threshold when CloudWatch reports low CPU usage"
  default     = "40"
}

variable "service-cpu-low-period" {
  type        = "string"
  description = "Period when CloudWatch checks for low CPU usage"
  default     = "60"
}
