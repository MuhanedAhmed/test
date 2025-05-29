# -----------------------------------------------------------------------------
# Creating RDS security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow mysql trrafic from backend servers"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "rds_sg"
    Deployment = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql_rule" {
  security_group_id = aws_security_group.backend_server_sg.id

  referenced_security_group_id = aws_security_group.backend_server_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}