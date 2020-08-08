resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Allow traffic for ecs"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24"]//["${split(",", var.CIDR_PUBLIC)}"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.1.11.0/24", "10.1.12.0/24"]//["${split(",", var.CIDR_PRIVATE)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow traffic for alb"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
