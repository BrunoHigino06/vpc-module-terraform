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
  count = var.igw-condictional ? 1 : 0
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
    tags = merge(
      var.public-subnets-tags,
      {
        Name = "Public${count.index + 1}"
      },
      )
    depends_on = [
      aws_vpc.vpc
    ]
}

#Nat gateway resouces
#Eip resource
resource "aws_eip" "NatEip" {
  count = length(var.public-subnets.subnets_cidr_block)
  vpc      = true

  tags = {
    Name = "Public${count.index + 1}_eip"
  }
}

#Nat resource
resource "aws_nat_gateway" "nat-gw" {
  count = var.igw-condictional ? 0 : length(var.public-subnets.subnets_cidr_block)
  allocation_id = aws_eip.NatEip[count.index].id
  subnet_id     = aws_subnet.plublic-subnets[count.index].id

  tags = var.nat-gw-tags

  depends_on = [
    aws_eip.NatEip,
    aws_subnet.plublic-subnets
  ]
}

#Private Subnets resource
resource "aws_subnet" "private-subnets" {
    count = length(var.private-subnets.subnets_cidr_block)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.private-subnets.subnets_cidr_block[count.index]
    availability_zone = var.private-subnets.subnet_az[count.index]
    tags = merge(
      var.private-subnets-tags,
      {
        Name = "Private${count.index + 1}"
      },
      )
    depends_on = [
      aws_vpc.vpc
    ]
}

#Private Route table resources
#Route table resource
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
      var.private-route-table-tags,
      {
        Name = var.private-route-table-name
      },
      )
  depends_on = [
    aws_vpc.vpc
  ]
}

#Default route for the private route table
resource "aws_route" "default-private-route" {
  count = var.igw-condictional ? 0 : 1
  route_table_id = aws_route_table.private-route-table.id
  gateway_id = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_route_table.private-route-table
  ]
}

