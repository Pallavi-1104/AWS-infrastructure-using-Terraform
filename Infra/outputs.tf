output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "efs_id" {
  value = module.efs.efs_id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}
