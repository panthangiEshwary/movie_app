// alb.tf
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app_tg" {
  name     = "movie-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "movie-app-target-group"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "app_attachment" {
   target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 5000
}

resource "null_resource" "prepare_frontend" {
  triggers = {
    alb_dns = aws_lb.app_lb.dns_name
  }

  provisioner "local-exec" {
    command = "powershell -Command \"(Get-Content frontend/index.html) -replace '##BACKEND_URL##', 'http://${aws_lb.app_lb.dns_name}' | Set-Content frontend/index_final.html\""
  }
}


