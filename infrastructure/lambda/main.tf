resource "aws_iam_role" "GBC_lambda_iam_role" {
  name = var.lambda_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "GBC_lambda_policy" {
  role       = aws_iam_role.GBC_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "GBC_lambda_function" {
  function_name = var.lambda_function_name

  s3_bucket = var.lambda_bucket_id
  s3_key    = aws_s3_object.GBC_lambda_s3_file.key

  runtime = "python3.9"
  handler = var.lamba_handler_function

  source_code_hash = data.archive_file.lambda_file.output_base64sha256

  role = aws_iam_role.GBC_lambda_iam_role.arn
}

resource "aws_cloudwatch_log_group" "GBC_cloudwatch_group" {
  name = "/aws/lambda/${aws_lambda_function.GBC_lambda_function.function_name}"

  retention_in_days = 14
}

data "archive_file" "lambda_file" {
  type = "zip"

  source_dir  = "../functions/${var.lambda_function_name}"
  output_path = "../functions/${var.lambda_function_name}.zip"
}

resource "aws_s3_object" "GBC_lambda_s3_file" {
  bucket = var.lambda_bucket_id

  key    = "${var.lambda_function_name}.zip"
  source = data.archive_file.lambda_file.output_path

  etag = filemd5(data.archive_file.lambda_file.output_path)
}

resource "aws_lambda_function_url" "GBC_lambda_url" {
  function_name      = aws_lambda_function.GBC_lambda_function.function_name
  authorization_type = "NONE"

  cors {
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}