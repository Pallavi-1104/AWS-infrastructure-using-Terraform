aws_region = "us-east-1"

availability_zones     = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]

nodejs_image           = "your-nodejs-image:latest"
execution_role_arn     = "arn:aws:iam::<account-id>:role/ecsExecutionRole"
file_system_id         = "fs-0442f0892b311c0c8"
efs_access_point_arn   = "arn:aws:elasticfilesystem:region:account-id:access-point/fsap-xxxxxxxx"
vpc_id                 = "vpc-xxxxxxxx"
subnet_ids             = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
ecs_sg_id              = "sg-xxxxxxxx"
name                   = "my-efs"
