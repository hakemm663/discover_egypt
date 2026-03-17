output "log_group_name" {
  value = aws_cloudwatch_log_group.api.name
}

output "runtime_secret_arn" {
  value = aws_secretsmanager_secret.api_runtime.arn
}
