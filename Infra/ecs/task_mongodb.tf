resource "aws_ecs_task_definition" "mongodb" {
  family                   = "mongodb-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  volume {
    name = "mongo-data"
    efs_volume_configuration {
      file_system_id = var.file_system_id
    }
  }

  container_definitions = jsonencode([
    {
      name      = "mongodb"
      image     = "mongo:latest"
      cpu       = 256
      memory    = 512
      essential = true
      mountPoints = [{
        containerPath = "/data/db"
        sourceVolume  = "mongo-data"
      }]
      portMappings = [{ containerPort = 27017 }]
    }
  ])
}