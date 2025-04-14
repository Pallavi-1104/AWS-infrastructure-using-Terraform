variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security Group ID for ECS services"
  type        = string
}

variable "name" {
  description = "The name for the EFS filesystem"
  type        = string
}

variable "file_system_id" {
  description = "EFS File System ID"
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  type        = string
}

variable "efs_access_point_arn" {
  description = "EFS Access Point ARN"
  type        = string
}



variable "nodejs_image" {
  description = "Docker image for the Node.js application"
  type        = string
}
