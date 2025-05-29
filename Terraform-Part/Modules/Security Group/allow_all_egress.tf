# -----------------------------------------------------------------------------
# Creating allow_all_egress security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "allow_all_egress" {
  name        = "allow_all_egress"
  description = "Allow all egress traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "allow_all_egress"
    Deployment = "Terraform"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_all_egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}