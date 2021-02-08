
terraform {
  required_version = ">=0.12"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
# Creating s3 backend
/*terraform {
    backend "s3" {
      bucket = "fw-internal-tfstate-bucket"
      key = "global/s3/terraform.tfstate"
      region = "us-east-1"
      # dynamodb_table = "dev-terraform-locks"
      encrypt = true
    }
}*/
module "vpc" {
  source = "./terraform/modules/vpc"
}

module "elb" {
  source      = "./terraform/modules/elb"
  vpc_id      = module.vpc.vpc_id
  vpc_subnets = [module.vpc.us-east-1a, module.vpc.us-east-1c]
}

module "s3"{
    source = "./terraform/modules/s3"
}
