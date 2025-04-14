variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Optional: you can override these if needed, or let modules use defaults
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_ids" {
  description = "List of subnet IDs for EFS"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones in the region."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets."
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-monitoring-cluster"
}

variable "execution_role_arn" {
  description = "The execution role ARN"
  type        = string
}

variable "file_system_id" {
  description = "The EFS file system ID"
  type        = string
}

variable "efs_access_point_arn" {
  description = "EFS Access Point ARN"
  type        = string
}

variable "nodejs_image" {
  description = "The Docker image for the Node.js app"
  type        = string
}

variable "name" {
  description = "Name of the EFS"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "ecs_sg_id" {
  description = "Security Group ID used by ECS tasks"
  type        = string
}
