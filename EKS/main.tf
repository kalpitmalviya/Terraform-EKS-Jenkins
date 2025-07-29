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
  version = "~> 21.0" # Use "~> 21.0" to allow for patch updates within the 21.x series, or "21.0.3" for exact pinning.

  name               = "jenkins-eks-cluster"
  kubernetes_version = "1.33" # Using the latest EKS supported Kubernetes version
  cluster_endpoint_public_access = true


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    node = {
      desired_capacity = 1
      max_size         = 2
      min_size         = 1

      instance_type = "t3.micro"
      additional_tags = {
        Name = "eks-node"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
