variable "subnet_ids" {
  type        = "list"
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

variable "db_url" {
  description = "The database url"
}

variable "db_user" {
  description = "The database username"
}

variable "db_password" {
  description = "The database password"
}

