terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.90"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_s3_bucket" "media" {
  bucket = "${local.name_prefix}-media"
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${local.name_prefix}-api"
  retention_in_days = 30
}

resource "aws_secretsmanager_secret" "api_runtime" {
  name = "${local.name_prefix}-api-runtime"
}

output "media_bucket_name" {
  value = aws_s3_bucket.media.bucket
}
