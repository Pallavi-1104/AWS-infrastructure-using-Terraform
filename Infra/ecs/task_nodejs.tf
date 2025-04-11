resource "aws_ecs_task_definition" "nodejs" {
  family                   = "nodejs-task"
  requires_compatibilities = ["EC2"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "nodejs"
      image     = "node:18"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ],
      mountPoints = [
        {
          containerPath = "/data"
          sourceVolume  = "efs-data"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name = "efs-data"
    efs_volume_configuration {
      file_system_id          = var.file_system_id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
    }
  }
}

resource "aws_ecs_service" "nodejs" {
  name            = "nodejs-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.nodejs.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.nodejs]
}
