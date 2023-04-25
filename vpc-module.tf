provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment     = "Test"
      Service         = "Example"
    }
  }
}

#VPC resource
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr_block
  instance_tenancy = var.vpc-instance_tenancy

  tags = var.vpc-tags
}

#Internet gateway resource
resource "aws_internet_gateway" "internet-gateway" {
  count = var.gw-condictional ? 0 : 1
  vpc_id = aws_vpc.vpc.id
  tags = var.igw-tags

  depends_on = [
    aws_vpc.vpc
  ]
}

#Public Subnets resource
resource "aws_subnet" "plublic-subnets" {
    count = length(var.public-subnets.subnets_cidr_block)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.public-subnets.subnets_cidr_block[count.index]
    availability_zone = var.public-subnets.subnet_az[count.index]
    tags = {
        Name = var.public-subnets.subnets_names[count.index]
    }

    depends_on = [
      aws_vpc.vpc
    ]
}

11111adicionar a um recurso de tag para complementar as subnets

#Nat gateway resouce
resource "aws_eip" "NatEip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-gw" {
  count = var.gw-condictional ? 0 : 1
  allocation_id = aws_eip.NatEip.id
  subnet_id     = aws_subnet.plublic-subnets[0].id

  tags = var.nat-gw-tags
}

#Private Subnets resource
