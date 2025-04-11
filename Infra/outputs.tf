output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "efs_id" {
  value = module.efs.efs_id
}