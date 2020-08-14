variable "subnet_ids" {
  type        = list
  description = "Subnet ids"
}

variable "ecs_security_group" {
  description = "The id of the ecs security group"
}

variable "rds_security_group" {
  description = "The id of the rds security group"
}

variable "ecs_cluster_id" {
  description = "The id of the ecs cluster"
}

variable "task_role_arn" {
  description = "The arn of the role the ecs task will assume"
}

variable "load_balancer_arn" {
  description = "The arn load balancer"
}

variable "db_url_param" {
  description = "The database url parameter name"
  default = "SPRING_DATASOURCE_URL"
}

variable "db_url" {
  description = "The database url"
}

variable "db_user_param" {
  description = "The database user parameter name"
  default = "SPRING_DATASOURCE_USERNAME"
}

variable "db_user" {
  description = "The database username"
}

variable "db_password_param" {
  description = "The database password parameter name"
  default = "SPRING_DATASOURCE_PASSWORD"
}

variable "db_password" {
  description = "The database password"
}

variable "docker_image_arn" {
  description = "ARN of the docker image in AWS"
}