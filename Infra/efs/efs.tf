resource "aws_efs_file_system" "this" {
  creation_token = "my-efs"
  encrypted      = true
}

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.efs_sg_id]
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


