# 4-1. ALB 생성
resource "aws_lb" "terraform_alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_sg.id]
  subnets            = [aws_subnet.terraform_public_1.id, aws_subnet.terraform_public_2.id]
}


# 4-2. ALB Target Group 설정
resource "aws_lb_target_group" "group" {
  name        = "terraform-alb-target"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform_vpc.id
    health_check {
        path = "/"
        port = 80
  }
}

# 4-3. Listeners and routing 설정
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.terraform_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}

