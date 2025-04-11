resource "aws_efs_file_system" "mongo_efs" {
  creation_token = "mongo-efs"
  tags = {
    Name = "MongoEFS"
  }
}

resource "aws_efs_mount_target" "mongo_efs_target" {
  count          = length(var.public_subnet_ids)
  file_system_id = aws_efs_file_system.mongo_efs.id
  subnet_id      = var.public_subnet_ids[count.index]
  security_groups = [var.efs_sg_id]
}

output "efs_id" {
  value = aws_efs_file_system.mongo_efs.id
}

