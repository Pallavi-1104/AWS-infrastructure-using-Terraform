resource "aws_efs_file_system" "mongo_efs" {
  creation_token = "mongo-efs"
  tags = {
    Name = "mongo-efs"
  }
}

resource "aws_efs_mount_target" "mongo_efs_target" {
  count           = length(var.public_subnet_ids)
  file_system_id  = aws_efs_file_system.mongo_efs.id
  subnet_id       = var.public_subnet_ids[count.index]
  security_groups = [var.efs_sg_id]
}

resource "aws_efs_access_point" "mongo_access_point" {
  file_system_id = aws_efs_file_system.mongo_efs.id
  root_directory {
    path = "/mongo-data"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "750"
    }
  }
}

output "mongo_efs_id" {
  value = aws_efs_file_system.mongo_efs.id
}

output "efs_access_point_arn" {
  value = aws_efs_access_point.mongo_access_point.arn
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "efs_sg_id" {
  type = string
}


