resource "aws_efs_file_system" "mongo_efs" {
  creation_token = "mongo-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name = "mongo-efs"
  }
}

resource "aws_efs_mount_target" "mongo_efs_target" {
  count           = length(var.public_subnet_ids)
  file_system_id  = aws_efs_file_system.mongo_efs.id
  subnet_id       = var.public_subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

output "efs_id" {
  value = aws_efs_file_system.mongo_efs.id
}



