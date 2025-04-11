resource "aws_security_group" "ecs_sg" {
  name        = "ecs-tasks-sg"
  description = "Allow inbound traffic to ECS services"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow ALB to ECS"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-tasks-sg"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS access for MongoDB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow NFS from ECS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}

