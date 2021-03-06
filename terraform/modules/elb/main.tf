terraform {
  required_version = ">=0.12"
}
data "aws_ami" "fw_search_ami"{
    most_recent = true

    owners = ["558814676609"]

    filter {
        name = "name"
        values = ["fw-search-*"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}
# Creating a AWS Load balancer
resource "aws_lb" "fw-lb-internal" {
  name               = "fw-lb-internal-test"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fw-lb-internal-sg-test.id]
  subnets            = [var.vpc_subnets[0], var.vpc_subnets[1]]
  tags = {
    "Name" = "prod-lb-internal",
    "ENV"  = var.env
  }
}

# Assigning Listener to the load balancer
resource "aws_lb_listener" "fw-lb-internal-listener-default-test" {
  load_balancer_arn = aws_lb.fw-lb-internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "Page Not Found"
      status_code  = "404"
    }
  }
}

# Assigning Listener rules
resource "aws_lb_listener_rule" "fw-lb-internal-rule-elasticsearch-test" {
  listener_arn = aws_lb_listener.fw-lb-internal-listener-default-test.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fw-lb-internal-tg-search-elasticsearch-test.arn
  }

  condition {
    host_header {
      values = [var.host_header_prod]
    }
  }
}
resource "aws_lb_listener_rule" "fw-lb-internal-rule-kibana-test" {
  listener_arn = aws_lb_listener.fw-lb-internal-listener-default-test.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fw-lb-internal-tg-search-kibana-test.arn
  }

  condition {
    host_header {
      values = [var.host_header_kibana]
    }
  }
}

# Allocating target groups
resource "aws_lb_target_group" "fw-lb-internal-tg-search-kibana-test" {
  name        = "fw-lb-kibana-target-group-test"
  port        = 5601
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
    path                = "/"
    port                = 5601
    protocol            = "HTTP"
    matcher             = "200-399"
  }
  tags = {
    "ENV" = var.env
  }
}
resource "aws_lb_target_group" "fw-lb-internal-tg-search-elasticsearch-test" {
  name        = "fw-lb-es-target-group-test"
  port        = 9200
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
    path                = "/"
    port                = 9200
    protocol            = "HTTP"
    matcher             = "200"
  }
  tags = {
    "ENV" = var.env
  }
}

# Creating launch configuration
resource "aws_launch_configuration" "fw-internal-instances-launch-configuration-test" {
  name                        = "fw-internal-instances-launch-configuration-test"
  image_id                    = data.aws_ami.fw_search_ami.id
  instance_type               = var.es_instance_type
  security_groups             = [aws_security_group.fw-lb-internal-instances-sg-test.id]
  key_name                    = "testelasticsearch"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

# Assigning auto scaling group
resource "aws_autoscaling_group" "fw-internal-instances-asg-configuration-test" {
  name                 = "fw-internal-instances-asg-configuration-test"
  launch_configuration = aws_launch_configuration.fw-internal-instances-launch-configuration-test.id
  max_size             = var.es_max_instances
  min_size             = var.es_min_instances
  desired_capacity     = var.es_desired_instances
  default_cooldown     = 30
  force_delete         = true
  vpc_zone_identifier  = [var.vpc_subnets[0], var.vpc_subnets[1]]
  target_group_arns    = [aws_lb_target_group.fw-lb-internal-tg-search-kibana-test.arn, aws_lb_target_group.fw-lb-internal-tg-search-elasticsearch-test.arn]
  tag {
    key                 = "Name"
    value               = "FW-${var.env}-ElasticSearch"
    propagate_at_launch = true
  }
}
