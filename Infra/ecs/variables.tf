variable "execution_role_arn" {
  description = "IAM Role ARN used by ECS task definitions for execution"
  type        = string
}

variable "file_system_id" {
  description = "The EFS filesystem ID to mount"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to run ECS services in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with ECS services"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID to associate ECS services with"
  type        = string
}
