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

module "vpc" {
  source = "./network"

  availability_zones    = ["us-east-1a", "us-east-1b"]   # Adjust as per your region
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
}


# EFS Module
module "efs" {
  source = "./efs"

  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  ecs_sg_id          = module.vpc.ecs_sg_ids  # Pass the security group ID here
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

  execution_role_arn   = aws_iam_role.ecs_task_execution_role.arn
  file_system_id       = module.efs.efs_id
  efs_access_point_arn = module.efs.access_point_arn
  subnet_ids           = module.vpc.public_subnet_ids
  ecs_cluster_id       = aws_ecs_cluster.main.id
  security_group_ids   = module.vpc.ecs_sg_ids
}

