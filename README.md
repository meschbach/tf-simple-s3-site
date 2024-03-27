# Simple S3 Site
Terraform module to deploy a simple static site via S3 and fronted with CloudFront.  Theoretically this will result in
$0.00 charges for delivery.  Storage will become your dominate segment.

## Features
* Private S3 storage bucket
* HTTPS certificate for your domain issued via Amazon's free ACM.
* AWS IAM role to deploy to the bucket.
* `index.html` [rewriting for URLs ending with a `/`](redirect.js), allowing for compatability with standard web
development practices.

## Inputs
Please look at [input.tf](input.tf) for a comprehensive list.  Please note the following:
* You'll need to configure an AWS provider to specifically run in `us-east-1` for the certificate.  This is required by
[AWS's CloudFront]().
* Hosted zone must be a zone within Route 53.  The zone will have entries for DNS based certificate authorization and
eventually contain both `A` and `AAAA` (IPv6) entries for CloudFront.
* `Price Class 200` is used to distribute to North America and Europe.  All countries are allowed.  This may change in
future version of the module.

## Outputs
* `deployer` contains an object with the access key ID and secret to write to the bucket.

# Example
```terraform
module "spa" {
  source = "git::https://github.com/meschbach/tf-simple-s3-site.git#v0.0.1"
  bucket = "website-com-example"
  hostnames = ["example.com"]
  hosted_zone = "example.com"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
}

resource "aws_route53_zone" "com_example" {
  name = "example.com"
  comment = "Example website"
}
```

# Philosophy
(steps up on my soapbox and clears throat)

This module aims to provide a simple interface to providing the minimal viable target.  There are a number of great
modules with a ton of tuning knobs which are very hard to understand.  This aims to be simple straight forward
module to accomplish just serving a static website.
