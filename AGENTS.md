# AGENTS.md — tf-simple-s3-site

OpenTofu/Terraform module for a static S3 site fronted by CloudFront.

## Tooling

- Uses **OpenTofu** (`tofu`). The lockfile is maintained by `tofu init`.
  Terraform works too but `tofu` is canonical.
- AWS provider `>= 5.42.0`.

## Commands

```sh
tofu init          # first use or after adding providers
tofu validate      # validate module
tofu plan          # dry-run
tofu apply         # deploy
```

No lint, test, or codegen commands — this is a pure module.

## Module structure

- `input.tf` — 5 variables: `bucket`, `hosted_zone`, `hostnames`, `tags`, `redirect_404_spa`
- `outputs.tf` — single sensitive output `deployer` with `access_key` + `secret`
- `bucket.tf` — S3 bucket + website config + bucket policy (CloudFront OAC)
- `cloudfront.tf` — CloudFront distribution, OAC, CloudFront Function (redirect)
- `certificates.tf` — ACM cert (provider `aws.us_east_1`)
- `dns.tf` — Route53 zone lookup, validation records, A/AAAA alias records
- `deployer.tf` — IAM user + access key + S3 write policy
- `redirect.js` — CloudFront Function (runtime `cloudfront-js-2.0`) that rewrites `/`-ending URIs to `index.html`

## Key quirks

- **ACM cert must use `aws.us_east_1` provider alias** (CloudFront requirement).
  Consumers must supply a separate `us-east-1` provider alias.
- `viewer_protocol_policy = "allow-all"` (not redirect-to-https).
  Not a mistake — this is intentional.
- `wait_for_deployment = false` on CloudFront — apply returns immediately.
- `price_class = "PriceClass_100"` (North America + Europe only).
- `redirect_404_spa` (default `false`): when `true`, 403 and 404 errors return
  `200` with `/index.html` body. Enable this for SPA client-side routing.
- `hostnames[0]` is used for cert domain; all entries are CloudFront aliases.
- `hosted_zone` must exist in Route53.
- CloudFront uses **Origin Access Control (OAC)** (not OAI).
- Deployer IAM user gets `s3:ListBucket` + `s3:*Object` — intended for CI/CD.
