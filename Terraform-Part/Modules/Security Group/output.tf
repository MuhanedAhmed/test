# -------------------------------------------------------------- #
# ---------------------- SG Module Outputs --------------------- #
# -------------------------------------------------------------- #

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "backend_server_sg_id" {
  value = aws_security_group.backend_server_sg.id
}

output "allow_all_egress_sg_id" {
  value = aws_security_group.allow_all_egress.id
}
