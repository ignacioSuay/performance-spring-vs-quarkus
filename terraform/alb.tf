resource "aws_alb" "albecs" {
  name = "albEcs"
  internal = false

  security_groups = [
    aws_security_group.ecs.id,
    aws_security_group.alb.id,
  ]

  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
}

resource "aws_alb_target_group" "albecs" {
  name = "albEcs"
  protocol = "HTTP"
  port = "8080"
  vpc_id = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path = "/health"
  }
}

resource "aws_alb_listener" "albecs" {
  load_balancer_arn = aws_alb.albecs.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.albecs.arn
    type = "forward"
  }

  depends_on = [aws_alb_target_group.albecs]
}

output "alb_dns_name" {
  value = aws_alb.albecs.dns_name
}
