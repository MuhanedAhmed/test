# --------------------------------------------------------------
# Creating a VPC
# --------------------------------------------------------------

module "main_VPC" {
  source   = "./Modules/VPC"
  vpc_ip   = "10.10.0.0/16"
  vpc_name = "PetClinic_VPC"
  public_subnets = {
    public_subnet_1 = {
      subnet_AZ = "${var.region}a"
      subnet_ip = "10.10.10.0/24"
    }
    public_subnet_2 = {
      subnet_AZ = "${var.region}b"
      subnet_ip = "10.10.20.0/24"
    }
  }
  private_subnets = {
    private_subnet_1 = {
      subnet_AZ = "${var.region}a"
      subnet_ip = "10.10.110.0/24"
    }
    private_subnet_2 = {
      subnet_AZ = "${var.region}b"
      subnet_ip = "10.10.120.0/24"
    }
    private_subnet_3 = {
      subnet_AZ = "${var.region}a"
      subnet_ip = "10.10.130.0/24"
    }
    private_subnet_4 = {
      subnet_AZ = "${var.region}b"
      subnet_ip = "10.10.140.0/24"
    }
  }
}

# --------------------------------------------------------------
# Creating Security Groups 
# --------------------------------------------------------------

module "security_groups" {
  source = "./Modules/Security Group"
  vpc_id = module.main_VPC.vpc_id
}

# --------------------------------------------------------------
# Creating EC2 Servers
# --------------------------------------------------------------

module "ec2_servers" {
  source            = "./Modules/EC2"
  instance_ami      = var.instance_ami
  instance_key_pair = var.instance_key_pair
  instances = {
    jenkins = {
      instance_subnet_id  = module.main_VPC.public_subnet_IDs["public_subnet_1"]
      instance_private_ip = "10.10.10.10"
      has_public_ip       = true
      security_group_ids  = [module.security_groups.jenkins_sg_id, module.security_groups.allow_all_egress_sg_id]
    }
    backend_server_1 = {
      instance_subnet_id  = module.main_VPC.private_subnet_IDs["private_subnet_3"]
      instance_private_ip = "10.10.130.10"
      security_group_ids  = [module.security_groups.backend_server_sg_id, module.security_groups.allow_all_egress_sg_id]
    }
    backend_server_2 = {
      instance_subnet_id  = module.main_VPC.private_subnet_IDs["private_subnet_4"]
      instance_private_ip = "10.10.140.10"
      security_group_ids  = [module.security_groups.backend_server_sg_id, module.security_groups.allow_all_egress_sg_id]
    }
  }
}

# --------------------------------------------------------------
# Creating Application Load Balancer
# --------------------------------------------------------------

module "external_alb" {
  source = "./Modules/ALB"
  vpc_id = module.main_VPC.vpc_id
  target_instances_ids = {
    backend_server_1 = module.ec2_servers.instance_ids["backend_server_1"]
    backend_server_2 = module.ec2_servers.instance_ids["backend_server_2"]
  }
  subnet_ids = [
    module.main_VPC.public_subnet_IDs["public_subnet_1"],
    module.main_VPC.public_subnet_IDs["public_subnet_2"]
  ]
  security_groups_IDs = [module.security_groups.alb_sg_id]
}

# --------------------------------------------------------------
# Creating MySQL RDS Instance
# --------------------------------------------------------------

module "rds_instance" {
  source = "./Modules/RDS"
  subnet_group_ids = [
    module.main_VPC.private_subnet_IDs["private_subnet_1"],
    module.main_VPC.private_subnet_IDs["private_subnet_2"]
  ]
  db_sg_ids = [module.security_groups.rds_sg_id]
}