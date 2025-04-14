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
  
  # Add the required arguments
  availability_zones = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# EFS Module
module "efs" {
  source = "./efs"
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Security Group
resource "aws_security_group" "ecs_service_sg" {
  name   = "ecs_service_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "ecs-monitoring-cluster"
}

# ECS Module with Containers (Final ECS Module)
module "ecs_nodejs" {
  source = "./ecs"

  ecs_cluster_id       = aws_ecs_cluster.main.id
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [aws_security_group.ecs_service_sg.id]
  efs_id               = module.efs.efs_id
  efs_access_point_id  = module.efs.efs_access_point_id
  execution_role_arn   = aws_iam_role.ecs_task_execution_role.arn
  nodejs_image         = "your-nodejs-image:latest"
}

# Output for EFS ARN
output "efs_access_point_arn" {
  value = module.efs.efs_access_point_arn
}


