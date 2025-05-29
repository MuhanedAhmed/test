# --------------------------------------------------------------- #
# --------------------- VPC Module Variables -------------------- #
# --------------------------------------------------------------- #

variable "vpc_ip" {
  type        = string
  description = "A CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
  default     = null
}

variable "public_subnets" {
  type = map(object({
    subnet_ip = string
    subnet_AZ = string
  }))
  description = "Map of public subnets with their CIDR blocks and availability zones"
}

variable "private_subnets" {
  type = map(object({
    subnet_ip = string
    subnet_AZ = string
  }))
  description = "Map of private subnets with their CIDR blocks and availability zones"
}