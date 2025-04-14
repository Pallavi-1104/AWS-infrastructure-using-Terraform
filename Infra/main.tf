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
}

# EFS Module
module "efs" {
  source = "./efs"
  # Add variables here if needed
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

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
module "ecs" {
  source = "./ecs"
  ...
  execution_role_arn  = aws_iam_role.ecs_task_execution_role.arn
  efs_id              = module.efs.efs_id
  efs_access_point_id = module.efs.efs_access_point_id
  nodejs_image        = "your-nodejs-image" # replace with actual image
}

# Output for visibility
output "efs_access_point_arn" {
  value = module.efs.efs_access_point_arn
}
