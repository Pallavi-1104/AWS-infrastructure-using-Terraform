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
  security_groups = [var.ecs_sg_id]  # Pass ecs_sg_id as a variable

  tags = {
    Name = "efs-mount-target-${count.index}"
  }
}

# This is a separate resource to apply tags after the mount target is created
resource "aws_security_group_rule" "ecs_service" {
  # Example to create ECS security group rules if needed
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = var.ecs_sg_id
}

resource "aws_security_group" "ecs_service" {
  # ECS Security Group configuration if not already created
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

# Tagging for the mount targets after creation
resource "aws_efs_mount_target_tag" "efs_mount_tag" {
  count = length(var.subnet_ids)

  mount_target_id = aws_efs_mount_target.this[count.index].id

  tags = {
    Name = "efs-mount-target-${count.index}"
  }
}



