variable "name" {
  description = "The name for the EFS filesystem"
  type        = string
}

variable "performance_mode" {
  description = "The performance mode for the EFS filesystem"
  type        = string
  default     = "generalPurpose"  # Set to default if you don't need to pass this variable
}

variable "subnet_ids" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the EFS will be created"
  type        = string
}

variable "ecs_sg_id" {
  description = "Security Group ID for ECS services"
  type        = string
}




