variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome único para o bucket S3"
  type        = string
}

variable "create_ec2" {
  description = "Cria ou não uma EC2 para testes"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "Tipo da instância EC2 (se create_ec2 = true)"
  type        = string
  default     = "t3.micro"
}
