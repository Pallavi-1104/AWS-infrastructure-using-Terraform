variable "execution_role_arn" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "efs_access_point_arn" {
  description = "The ARN of the EFS access point"
  type        = string
}

variable "nodejs_image" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

