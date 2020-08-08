terraform {
  backend "s3" {
    bucket = "spring-ecs-terraform" # ! REPLACE WITH YOUR TERRAFORM BACKEND BUCKET
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
provider "aws" {
  region     = "eu-west-1"
}

locals {
  name        = "spring-ecs"
  environment = "dev"

  # This is the convention we use to know what belongs to each other
  ec2_resources_name = "${local.name}-${local.environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "github.com/terraform-aws-modules/terraform-aws-vpc"
//  version = "~> 2.0"

  name = local.name

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = local.environment
    Name        = local.name
  }
}

#----- ECS --------
module "ecs" {
  source             = "github.com/terraform-aws-modules/terraform-aws-ecs"
  name               = local.name
  container_insights = true
}

//module "ec2-profile" {
//  source = "github.com/terraform-aws-modules/terraform-aws-ecs/modules/ecs-instance-profile"
//  name   = local.name
//}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = "ecs_test_database"
}

module "ecs_service" {
  source = "./ecs-service"
  db_password = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]
  db_url = module.rds.rds_url
  db_user = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["username"]
  ecs_cluster_id = module.ecs.this_ecs_cluster_id
  ecs_security_group = aws_security_group.ecs.id
  load_balancer_arn = aws_alb_target_group.springecs
  rds_security_group = module.rds.db_access_sg_id
  subnet_ids = module.vpc.private_subnets
  task_role_arn = aws_iam_role.ecs_task_assume.arn

//  depends_on = [aws_alb_target_group.springecs]
}

//resource "aws_ecs_task_definition" "springecs" {
//  family                = "springecs"
//  requires_compatibilities = ["FARGATE"]
//  network_mode = "awsvpc"
//  cpu = 256
//  memory = 1024
//  container_definitions = file("task-definitions/spring-ecs.json")
//  execution_role_arn = aws_iam_role.ecs_task_assume.arn
//}
//
//resource "aws_ecs_service" "springecs" {
//  name            = "springecs"
//  cluster         = module.ecs.this_ecs_cluster_id
//  launch_type     = "FARGATE"
//  task_definition = aws_ecs_task_definition.springecs.arn
//  desired_count   = 2
//
//  network_configuration {
//    subnets = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
//    security_groups = [aws_security_group.ecs.id, module.rds.db_access_sg_id]
//  }
//
//  load_balancer {
//    target_group_arn = aws_alb_target_group.springecs.arn
//    container_name = "springecs"
//    container_port = 8080
//  }
//
//  depends_on = [aws_alb_listener.springecs]
//}
//
//resource "aws_cloudwatch_log_group" "springecs" {
//  name = "/ecs/fargate-task-definition"
//}

#----- RDS  Services--------
module "rds" {
  source            = "./rds"
  environment       = "dev"
  allocated_storage = "20"
  database_name     = var.database_name
  database_username = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["username"]
  database_password = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]
  subnet_ids        = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
//  subnet_ids        = ["10.1.1.0/24", "10.1.2.0/24"]
  vpc_id            = module.vpc.vpc_id
  instance_class    = "db.t3.micro"
}