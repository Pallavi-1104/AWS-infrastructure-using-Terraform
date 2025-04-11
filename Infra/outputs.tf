output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "efs_file_system_id" {
  description = "EFS File System ID"
  value       = module.efs.efs_id
}

output "efs_access_point_arn" {
  description = "EFS Access Point ARN"
  value       = module.efs.efs_access_point_arn
}

output "execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "security_group_ids" {
  description = "Security group IDs used by ECS tasks"
  value       = module.vpc.security_group_ids
}
