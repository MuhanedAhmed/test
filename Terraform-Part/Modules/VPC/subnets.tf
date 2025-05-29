# ---------------------------------------------------------------------
# Creating public and private subnets
# ---------------------------------------------------------------------

resource "aws_subnet" "my_public_subnets" {

  for_each = var.public_subnets

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.value.subnet_ip
  availability_zone = each.value.subnet_AZ
  tags = {
    Name       = each.key
    Deployment = "Terraform"
  }
}

resource "aws_subnet" "my_private_subnets" {

  for_each = var.private_subnets

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.value.subnet_ip
  availability_zone = each.value.subnet_AZ
  tags = {
    Name       = each.key
    Deployment = "Terraform"
  }
}