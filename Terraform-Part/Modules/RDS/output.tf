# -------------------------------------------------------------- #
# --------------------- RDS Module Outputs --------------------- #
# -------------------------------------------------------------- #

output "db_address" {
  value       = aws_db_instance.my_instace.address
  description = "The hostname or DNS endpoint of the RDS instance."
}