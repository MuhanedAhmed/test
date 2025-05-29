# -----------------------------------------------------------------------------
# Creating ALB security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP from ALB and SSH from Bastion"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "alb_sg"
    Deployment = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_rule_alb" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}