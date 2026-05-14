resource "aws_iam_user" "deployer" {
  # checkov:skip=CKV_AWS_273: IAM user intentional for CI/CD access-key workflow
  name = "${var.bucket}-deployer"
}

data "aws_iam_policy_document" "deployer_s3_write" {
  statement {
    sid       = "ListObjectsInBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.storage.bucket}"]
  }
  statement {
    sid       = "AllObjectActions"
    effect    = "Allow"
    actions   = ["s3:*Object"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.storage.bucket}/*"]
  }
}

resource "aws_iam_user_policy" "deployer_s3_write" {
  # checkov:skip=CKV_AWS_40: IAM user intentionally attached directly for CI/CD access-key workflow
  policy = data.aws_iam_policy_document.deployer_s3_write.json
  user   = aws_iam_user.deployer.name
}

resource "aws_iam_access_key" "deployer" {
  user = aws_iam_user.deployer.name
}
