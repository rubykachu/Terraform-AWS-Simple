# Module: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name       = "${var.project_code}-VPC"
  azs        = var.azs
  create_igw = true

  # NAT Gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # CIDR Block IP
  cidr                  = var.cidr_block
  private_subnets       = var.private_subnets
  private_subnet_suffix = "Pri-"
  public_subnets        = var.public_subnets
  public_subnet_suffix  = "Pub-"

  # === TAGS ===
  tags = {
    Project   = var.project
    Terraform = true
  }

  igw_tags = {
    Project   = var.project
    Terraform = true
  }

  private_subnet_tags = {
    Project   = var.project
    Terraform = true
  }

  public_subnet_tags = {
    Project   = var.project
    Terraform = true
  }
}
