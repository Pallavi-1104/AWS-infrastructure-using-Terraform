resource "aws_ecs_task_definition" "nodejs" {
  family                   = "nodejs-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  container_definitions   = jsonencode([
    {
      name      = "nodejs-app"
      image     = "your-dockerhub-user/nodejs-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/nodejs"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "nodejs" {
  name            = "nodejs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nodejs.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nodejs_tg.arn
    container_name   = "nodejs-app"
    container_port   = 3000
  }

  health_check_grace_period_seconds = 60
  depends_on = [aws_lb_listener.http_listener]
}
