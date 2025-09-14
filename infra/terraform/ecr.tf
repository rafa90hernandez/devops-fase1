resource "aws_ecr_repository" "app" {
  name                 = "devops-fase1-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}
