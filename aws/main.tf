provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

resource "aws_instance" "my_web_app" {
  ami = "ami-005e54dee72cc1d00"

  instance_type = "m5.8xlarge"

  tags = {
    Environment = "production"
    Service     = "web-app"
    Name        = "dash"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 3000
    iops        = 16000
    throughput  = 1000
  }
}

resource "aws_ebs_volume" "app_data" {
  availability_zone = "us-east-1a"
  size              = 2500
  type              = "gp3"
  iops              = 12000
  throughput        = 500

  tags = {
    Name        = "dash-app-data"
    Environment = "production"
  }
}

resource "aws_s3_bucket" "app_logs" {
  bucket = "travis584-example-terraform-tfc-poc-logs"

  tags = {
    Name        = "dash-app-logs"
    Environment = "production"
  }
}

resource "aws_s3_bucket_versioning" "app_logs" {
  bucket = aws_s3_bucket.app_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "app_logs" {
  bucket = aws_s3_bucket.app_logs.id

  rule {
    id     = "archive-old-logs"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_dynamodb_table" "sessions" {
  name           = "dash-sessions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 250
  write_capacity = 250
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_efs_file_system" "shared" {
  creation_token                  = "dash-shared"
  throughput_mode                 = "provisioned"
  provisioned_throughput_in_mibps = 256

  tags = {
    Name        = "dash-shared"
    Environment = "production"
  }
}

resource "aws_sqs_queue" "jobs" {
  name                       = "dash-jobs"
  visibility_timeout_seconds = 300
  message_retention_seconds  = 1209600
}

resource "aws_cloudwatch_log_group" "lambda_hello" {
  name              = "/aws/lambda/test"
  retention_in_days = 365
}

resource "aws_lambda_function" "my_hello_world" {
  runtime       = "nodejs12.x"
  handler       = "exports.test"
  image_uri     = "test"
  function_name = "test"
  role          = "arn:aws:ec2:us-east-1:123123123123:instance/i-1231231231"

  memory_size     = 3008
  timeout         = 60
  reserved_concurrent_executions = 10
  tags = {
    Environment = "Prod"
  }
}

