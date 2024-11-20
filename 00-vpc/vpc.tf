module "vpc" {
    source = "git::https://github.com/divyavut/terraform-aws-vpc-module.git?ref=main"
    vpc_cidr = var.vpc_cidr
    project_name = var.project_name
    environment = var.environment
    enable_dns_hostnames = var.enable_dns_hostnames
    public_subnet_cidr_block = var.public_subnet_cidr_block
    private_subnet_cidr_block = var.private_subnet_cidr_block
    database_subnet_cidr_block = var.database_subnet_cidr_block
    ispeering_required = var.ispeering_required
}