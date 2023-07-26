output "s3_bucket_region" {
  value       = module.s3_bucket.s3_bucket_region
  description = "The AWS region this bucket resides in."
}

output "s3_bucket_endpoint" {
  value = local.s3_endpoint
}
