# Amazon S3 Bucket

S3, or Amazon Simple Storage Service, is a highly scalable cloud storage service provided by Amazon Web Services (AWS).
S3 provides durability, availability, and scalability for storing and retrieving data.

Terraform is an efficient and secure tool designed for creating, modifying, and versioning infrastructure. It enables
you to effectively manage a variety of infrastructure providers, including well-known service providers and your own
custom in-house solutions.

In the context of Terraform, the "s3 bucket" provider is a Terraform provider that allows you to manage S3 resources,
such as S3 buckets, using Terraform configuration files. You can use this provider to create, modify, and delete S3
bucket resources in your AWS account.

## TL:DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: s3-bucket
    source:
      dir: components/s3-bucket
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: s3-bucket
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c s3-bucket
```

## Requirements

* [AWS](https://aws.amazon.com/)
* [Terraform](https://www.terraform.io/)

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name            | Description                                                                                 | Default Value  | Required |
|-----------------|---------------------------------------------------------------------------------------------|----------------|:--------:|
| `bucket.name`   | Value for the S3 bucket name parameter from hub stack name. This name must be unique for S3 | HUB_STACK_NAME |          |
| `bucket.acl `   | Parameter of the Access control list (ACL) of the bucket                                    | `private`      |          |
| `bucket.region` | Parameter of the AWS bucket region                                                          | {cloud.region} |          |
| `cloud.region`  | AWS region that uses hubctl                                                                 | `eu-central-1` |   `x`    |
| `cloud.profile` | AWS profile that uses hubctl                                                                | `default`      |   `x`    |

> Note: `bucket.region` parameter can be set by modifying `cloud.region` using the `hubctl stack configure` command.

> Note: parameters has been passed to terraform as `TF_VAR_*` environment variables

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml          # configuration and parameters file of Hub component
├── import                      # special script that to import existing resources into Terraform state
└── main.tf                     # terraform template
```

Deployment follows to the following algorithm:

1. The `pre-deploy` script will use AWS parameters such as `aws-region` and `aws-profile` to checking the connection to
   AWS and presence of Route 53 hosted zone for `HUB_DOMAIN_NAME`. To do this, you need to add a hubctl `extensions`
   section for `deploy` `before`: `- aws` in  `hub.yaml`.
3. Then start `s3-bucket` deployment

## Outputs parameters from Terraform

The following component level parameters has been defined `hub-component.yaml`

The outputs are written in the file output.tf

| Name                 | Description                                                       | Default Value                                         |
|:---------------------|:------------------------------------------------------------------|:------------------------------------------------------|
| `s3_bucket_region`   | The AWS region this bucket resides in                             | module.s3_bucket.s3_bucket_region                     |
| `s3_bucket_endpoint` | The endpoint is the URL of the entry point for an AWS web service | http://s3.${module.s3_bucket.s3_bucket_region}.amazonaws.com |

## See also

* [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
* [Variables and Outputs Terraform](https://developer.hashicorp.com/terraform/language/values)
* [AWS S3 bucket Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest)
