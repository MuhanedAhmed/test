output "EXT_ALB_DNS" {
  value = module.external_alb.ALB_DNS
}

output "RDS_Endpoint" {
  value = module.rds_instance.db_address
}

output "Jenkins_Public_IP" {
  value = module.ec2_servers.instance_public_ips["jenkins"]
}