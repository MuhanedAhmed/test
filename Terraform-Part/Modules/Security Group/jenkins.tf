# -----------------------------------------------------------------------------
# Creating jenkins server security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow jenkins traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "jenkins_sg"
    Deployment = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_rule" {
  security_group_id = aws_security_group.jenkins_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule_jenkins" {
  security_group_id = aws_security_group.jenkins_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}