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

# VPC Module (network resources like VPC, subnets, IGW, route tables)
module "vpc" {
  source = "./Network"
}

# EFS Module (EFS filesystem, mount targets, and related SGs)
module "efs" {
  source = "./efs"
}

# ECS Module (task definitions, services, containers)
module "ecs_nodejs" {
  source = "./ecs"
}

module "efs" {
  source = "./efs"
  public_subnet_ids = module.vpc.public_subnets
  efs_sg_id         = module.sg.efs_sg_id
}


# ECS Cluster Definition
resource "aws_ecs_cluster" "main" {
  name = "ecs-monitoring-cluster"
}

# IAM Role for ECS Task Execution
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

# Attach AmazonECSTaskExecutionRolePolicy to the role
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

