# VPC CIDR Block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet CIDR Block
variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Private Subnet CIDR Block
variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Availability Zone for Public Subnet
variable "public_subnet_az" {
  description = "The availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

# Availability Zone for Private Subnet
variable "private_subnet_az" {
  description = "The availability zone for the private subnet"
  type        = string
  default     = "us-east-1b"
}

