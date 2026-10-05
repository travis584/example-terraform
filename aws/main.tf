provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

resource "aws_instance" "my_web_app" {
  ami = "ami-005e54dee72cc1d00"

  instance_type = "m6i.12xlarge"

  tags = {
    Environment = "production"
    Service     = "web-app"
    Name        = "dash"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 4000
    iops        = 16000
    throughput  = 1000
  }
}

resource "aws_ebs_volume" "app_data" {
  availability_zone = "us-east-1a"
  size              = 4000
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
  read_capacity  = 500
  write_capacity = 500
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
  provisioned_throughput_in_mibps = 512

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

resource "aws_kinesis_stream" "events" {
  name             = "dash-events"
  shard_count      = 16
  retention_period = 168
}

resource "aws_sns_topic" "alerts" {
  name = "dash-alerts"
}

resource "aws_secretsmanager_secret" "app_config" {
  name                    = "dash/app-config"
  recovery_window_in_days = 30
}

resource "aws_ecr_repository" "app" {
  name = "dash-app"
}

resource "aws_athena_workgroup" "analytics" {
  name = "dash-analytics"

  configuration {
    bytes_scanned_cutoff_per_query = 10737418240
  }
}

resource "aws_opensearch_domain" "search" {
  domain_name    = "dash-search"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type  = "r6g.xlarge.search"
    instance_count = 5
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 500
    volume_type = "gp3"
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_route53_zone" "app" {
  name = "dash-poc.example"
}

resource "aws_apigatewayv2_api" "http" {
  name          = "dash-http"
  protocol_type = "HTTP"
}

resource "aws_cloudwatch_event_bus" "custom" {
  name = "dash-custom-events"
}

resource "aws_sfn_state_machine" "workflows" {
  name     = "dash-workflows"
  role_arn = "arn:aws:iam::123123123123:role/dash-sfn"

  definition = jsonencode({
    Comment = "dash"
    StartAt = "Pass"
    States = {
      Pass = {
        Type = "Pass"
        End  = true
      }
    }
  })
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

  memory_size     = 10240
  timeout         = 60
  reserved_concurrent_executions = 10
  tags = {
    Environment = "Prod"
  }
}

