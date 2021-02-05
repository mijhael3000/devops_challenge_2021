# Terraform configuration

provider "aws" {
  region = "us-west-2"
}


resource "aws_s3_bucket" "test_bucket" {
  bucket = local.bucket_name

  acl    = "public-read"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }
    ]
}
EOF

  tags = {
    Environment = var.tag_bucket_environment
  }
}


resource "aws_s3_bucket_object" "files" {
  for_each = toset(var.files_timestamp)
  bucket = local.bucket_name
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
  bucket_name="${local.aws_account_id}-${var.bucket_name}"
}