variable "with_policy" {
  description = "If set to `true`, the bucket will be created with a bucket policy."
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "The Name tag to set for the S3 Bucket."
  type        = string
  default     = "Test Bucket"
}

variable "tag_bucket_environment" {
  description = "The Environment tag to set for the S3 Bucket."
  type        = string
  default     = "Test"
}

variable "files_timestamp" {
  description = "a list with all the files are going to be created"
  type = list
  default = ["file1.txt","file2.txt"]
}