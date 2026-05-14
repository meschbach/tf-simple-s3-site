output "deployer" {
  description = "IAM access key and secret for CI/CD deployments to the S3 bucket"
  value = {
    access_key = aws_iam_access_key.deployer.id
    secret     = aws_iam_access_key.deployer.secret
  }
  sensitive = true
}
