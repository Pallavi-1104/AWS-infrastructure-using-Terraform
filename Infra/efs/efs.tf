resource "aws_efs_file_system" "this" {
  creation_token = "my-efs"
  encrypted      = true
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.subnet_ids[count.index]
  security_groups = [aws_security_group.ecs_service.id]

  tags = {
    Name = "efs-mount-target-${count.index}"
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/ecs"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }
}

output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "access_point_arn" {
  value = aws_efs_access_point.this.arn
}


