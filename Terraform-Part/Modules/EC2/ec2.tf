# ----------------------------------------------------------------------------- #
# ------------------------------- EC2 Module ---------------------------------- #
# ----------------------------------------------------------------------------- #

resource "aws_instance" "my_instance" {
  for_each = var.instances

  ami                         = var.instance_ami
  instance_type               = "t2.micro"
  subnet_id                   = each.value.instance_subnet_id
  private_ip                  = each.value.instance_private_ip
  associate_public_ip_address = each.value.has_public_ip
  vpc_security_group_ids      = each.value.security_group_ids
  user_data                   = each.value.user_data
  key_name                    = var.instance_key_pair
  user_data_replace_on_change = true

  tags = {
    Name       = each.key
    Deployment = "Terraform"
  }
}