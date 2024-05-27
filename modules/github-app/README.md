# GitHub App

This module parse a GitHub Application credentials file.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| credentials\_file | Path to the GitHub App credentials file | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| app\_id | n/a |
| client\_id | n/a |
| client\_secret | n/a |
| private\_key | n/a |
| webhook\_secret | n/a |
| webhook\_url | n/a |
<!-- END_TF_DOCS -->
