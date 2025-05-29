# ------------------------------------------------------------------------
# Creating Elastic IP and NAT Gateway
# ------------------------------------------------------------------------

resource "aws_eip" "my_nat_eip" {
  domain = "vpc"
  tags = {
    Name       = "nat-eip"
    Deployment = "Terraform"
  }
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_nat_eip.id
  subnet_id     = aws_subnet.my_public_subnets["public_subnet_1"].id

  tags = {
    Deployment = "Terraform"
  }
}