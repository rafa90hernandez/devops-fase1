# S3 Bucket (sempre)
resource "aws_s3_bucket" "artifacts" {
  bucket = var.bucket_name
  tags = { Project = "devops-fase1" }
}

# ====== SOMENTE QUANDO create_ec2 = true ======

# Datasources VPC/Subnets/AMI (só se create_ec2 = true)
data "aws_vpc" "default" {
  count   = var.create_ec2 ? 1 : 0
  default = true
}

data "aws_subnets" "default" {
  count = var.create_ec2 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default[0].id]
  }
}

data "aws_ami" "amzn2" {
  count       = var.create_ec2 ? 1 : 0
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "api_sg" {
  count       = var.create_ec2 ? 1 : 0
  name        = "devops-fase1-api-sg"
  description = "Allow inbound on 3000/tcp"
  vpc_id      = data.aws_vpc.default[0].id

  ingress {
    description = "HTTP app port"
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

resource "aws_instance" "api" {
  count                  = var.create_ec2 ? 1 : 0
  ami                    = data.aws_ami.amzn2[0].id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.default[0].ids, 0)
  vpc_security_group_ids = [aws_security_group.api_sg[0].id]

  user_data = <<-EOF
              #!/bin/bash
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs git
              EOF

  tags = { Name = "devops-fase1-api" }
}
