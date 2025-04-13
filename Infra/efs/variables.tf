variable "subnet_ids" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for EFS"
  type        = string
}

variable "efs_sg_id" {
  description = "Security Group ID for EFS"
  type        = string
}


