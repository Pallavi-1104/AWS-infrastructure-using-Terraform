terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.6.6"
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./network"

  availability_zones    = ["us-east-1a", "us-east-1b"]   # Adjust as per your region
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
}

# EFS Module
module "efs" {
  source = "./efs"
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "ecs-monitoring-cluster"
}

# ECS Module with Containers
module "ecs_nodejs" {
  source = "./ecs"

  ecs_cluster_id       = aws_ecs_cluster.main.id
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [aws_security_group.ecs_service_sg.id]  # Assuming this is defined somewhere
  file_system_id       = module.efs.file_system_id
  efs_access_point_arn = module.efs.access_point_arn
  execution_role_arn   = aws_iam_role.ecs_task_execution_role.arn
}


resource "aws_ecs_task_definition" "nodejs" {
  family                   = "nodejs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([{
    name      = "nodejs-app"
    image     = "your-nodejs-image"  # Replace this with the correct image
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
    mountPoints = [{
      sourceVolume  = "nodejs-volume"
      containerPath = "/mnt/data"
    }]
  }])

  volume {
    name = "nodejs-volume"
    efs_volume_configuration {
      file_system_id          = var.file_system_id
      transit_encryption      = "ENABLED"
      authorization_config {
        access_point_id = split("/", var.efs_access_point_arn)[length(split("/", var.efs_access_point_arn)) - 1]
        iam             = "ENABLED"
      }
    }
  }
}



