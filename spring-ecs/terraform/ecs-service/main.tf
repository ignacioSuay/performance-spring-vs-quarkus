resource "aws_ecs_task_definition" "springecs" {
  family                = "springecs"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 1024
  execution_role_arn = var.task_role_arn
//  container_definitions = file("ecs-service/task-definitions/spring-ecs.json")
  container_definitions = <<DEFINITION
    [
  {
    "name": "springecs",
    "image": "963419467435.dkr.ecr.eu-west-1.amazonaws.com/ecs_test:0.0.1-RELEASE",
    "cpu": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/fargate-task-definition",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "secrets": [
      {
        "name": "SPRING_DATASOURCE_USERNAME",
        "valueFrom": "${var.db_user}"
      },
      {
        "name": "SPRING_DATASOURCE_PASSWORD",
        "valueFrom": "${var.db_password}"
      }
    ],
    "environment": [
      {
        "name": "SPRING_DATASOURCE_URL",
        "value": "${var.db_url}"
      }
    ]
  }
]
  DEFINITION

}

resource "aws_ecs_service" "springecs" {
  name            = "springecs"
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.springecs.arn
  desired_count   = 2

  network_configuration {
    subnets = [var.subnet_ids[0], var.subnet_ids[1]]
    security_groups = [var.ecs_security_group, var.rds_security_group]
  }

  load_balancer {
    target_group_arn = var.load_balancer_arn.arn
    container_name = "springecs"
    container_port = 8080
  }
  depends_on = [var.load_balancer_arn]
}

resource "aws_cloudwatch_log_group" "springecs" {
  name = "/ecs/fargate-task-definition"
}