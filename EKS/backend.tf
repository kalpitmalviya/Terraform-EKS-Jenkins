terraform {
  backend "s3" {
    bucket = "cicd-terra-eks-31"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}