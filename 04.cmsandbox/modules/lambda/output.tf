output "lambda_function_name" {
  value = aws_lambda_function.efs_loader.function_name
}

output "debug_lambda_efs_config" {
  value = {
    access_point_arn = var.efs_access_point_arn
    file_system_arn  = var.efs_file_system_arn
  }
}