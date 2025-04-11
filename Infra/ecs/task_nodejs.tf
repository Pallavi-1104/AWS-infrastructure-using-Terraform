resource "aws_ecs_task_definition" "nodejs" {
  family                   = "nodejs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name      = "nodejs"
      image     = "node:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}
