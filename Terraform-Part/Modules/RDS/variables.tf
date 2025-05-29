# -------------------------------------------------------------- #
# -------------------- RDS Module Variables -------------------- #
# -------------------------------------------------------------- #

variable "subnet_group_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group."
}

variable "db_sg_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the RDS instance."
}