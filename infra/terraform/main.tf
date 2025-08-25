# S3 Bucket (obrigatório)
resource "aws_s3_bucket" "artifacts" {
  bucket = var.bucket_name

  tags = {
    Project = "devops-fase1"
  }
}

# EC2 + Security Group (opcional)
resource "aws_security_group" "api_sg" {
  count       = var.create_ec2 ? 1 : 0
  name        = "devops-fase1-api-sg"
  description = "Allow inbound on 3000/tcp"
  vpc_id      = data.aws_vpc.default.id

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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_instance" "api" {
  count                       = var.create_ec2 ? 1 : 0
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids      = [aws_security_group.api_sg[0].id]

  user_data = <<-EOF
              #!/bin/bash
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs git
              # placeholder de deploy; ajustar conforme seu repositório
              # git clone <seu-repo> /opt/app && cd /opt/app/app && npm ci && npm start -&
              EOF

  tags = {
    Name = "devops-fase1-api"
  }
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
