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
      image     = "prom/prometheus"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
        }
      ]
    }
  ])
}