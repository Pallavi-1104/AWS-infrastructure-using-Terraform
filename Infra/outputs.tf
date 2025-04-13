output "efs_id" {
  value = module.efs.efs_id
}

output "efs_access_point_arn" {
  value = module.efs.access_point_arn
}

output "execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.main.id
}

output "ecs_sg_ids" {
  value = module.vpc.ecs_sg_ids
}

