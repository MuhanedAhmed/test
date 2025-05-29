# --------------------------------------------------------------------------
# Fetching AWS provider and setting the project backend to be remote on AWS
# --------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta1"
    }
  }

  backend "s3" {
    bucket       = "mohaned-backend-for-terraform"
    key          = "states/java-spring-petclinic/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}


# ---------------------------------------------------------------------
# Setting the configurations of AWS provider
# ---------------------------------------------------------------------

provider "aws" {
  region  = var.region
  profile = "default"
}