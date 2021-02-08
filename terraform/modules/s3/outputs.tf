output "s3_bucket_arn" {
  value       = aws_s3_bucket.fw_internal_tfstate_bucket.arn
  description = "The ARN of the s3 bucket"
}

