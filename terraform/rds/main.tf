/*====
RDS
======*/

/* subnet used by rds */
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.environment}-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.subnet_ids
  tags = {
    Environment = var.environment
  }
}

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.environment}-db-access-sg"
  description = "Allow access to RDS"

  tags = {
    Name        = "${var.environment}-db-access-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name = "${var.environment}-rds-sg"
  description = "${var.environment} Security Group"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment}-rds-sg"
    Environment =  var.environment
  }

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 3306
      to_port   = 3306
      protocol  = "tcp"
      security_groups = [
        aws_security_group.db_access_sg.id]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = "ecs_test_database"
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.environment}-database"
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = "8.0.17"
  instance_class         = var.instance_class
  multi_az               = var.multi_az
  name                   = var.database_name
  username               = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["username"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  tags = {
    Environment = var.environment
  }
}
