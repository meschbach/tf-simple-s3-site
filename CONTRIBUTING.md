# Contributing

## Prerequisites

```sh
brew install pre-commit checkov trivy
```

## Setup

```sh
tofu init             # provider schemas for validation
pre-commit install    # register git hooks
```

## Running checks locally

```sh
# All at once
pre-commit run --all-files

# Individual tools
tofu fmt -check -recursive
tofu validate      # CI only — requires a calling module's provider context
checkov -d . --framework terraform --compact
trivy fs --severity HIGH,CRITICAL .
```

Checks are also run automatically via GitHub Actions on every push and pull request.
