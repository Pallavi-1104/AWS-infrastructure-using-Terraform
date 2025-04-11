resource "aws_ecs_task_definition" "prometheus" {
  family                   = "prometheus-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = "prom/prometheus:latest"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/prometheus"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      command = [
        "--config.file=/etc/prometheus/prometheus.yml"
      ]
      mountPoints = [
        {
          sourceVolume  = "prometheus-config"
          containerPath = "/etc/prometheus"
          readOnly      = false
        }
      ]
    }
  ])

  volume {
    name = "prometheus-config"
    host_path {
      path = "/ecs/prometheus-config"
    }
  }
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}