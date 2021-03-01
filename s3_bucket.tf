# Terraform configuration

resource "aws_s3_bucket" "test_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = var.tag_bucket_environment
  }
}


resource "aws_s3_bucket_object" "files" {
  for_each = toset(var.files_timestamp)
  bucket = var.bucket_name
  key    = each.key
  content = <<EOF
  ${timestamp()}
  EOF
  content_type = "text/html"

  depends_on = [aws_s3_bucket.test_bucket]

}

data "aws_caller_identity" "current" {
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  bbucket_name="${local.aws_account_id}-${var.bucket_name}"
}