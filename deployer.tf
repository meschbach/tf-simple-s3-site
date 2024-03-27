resource "aws_iam_user" "deployer" {
  name = "${var.bucket}-deployer"
}

resource "aws_iam_user_policy" "deployer_s3_write" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::${aws_s3_bucket.storage.bucket}"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::${aws_s3_bucket.storage.bucket}/*"]
        }
    ]
}
EOF
  user   = aws_iam_user.deployer.name
}

resource "aws_iam_access_key" "deployer" {
  user = aws_iam_user.deployer.name
}
