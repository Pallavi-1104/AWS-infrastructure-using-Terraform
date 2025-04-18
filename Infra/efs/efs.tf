resource "aws_efs_file_system" "this" {
  creation_token = "efs-${var.name}"
  performance_mode = var.performance_mode

  tags = {
    Name = var.name
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.subnet_ids[count.index]
  security_groups = [var.ecs_sg_id]

  # Mount targets don't support 'tags' directly in this resource
  # Apply tags at the file system level or handle it post-creation
}

resource "aws_security_group_rule" "ecs_service" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.ecs_sg_id
}

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg"
  description = "Allow traffic for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg"
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/data"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }
}

output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "efs_access_point_arn" {
  value = aws_efs_access_point.this.arn
}







