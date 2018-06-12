provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "ecs_service" {
  name = "ecsServiceRole"
}

data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

resource "aws_iam_role" "application" {
  name = "my-application-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_ecs_cluster" "cluster" {
  name = "My example cluster"
}

resource "aws_ecs_service" "service" {
  name                              = "My ECS service"
  cluster                           = "${aws_ecs_cluster.cluster.id}"
  task_definition                   = "${aws_ecs_task_definition.task-def.arn}"
  desired_count                     = 1
  iam_role                          = "${data.aws_iam_role.ecs_service.arn}"
  health_check_grace_period_seconds = 5

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}

resource "aws_ecs_task_definition" "task-def" {
  family             = "service-task-def"
  task_role_arn      = "${aws_iam_role.application.arn}"
  execution_role_arn = "${data.aws_iam_role.ecs_task_execution.arn}"

  container_definitions = <<EOF
[
  {
    "name": "hello-world",
    "image": "hello-world",
    "essential": true,
    "memoryReservation": 50,
    "cpu": 10
  }
]
EOF
}

module "service-scaling" {
  source = "../"

  name             = "my new service that requires autoscaling"
  ecs-cluster-name = "${aws_ecs_cluster.cluster.name}"
  ecs-service-name = "${aws_ecs_service.service.name}"
}
