aws_region           = "us-east-1"

availability_zones   = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

nodejs_image         = "your-nodejs-image:latest"

efs_access_point_arn = "your-efs-access-point-arn"
