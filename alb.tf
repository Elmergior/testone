resource "aws_lb" "testone-alb" {
  name               = "testone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [data.aws_subnet.subs-ids]
}

resource "aws_lb_target_group" "testone-tg" {
  name                          = "testone-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.default.id
  load_balancing_algorithm_type = "round_robin"
}