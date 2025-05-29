#------------------------------------------------------------------
# Provider Variables
#------------------------------------------------------------------

variable "region" {
  type = string
}


#------------------------------------------------------------------
# EC2 Module Variables 
#------------------------------------------------------------------

variable "instance_ami" {
  type        = string
  description = "The AMI of the EC2 instance"
}

variable "instance_key_pair" {
  type        = string
  description = "The key-pair used to connect to the instance"
}