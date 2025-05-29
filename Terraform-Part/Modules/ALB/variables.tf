# -------------------------------------------------------------- #
# -------------------- ALB Module Variables -------------------- #
# -------------------------------------------------------------- #

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the load balancer"
}

variable "target_instances_ids" {
  type        = map(string)
  description = "Map of target EC2 instance IDs with static keys"
}

variable "security_groups_IDs" {
  type        = list(string)
  description = "The IDs of the security groups"
}