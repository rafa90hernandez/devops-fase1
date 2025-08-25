output "s3_bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = aws_s3_bucket.artifacts.bucket
}

output "ec2_public_ip" {
  description = "IP público da instância EC2 (se criada)"
  value       = try(aws_instance.api[0].public_ip, null)
}
