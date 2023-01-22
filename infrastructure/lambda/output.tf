output "function_url" {
  value = resource.aws_lambda_function_url.GBC_lambda_url.function_url
}

output "func_role" {
  value = resource.aws_iam_role.GBC_lambda_iam_role.arn
}