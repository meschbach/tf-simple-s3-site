data "aws_route53_zone" "hosted" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.hosting.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.hosted.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_route53_record" "host_a" {
  name            = var.hostnames[0]
  type            = "A"
  zone_id         = data.aws_route53_zone.hosted.zone_id
  allow_overwrite = true

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.export.domain_name
    zone_id                = aws_cloudfront_distribution.export.hosted_zone_id
  }
}

resource "aws_route53_record" "host_aaaa" {
  name            = var.hostnames[0]
  type            = "AAAA"
  zone_id         = data.aws_route53_zone.hosted.zone_id
  allow_overwrite = true

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.export.domain_name
    zone_id                = aws_cloudfront_distribution.export.hosted_zone_id
  }
}
