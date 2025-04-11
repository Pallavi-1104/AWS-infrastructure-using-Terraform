resource "aws_ecs_task_definition" "mongodb" {
  family                   = "mongodb-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  volume {
    name = "mongo-data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongo_efs.id
      root_directory = "/"
      transit_encryption = "ENABLED"
    }
  }
  container_definitions   = jsonencode([
    {
      name      = "mongodb"
      image     = "mongo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 27017
          hostPort      = 27017
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "mongo-data"
          containerPath = "/data/db"
          readOnly      = false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/mongodb"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "mongodb" {
  name            = "mongodb-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.mongodb.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
