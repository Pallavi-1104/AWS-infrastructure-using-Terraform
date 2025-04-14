resource "aws_ecs_task_definition" "nodejs" {
  family                   = "nodejs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "nodejs-app",
      image     = var.nodejs_image,
      essential = true,
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "nodejs-volume",
          containerPath = "/mnt/data"
        }
      ]
    }
  ])

  volume {
    name = "nodejs-volume"

    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = var.efs_access_point_id
        iam             = "ENABLED"
      }
    }
  }
}





