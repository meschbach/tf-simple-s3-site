variable "bucket" {
  type        = string
  description = "Name of the S3 bucket used for static site hosting"
}

variable "hosted_zone" {
  type        = string
  description = "Route53 hosted zone name for DNS records and certificate validation"
}

variable "hostnames" {
  type        = list(string)
  description = "DNS hostnames for the CloudFront distribution. The first entry is used as the primary ACM certificate domain; additional entries become Subject Alternative Names"
  validation {
    condition     = length(var.hostnames) > 0
    error_message = "At least one hostname must be provided."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
  default     = {}
}

variable "redirect_404_spa" {
  type        = bool
  description = "When true, 403 and 404 errors return 200 with /index.html to support SPA client-side routing"
  default     = false
}
