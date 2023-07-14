output "s3_bucket_name" {
  value       = module.s3_bucket.s3_bucket_id
  description = "The name of the bucket."
}

output "s3_bucket_region" {
  value       = module.s3_bucket.s3_bucket_region
  description = "The AWS region this bucket resides in."
}

output "s3_bucket_website_endpoint" {
  value       = module.s3_bucket.s3_bucket_website_endpoint
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
}

output "s3_bucket_website_domain" {
  value       = module.s3_bucket.s3_bucket_website_domain
  description = "Name of the website bucket"
}
