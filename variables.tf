#VPC variables
variable "vpc-cidr_block" {
    default = "10.0.0.0/16"
    description = "cidr_block of the VPC"
}
variable "vpc-instance_tenancy" {
    default = "default"
    description = "Tenancy of the VPC"
}

variable "vpc-tags" {
  default     = {
    Name = "my-vpc"
    Account = "connect2"
  }
  description = "VPC tags"
  type        = map(string)
}

#Internet gateway variables
variable "igw-condictional" {
    type = bool
    default = false
    description = "Conctional to check if a internet will be create (if false that will create a nat gateway)"
}

variable "igw-tags" {
  default     = {
    Name = "IGW"
    Account = "connect2"
  }
  description = "Internet gateway tags"
  type        = map(string)
}

#Public subnets variables
variable "public-subnets-tags" {
  default     = {
    Account = "connect2"
  }
  description = "Public Subnets tags"
  type        = map(string)
}

variable "public-subnets" {
  default     = {
    subnets_cidr_block = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    subnet_az = ["us-east-1a", "us-east-1b", "us-east-1c"]
    subnets_names = ["test", "test2", "test3"]
  }
  description = "Public Subnets variables"
  type        = map(list(string))
}

#Nat gateway variables
variable "nat-gw-tags" {
  default     = {
    Name = "Nat"
    Account = "connect2"
  }
  description = "Nat gateway tags"
  type        = map(string)
}