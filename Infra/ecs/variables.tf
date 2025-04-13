variable "file_system_id" {
  description = "EFS File System ID to mount into ECS Task"
  type        = string
}

variable "efs_access_point_arn" {
  description = "EFS Access Point ARN to mount into ECS Task"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM Execution Role ARN for ECS task"
  type        = string
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
