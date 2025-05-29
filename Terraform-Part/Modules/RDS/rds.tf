# ----------------------------------------------------------------------------- #
# ------------------------------- RDS Module ---------------------------------- #
# ----------------------------------------------------------------------------- #

resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = var.subnet_group_ids

  tags = {
    Name       = "rds_subnet_group"
    Deployment = "Terraform"
  }
}

resource "aws_db_instance" "my_instace" {
  allocated_storage      = 10
  storage_type           = "gp2"
  instance_class         = "db.t3.micro"
  identifier             = "pet-clinic-db"
  engine                 = "mysql"
  engine_version         = "8.4"
  parameter_group_name   = "default.mysql8.4"
  port                   = 3306
  db_subnet_group_name   = aws_db_subnet_group.my_subnet_group.name
  vpc_security_group_ids = var.db_sg_ids
  db_name                = "petclinic"
  username               = "petclinic"
  password               = "petclinic"
  skip_final_snapshot    = true
  apply_immediately      = true
  publicly_accessible    = false
}