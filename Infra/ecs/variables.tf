variable "execution_role_arn" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "efs_access_point_id" {
  type = string
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

