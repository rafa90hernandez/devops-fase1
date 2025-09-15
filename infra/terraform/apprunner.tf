resource "aws_iam_role" "apprunner_ecr_access" {
  count = var.enable_apprunner ? 1 : 0

  name = "apprunner-ecr-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "build.apprunner.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "apprunner_ecr_policy" {
  count = var.enable_apprunner ? 1 : 0

  name = "apprunner-ecr-policy"
  role = aws_iam_role.apprunner_ecr_access[0].id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_apprunner_service" "api" {
  count        = var.enable_apprunner ? 1 : 0
  service_name = "devops-fase1-api"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access[0].arn
    }
    image_repository {
      image_identifier      = "${aws_ecr_repository.app.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port                          = "3000"
        runtime_environment_variables = { NODE_ENV = "production" }
      }
    }
    auto_deployments_enabled = true
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    healthy_threshold   = 1
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
  }

  instance_configuration {
    cpu    = var.apprunner_cpu
    memory = var.apprunner_memory
  }
}

output "apprunner_service_url" {
  value = var.enable_apprunner ? aws_apprunner_service.api[0].service_url : ""
}

output "apprunner_service_arn" {
  value = var.enable_apprunner ? aws_apprunner_service.api[0].arn : ""
}
