// VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb"            = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = 1
  }


}

// EKS

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # cluster_name       = "eks-cluster"  # Removed unsupported argument
  # cluster_version    = "1.24.0"        # Removed unsupported argument


  eks_managed_node_groups = {
    node = {
      desired_capacity = 1
      max_size         = 2
      min_size         = 1

      instance_types = ["t3.micro"]
    }
  }

  vpc_id     = module.vpc.default_vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}