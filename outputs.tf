output "deployer" {
  value = {
    access_key = aws_iam_access_key.deployer.id
    secret     = aws_iam_access_key.deployer.secret
  }
  sensitive = true
}
