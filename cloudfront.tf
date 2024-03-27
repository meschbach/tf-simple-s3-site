locals {
  cloudfront_id = var.bucket
}

resource "aws_cloudfront_distribution" "export" {
  origin {
    domain_name              = aws_s3_bucket.storage.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.cloudfront_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.bucket} static site serving"
  default_root_object = "index.html"

  aliases = var.hostnames

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.cloudfront_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    #    viewer_protocol_policy = "redirect-to-https"
    viewer_protocol_policy = "allow-all"
    min_ttl                = 1
    default_ttl            = 60
    max_ttl                = 60
  }

  price_class = "PriceClass_100"

  tags = var.tags

  restrictions {
    geo_restriction {
      # TODO: Revisit
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.hosting.arn
    ssl_support_method  = "sni-only"
  }

  wait_for_deployment = false
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.bucket}-default"
  description                       = "Default policy for accessing S3 for contents of ${var.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
