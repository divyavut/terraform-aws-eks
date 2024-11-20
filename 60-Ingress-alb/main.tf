module "ingress_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = false
  name    = "${local.resource_name}-ingress-alb" #expense-dev-ingress-alb
  # vpc_id  = local.vpc_id
  vpc_id  = "vpc-0124d4c97884f98ed"
  # subnets = local.public_subnet_ids
  subnets = ["subnet-03c4b47454c4dcd44", "subnet-02ac3bbfc94ad2a5d"]
  # security_groups = [data.aws_ssm_parameter.ingress_alb_sg_id.value]
  security_groups = ["sg-0b80578709d71d6c8"]
  create_security_group = false
  enable_deletion_protection = false
  tags = merge(
    var.common_tags,
    var.ingress_alb_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Application ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Web ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name #divyavuatakanti.com
  records = [
    {
      name    = "expense-${var.environment}" # *.expense-dev
      type    = "A"
      alias   = {
        name    = module.ingress_alb.dns_name
        zone_id = module.ingress_alb.zone_id # This belongs ALB internal hosted zone, not ours
      }
      allow_overwrite = true
    }
  ]
}
resource "aws_lb_target_group" "expense" {
  name     = local.resource_name
  port     = 80
  protocol = "HTTP"
  # vpc_id   = local.vpc_id
  vpc_id  = "vpc-0124d4c97884f98ed"
  target_type = "ip"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/"
    port = 80
    protocol = "HTTP"
    timeout = 4
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100 # low priority will be evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.expense.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.zone_name}"] #expense-dev.divyavutakanti.com
  }
}
}