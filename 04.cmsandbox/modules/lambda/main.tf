
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${var.lambda_zip_path}/efs_loader.py"
  output_path = "${var.lambda_zip_path}/efs_loader.zip"
}


resource "aws_lambda_function" "efs_loader" {
  function_name = var.function_name
  description   = var.function_description
  role          = aws_iam_role.lambda_efs_loader.arn
  handler       = "efs_loader.lambda_handler"
  runtime       = "python3.11"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      S3_BUCKET_NAME     = var.s3_bucket_name
    }
  }

  file_system_config {
    arn              = var.efs_access_point_arn
    local_mount_path = "/mnt/efs"
  }

  timeout = 300
  memory_size = 512

  tags = {
    Name        = "efs-loader-lambda",
    Environment = var.environment
  }
}

resource "aws_iam_role" "lambda_efs_loader" {
  name = "${var.function_name}-role-steven"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_efs_loader.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "efs_s3_access" {
  name = "efs-s3-access"
  role = aws_iam_role.lambda_efs_loader.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
       {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject"
        ],
        Resource = "*"
      },
      {
        Sid = "EFSMountPermissions",
        Action   = [
          "elasticfilesystem:ClientMount", 
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRootAccess"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

