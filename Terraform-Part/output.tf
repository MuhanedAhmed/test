output "Ext_ALB_DNS" {
  value = module.external_alb.ALB_DNS
}

output "RDS_Endpoint" {
  value = module.rds_instance.db_address
}