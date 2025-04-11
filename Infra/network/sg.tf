resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS access for EFS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}

