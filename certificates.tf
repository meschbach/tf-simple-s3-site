resource "aws_acm_certificate" "hosting" {
  provider          = aws.us_east_1
  domain_name       = var.hostnames[0]
  validation_method = "DNS"
}
