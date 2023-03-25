# main.tf

provider "aws" {
  region = "us-west-2"
}

locals {
  cluster_name = "eks-fargate-cluster"
}
