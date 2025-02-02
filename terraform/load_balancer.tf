resource "aws_lb" "jb-load-balancer" {
  name               = "jb-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-public-traffic.id]
  subnets = [
    aws_subnet.public_subnet-a.id,
    aws_subnet.public_subnet-b.id
  ]

  #enable_deletion_protection = true

  tags = {
    Name = "jb-load-balancer"
  }

  depends_on = [
    aws_instance.application
  ]
}

resource "aws_lb_target_group" "jb-target-group" {
  name     = "jb-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  depends_on = [
    aws_instance.application
  ]
}

resource "aws_lb_listener" "jb-listener-https" {
  load_balancer_arn = aws_lb.jb-load-balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:443370703773:certificate/edccd4fc-b2c1-447e-a026-141245696feb"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jb-target-group.arn
  }
}

resource "aws_lb_listener" "jb-listener-http" {
  load_balancer_arn = aws_lb.jb-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.jb-target-group.arn
  target_id        = aws_instance.application.id
  port             = 3000

  depends_on = [
    aws_instance.application
  ]
}