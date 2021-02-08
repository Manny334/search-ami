resource "aws_security_group" "fw-lb-internal-instances-sg" {
  name        = "fw-lb-internal-instances-sg"
  description = "Contains the security group for the instances "
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "fw-lb-internal-instances-sg",
    "ENV"  = var.env
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "fw-lb-internal-instances-rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.fw-lb-internal-instances-sg.id
  source_security_group_id = aws_security_group.fw-lb-internal-sg.id
}



resource "aws_security_group" "fw-lb-internal-sg" {
  name        = "fw-lb-internal-sg"
  description = "Private Load Balancer Security Group"
  vpc_id      = var.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "fw-lb-internal-sg",
    "ENV"  = var.env
  }
}

resource "aws_security_group_rule" "fw-lb-internal-rule" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.fw-lb-internal-sg.id
  source_security_group_id = aws_security_group.fw-lb-internal-instances-sg.id
}
