variable "bucket" {
  type = string
}

variable "hosted_zone" {
  type        = string
  description = "Domain name matching the root"
}

variable "hostnames" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.42.0"
      configuration_aliases = [aws.us_east_1]
    }
  }
}
