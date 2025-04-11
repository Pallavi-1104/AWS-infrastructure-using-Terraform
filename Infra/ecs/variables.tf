variable "execution_role_arn" {
  type = string
}

variable "file_system_id" {
  type = string
}

variable "efs_access_point_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ecs_cluster_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}      