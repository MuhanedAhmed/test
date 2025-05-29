# ----------------------------------------------------------------------
# Creating a public route table and associate it with the public subnets
# ----------------------------------------------------------------------

resource "aws_route_table" "my_public_routetable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }

  tags = {
    Name       = "public_route_table"
    Deployment = "Terraform"
  }
}

resource "aws_route_table_association" "my_public_subnet_routetable_association" {

  for_each       = aws_subnet.my_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_public_routetable.id
}

# ------------------------------------------------------------------------
# Creating a private route table and associate it with the private subnets
# ------------------------------------------------------------------------

resource "aws_route_table" "my_private_routetable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }

  tags = {
    Name       = "private_route_table"
    Deployment = "Terraform"
  }
}

resource "aws_route_table_association" "my_private_subnet_routetable_association" {

  for_each       = aws_subnet.my_private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.my_private_routetable.id
}