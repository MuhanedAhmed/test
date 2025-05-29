# ---------------------------------------------------------------------
# Creating a VPC and Internet Gateway
# ---------------------------------------------------------------------

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_ip

  tags = {
    Name       = var.vpc_name
    Deployment = "Terraform"
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Deployment = "Terraform"
  }
}