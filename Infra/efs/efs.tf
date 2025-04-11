resource "aws_efs_file_system" "mongo_efs" {
  creation_token = "mongo-efs"
  tags = {
    Name = "mongo-efs"
  }
}

resource "aws_efs_mount_target" "mongo_efs_target" {
  count          = length(aws_subnet.public[*].id)
  file_system_id = aws_efs_file_system.mongo_efs.id
  subnet_id      = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}

output "efs_id" {
  value = aws_efs_file_system.mongo_efs.id
}

output "efs_dns" {
  value = aws_efs_file_system.mongo_efs.dns_name
}

