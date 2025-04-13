resource "aws_ecs_task_definition" "grafana" {
  family                   = "grafana-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = "grafana/grafana:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ],
      mountPoints = [
        {
          containerPath = "/var/lib/grafana"
          sourceVolume  = "grafana-efs"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name = "grafana-efs"
    efs_volume_configuration {
      file_system_id     = var.file_system_id
      root_directory     = "/grafana"
      transit_encryption = "ENABLED"
    }
  }
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.grafana.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.grafana]
}
