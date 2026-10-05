provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

resource "aws_instance" "my_web_app" {
  ami = "ami-005e54dee72cc1d00"

  instance_type = "m5.4xlarge"

  tags = {
    Environment = "production"
    Service     = "web-app"
    Name        = "dash"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 2000
    iops        = 16000
    throughput  = 1000
  }
}

resource "aws_ebs_volume" "app_data" {
  availability_zone = "us-east-1a"
  size              = 1500
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

