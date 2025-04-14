aws_region = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
execution_role_arn = "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_EXECUTION_ROLE"
file_system_id = "fs-xxxxxx"
efs_access_point_arn = "arn:aws:elasticfilesystem:region:account-id:access-point/fsap-xxxxxx"
nodejs_image = "your-nodejs-image:latest"
