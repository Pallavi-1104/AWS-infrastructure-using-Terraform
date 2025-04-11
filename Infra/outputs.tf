output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "mongo_efs_id" {
  value = module.efs.mongo_efs_id
}

output "efs_access_point_arn" {
  value = module.efs.efs_access_point_arn
}
