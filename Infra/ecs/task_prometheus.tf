resource "aws_ecs_task_definition" "prometheus" {
  family                   = "prometheus-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = "prom/prometheus:latest"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
        }
      ],
      mountPoints = [
        {
          containerPath = "/prometheus"
          sourceVolume  = "prometheus-efs"
          readOnly      = false
        }
      ],
      healthCheck = {
        command     = ["CMD-SHELL", "wget --spider -q http://localhost:9090/-/healthy || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  volume {
    name = "prometheus-efs"
    efs_volume_configuration {
      file_system_id     = var.file_system_id
      root_directory     = "/prometheus"
      transit_encryption = "ENABLED"
    }
  }
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.prometheus.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.prometheus]
}

