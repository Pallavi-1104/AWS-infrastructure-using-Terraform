variable "efs_id" {
  type = string
}

variable "efs_access_point_id" {
  type = string
}

variable "nodejs_image" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets for ECS service"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security Groups for ECS task"
  type        = list(string)
}
