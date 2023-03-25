# vpc.tf

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.cluster_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = 2

  cidr_block = "10.0.${count.index + 1}.0/24"
  vpc_id     = aws_vpc.this.id

  tags = {
    Name = "${local.cluster_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = 2

  cidr_block = "10.0.${count.index + 101}.0/24"
  vpc_id     = aws_vpc.this.id

  tags = {
    Name = "${local.cluster_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.cluster_name}-igw"
  }
}

resource "aws_security_group" "eks_cluster" {
name_prefix = "eks_cluster"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.cluster_name}-sg"
  }
}
