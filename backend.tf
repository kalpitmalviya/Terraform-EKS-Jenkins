terraform {
  backend "s3" {
    bucket = "cicd-terra-eks-31"
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"

  }
}