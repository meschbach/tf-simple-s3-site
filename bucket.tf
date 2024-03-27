resource "aws_s3_bucket" "storage" {
  bucket = var.bucket
}

resource "aws_s3_bucket_website_configuration" "storage" {
  bucket = aws_s3_bucket.storage.bucket

  error_document {
    key = "index.html"
  }
  index_document {
    suffix = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "/"
    }
    redirect {
      replace_key_with = "/index.html"
    }
  }
}

resource "aws_s3_bucket_policy" "storage_cloudfront_access" {
  bucket = aws_s3_bucket.storage.bucket
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": ["s3:GetObject", "s3:ListBucket"],
        "Resource": ["${aws_s3_bucket.storage.arn}","${aws_s3_bucket.storage.arn}/*"],
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.export.arn}"
            }
        }
    }
}
EOF
}
