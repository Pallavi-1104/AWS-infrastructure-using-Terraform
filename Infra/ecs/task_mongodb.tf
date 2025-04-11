resource "aws_ecs_task_definition" "mongodb" {
  family                   = "mongodb-task"
  requires_compatibilities = ["EC2"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "mongodb"
      image     = "mongo:6"
      essential = true
      portMappings = [
        {
          containerPort = 27017
          hostPort      = 27017
        }
      ],
      mountPoints = [
        {
          containerPath = "/data/db"
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

resource "aws_ecs_service" "mongodb" {
  name            = "mongodb-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.mongodb.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.mongodb]
}
