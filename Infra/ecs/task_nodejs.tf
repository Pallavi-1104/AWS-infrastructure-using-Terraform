resource "aws_ecs_task_definition" "nodejs" {
  family                   = "nodejs-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "nodejs-app"
      image     = "node:18-alpine"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{ containerPort = 3000 }]
    }
  ])
}
