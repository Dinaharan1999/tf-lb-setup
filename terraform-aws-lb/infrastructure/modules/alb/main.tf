###############################################################
# Application Load Balancer
###############################################################

resource "aws_lb" "alb" {

  name               = "${var.project_name}-alb"

  internal           = false

  load_balancer_type = "application"

  security_groups    = [var.alb_sg]

  subnets            = var.subnet_ids

  enable_deletion_protection = false

  idle_timeout = 60

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-alb"
    }
  )

}

###############################################################
# Target Group
###############################################################

resource "aws_lb_target_group" "web" {

  name = "${var.project_name}-tg"

  port = 80

  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    interval = 30

    path = "/"

    protocol = "HTTP"

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2

    matcher = "200"

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-tg"
    }
  )

}

###############################################################
# Register EC2 Instances
###############################################################

resource "aws_lb_target_group_attachment" "web" {

  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.web.arn

  target_id = var.instance_ids[count.index]

  port = 80

}

###############################################################
# HTTP Listener
###############################################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.web.arn

  }

}