# Create ALB
resource "aws_lb" "testone-alb" {
  name               = "testone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.apache-subnet.id, aws_subnet.nginx-subnet.id]
}

# Create ALB group
resource "aws_lb_target_group" "testone-tg" {
  name                          = "testone-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.default.id
  load_balancing_algorithm_type = "round_robin"
}

# Create ALB Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.testone-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.testone-tg.arn
  }
}