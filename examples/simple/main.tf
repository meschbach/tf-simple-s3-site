data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "simple_site" {
  source = "../.."

  bucket      = var.bucket
  hosted_zone = var.hosted_zone
  hostnames   = var.hostnames
  tags        = var.tags

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}
