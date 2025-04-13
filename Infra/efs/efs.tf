resource "aws_efs_file_system" "example" {
  creation_token = "example-token"
  performance_mode = "generalPurpose"
  encrypted = true
}

resource "aws_efs_access_point" "example" {
  file_system_id = aws_efs_file_system.example.id
  root_directory {
    creation_info {
      owner_gid = 1001
      owner_uid = 1001
      permissions = "750"
    }
    path = "/export/mydata"
  }
}

# Output the ARN of the EFS Access Point
output "access_point_arn" {
  value = aws_efs_access_point.example.arn
}


