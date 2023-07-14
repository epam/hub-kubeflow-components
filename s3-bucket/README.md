#  Create Amazon S3 component with Terraform

This tutorial shows you how to create an Amazon S3 bucket hubctl component using Terraform.

## In This Tutorial

The tutorial covers the following topics:

* How to configure the simple Amazon S3 hubctl component 
* How to configure Terraform for this AWS component 
* How to deploy the stack with Amazon S3 components using Terraform

## About

At the first, let's understand what is the minimum configuration for Amazon S3 component with Terraform.

```text

├── components                           # Directory with components
│    └── s3-bucket                       # Directory with configurations
│        ├── hub-component.yaml          # Component manifest
│        ├── import                      # Special script that to import existing resources into Terraform state
│        └── main.tf                     # Terraform code
└── hub.yaml                             # Stack manifest
```
Read more about Terraform Component [here](../../../reference/components/terraform/)

- A specific configuration defining a stack manifest in `hub.yaml` is the first thing needed. Such a file describes the components and options for deployment.

```shell
kind: stack                                               # mandatory, defines a stack manifest
version: 1                                                # stack manifest schema version
  
requires:                                                 # optional, list of environment requirements 
  - aws

components:                                               # mandatory, list of components
  - name: my-awshubctl-component                          # mandatory, name of the component
    source:                                               # mandatory, component source
      dir: components/s3-bucket                           # mandatory, local path where to find component

extensions:                                               
  init:                                                   # optional, steps activated during `hubctl stack init`
    - aws
  configure:                                              # optional, steps activated during `hubctl stack configure`
    - aws
    - env
  deploy:                                                 # optional, steps activated during `hubctl stack deploy
    before:                                               # optional, steps activated on `hubctl stack deploy` but before actual deployment of components
    - aws
  undeploy:                                               # optional, steps activated during `hubctl stack undeploy
    after:                                                # optional, steps activated on `hubctl stack undeploy` but after actual undeploy of components
    - aws 

```

`hub.yaml` file has `components` field where you describe your components.

- You will also need `hub-component.yaml`, this is a reusable component, it is generic and provides an abstraction with dependencies needed for deployment.

```shell
kind: component                                     # mandatory, defines a component manifest
version: 1                                          # mandatory, manifest schema version

requires:
  - aws
  - terraform

parameters:
  - name: hub.stackName                              # parameter of the stack name
    fromEnv: HUB_STACK_NAME                          # environment variable HUB_STACK_NAME is a name of the stack. It is an unique stack identifier
  - name: bucket.name                                # parameter of the bucket name
    value: "${hub.stackName}"                        # value for the S3 bucket name parameter from hub stack name. This name must be unique for S3
    env: TF_VAR_name                                 # TF_VAR_* environment variable (recommended way), mapping to environment variable for use deployment script
  - name: bucket.acl                                 # parameter of the Access control list (ACL) of the bucket  
    value: "private"                                 # default value is private
    env: TF_VAR_acl                                  # Terraform environment variable for the acl
  - name: cloud.region                               # parameter of the AWS region 
    value: "eu-central-1"                            # default value is region
    fromEnv: AWS_REGION                              # environment variable AWS_REGION. It is an unique stack identifier
  - name: cloud.profile                              # parameter of the specific AWS profile
    value: "default"                                 # the default profile name is default
    fromEnv: AWS_PROFILE                             # environment variable AWS_PROFILE. It is an unique stack identifier
  - name: bucket.region                              # parameter of the AWS bucket region
    value:  ${cloud.region}                          # value for the S3 bucket regin parameter from the cloud region
    env: TF_VAR_bucket_region                        # Terraform environment variable for the bucket region
  - name: aws.serviceAccount                         # parameter of the service account 
    env: TF_VAR_service_account_name                 # Terraform environment variable of the service account name 
    empty: allow

outputs:
  - name: bucket.kind
    value: s3
  - name: bucket.region
    value: ${cloud.region}
    brief: Amazon S3 bucket region   

```
You can provide Terraform variables in two ways. Read more about it [here](../../../reference/components/terraform/#component-conventions)

Hubctl will automatically detect Terraform code when component contains one or more *.tf files. 
Terraform configuration with `main.rf` file:

```shell
# Create a name variable
variable "name" {
  type = string
}

# Create a service_account_name variable
variable "service_account_name" {
  type    = string
  default = ""
}

# Create a acl variable
variable "acl" {
  type = string
  description = "S3 bucket ACL"
}

# Create a region variable
variable "bucket_region" {
  type = string
  description = "s3 bucket region"
}

# Configure private bucket with versioning enabled, tags and website  
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.name
  acl    = var.acl   

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  
  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
  
  versioning = {
    enabled = false
  }
 
  tags = {
    Name        = "Hubctl bucket"
    Environment = "Dev"
  }
}
```

The `import` file is a necessary step to allow manage resources such as AWS S3 bucket. It is a special script that to import existing resources into Terraform state.

```shell
#!/bin/sh -e
# shellcheck disable=SC2154

if gsutil -q ls -b "gs://$TF_VAR_name" > /dev/null 2>&1; then
  terraform import 'aws_storage_bucket._' "$TF_VAR_name" || true
fi

```

## Deploy Stack with Amazon S3 Component

You are now ready to run a deployment from the directory where hub.yaml is located.
The following commands are used for this:

- `hubctl stack init` - this command initializes the working directory with the `hub.yaml` file.
```shell
hubctl stack init
```

- `hubctl stack configure` - stack configuration before deployment
```shell
hubctl stack configure
```

- `hubctl stack deploy` - Runs a deployment for the entire stack, or updates the deployment of one or more components.
```shell
hubctl stack deploy
```

As a result, you could see the Amazon S3 bucket with the following command:

```shell
aws s3 ls
```

## Add Terraform Outputs 

Create a file called `outputs.tf` in your components/s3-bucket directory. Add the configuration below to outputs.tf to define outputs for your S3 bucket's ID, Region, Website Endpoint and Website Domain .

```shell
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
```
- Inspect output values
  Terraform stores output values in the configuration's state file. In order to see these outputs, you need to update the state by applying this new configuration, even though the infrastructure will not change.
Deploy your infrastructure with following commands:
```shell
hubctl stack configure
```
```shell
hubctl stack deploy
```

Notice the output after the apply:

```text
##Outputs:

# s3_bucket_name = "unique-bucket-name"
# s3_bucket_region = "eu-central-1"
# s3_bucket_website_domain = "s3-website.eu-central-1.amazonaws.com"
# s3_bucket_website_endpoint = "unique-bucket-name.s3-website.eu-central-1.amazonaws.com"
```

You can destroy your infrastructure with following commands:

```shell
hubctl stack undeploy
```

### Conclusions

In this tutorial, you create the simple Amazon S3 bucket hubctl. Use Terraform to configure this AWS component.


### See also
- [Terraform Component](../../../reference/components/terraform/) 
- [Article about AWS Components](../../../reference/design/aws/)

