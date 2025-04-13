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

# Add tags for mount targets separately
resource "aws_tags" "efs_mount_target_tags" {
  count = length(var.subnet_ids)
  
  resource_id = aws_efs_mount_target.this[count.index].id
  tags = {
    Name = "efs-mount-target-${count.index}"
  }
}






