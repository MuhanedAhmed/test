# -------------------------------------------------------------- #
# --------------------- EC2 Module Outputs --------------------- #
# -------------------------------------------------------------- #

output "instance_ids" {
  description = "Map of instance IDs"
  value = {
    for key, inst in aws_instance.my_instance :
    key => inst.id
  }
}