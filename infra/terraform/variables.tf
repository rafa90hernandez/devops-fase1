variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2" # alinhado com seus Secrets/CI
  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region não pode ser vazio."
  }
}

variable "bucket_name" {
  description = "Nome único para o bucket S3"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "bucket_name deve ter 3–63 caracteres, minúsculos, números, ponto ou hífen."
  }
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

variable "enable_apprunner" {
  description = "Cria o App Runner (custa por minuto). Mantenha false por padrão."
  type        = bool
  default     = false
}

variable "apprunner_cpu" {
  description = "CPU do App Runner (use o menor permitido)."
  type        = string
  default     = "1024"
  validation {
    condition     = contains(["1024","2048"], var.apprunner_cpu)
    error_message = "apprunner_cpu deve ser 1024 ou 2048."
  }
}

variable "apprunner_memory" {
  description = "Memória do App Runner (use o menor permitido)."
  type        = string
  default     = "2048"
  validation {
    condition     = contains(["2048","3072","4096"], var.apprunner_memory)
    error_message = "apprunner_memory deve ser 2048, 3072 ou 4096."
  }
}
