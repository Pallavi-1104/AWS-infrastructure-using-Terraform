variable "name" {
  description = "The name for the EFS filesystem"
  type        = string
}

variable "performance_mode" {
  description = "The performance mode for the EFS filesystem"
  type        = string
  default     = "generalPurpose"  # Set to default if you don't need to pass this variable
  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Performance mode must be either 'generalPurpose' or 'maxIO'."
  }
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

variable "efs_access_point_arn" {
  description = "The ARN of the EFS access point"
  type        = string
  default     = ""  # Optional ARN, can be left empty if not required
}



