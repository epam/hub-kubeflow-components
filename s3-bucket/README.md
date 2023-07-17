#  Amazon S3 Bucket

Terraform is an efficient and secure tool designed for creating, modifying, and versioning infrastructure. It enables you to effectively manage a variety of infrastructure providers, including well-known service providers and your own custom in-house solutions.

S3, or Amazon Simple Storage Service, is a highly scalable cloud storage service provided by Amazon Web Services (AWS). S3 provides durability, availability, and scalability for storing and retrieving data.

In the context of Terraform, the "s3 bucket" provider is a Terraform provider that allows you to manage S3 resources, such as S3 buckets, using Terraform configuration files. You can use this provider to create, modify, and delete S3 bucket resources in your AWS account.

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml          # Component manifest
├── import                      # Special script that to import existing resources into Terraform state
└── main.tf                     # Terraform code
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                 | Description                                                                                 | Default Value      |
|:---------------------|:--------------------------------------------------------------------------------------------|:-------------------|
| `bucket.name`        | Value for the S3 bucket name parameter from hub stack name. This name must be unique for S3 | `${hub.stackName}` |
| `bucket.acl `        | Parameter of the Access control list (ACL) of the bucket                                    | private            |
| `bucket.region`      | Parameter of the AWS bucket region                                                          | {cloud.region}     |
| `aws.serviceAccount` | Name of AWS service account. If not set then access and secret key won't be created         |                    |


> Note: `bucket.region` parameter can be set by modifying `cloud.region` using the `hubctl stack configure` command.

> Note: parameters has been passed to terraform as `TF_VAR_*` environment variables

## Outputs

The following component level parameters has been defined `hub-component.yaml`

The outputs are written in the file output.tf

| Name                         | Description                                                                                            | Default Value                               |
|:-----------------------------|:-------------------------------------------------------------------------------------------------------|:--------------------------------------------|
| `s3_bucket_name`             | The name of the bucket                                                                                 | module.s3_bucket.s3_bucket_id               |
| `s3_bucket_region`           | The AWS region this bucket resides in                                                                  | module.s3_bucket.s3_bucket_region           |
| `s3_bucket_website_endpoint` | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string | module.s3_bucket.s3_bucket_website_endpoint |
| `s3_bucket_website_domain`   | Name of the website bucket                                                                             | module.s3_bucket.s3_bucket_website_domain   |

