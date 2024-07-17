provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_names" {
  description = "List of S3 bucket names"
  type        = list(string)
}

resource "random_id" "bucket_id" {
  count = length(var.bucket_names)
  byte_length = 4
}

resource "aws_s3_bucket" "buckets" {
  for_each = { for idx, name in var.bucket_names : name => random_id.bucket_id[idx].hex }

  bucket = "${each.key}-${each.value}"

  # Optionally, you can add other configurations for the S3 bucket
  tags = {
    Name = each.key
  }
}
