# -----------------------------------------------------------------------------
# Creating backend server security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "backend_server_sg" {
  name        = "backend_server_sg"
  description = "Allow HTTP from ALB and SSH from Bastion"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "backend_server_sg"
    Deployment = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_rule_backend" {
  security_group_id = aws_security_group.backend_server_sg.id

  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule_backend" {
  security_group_id = aws_security_group.backend_server_sg.id

  referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}