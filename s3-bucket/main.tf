variable "name" {
  type = string
}

locals {
  s3_endpoint = "s3.${module.s3_bucket.s3_bucket_region}.amazonaws.com"
}

variable "acl" {
  type        = string
  description = "S3 bucket ACL"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = var.name
  acl                      = var.acl
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  tags = {
    Name        = "Hubctl bucket"
    Environment = "Dev"
  }
}
