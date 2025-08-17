module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "shared-vpc"
    cidr = "10.0.0.0/16"

    azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
    private_subnets = ["10.0.1.0/24"]
    public_subnets = ["10.0.101.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
    enable_dns_support = true
    map_public_ip_on_launch = true

    tags = {
        Environment = var.environment == "staging" ? "staging" : "production"
        Managed_by  = "OPAKI"
    }

}