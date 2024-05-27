# Portal: Backstage

This module deploys the [Humanitec Reference Architecture Backstage](https://github.com/humanitec-architecture/backstage) as Application into a specific Humanitec Organization.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | ~> 5.17 |
| github | ~> 5.38 |
| humanitec | ~> 1.0 |
| random | ~> 3.5 |

### Providers

| Name | Version |
|------|---------|
| github | ~> 5.38 |
| humanitec | ~> 1.0 |
| random | ~> 3.5 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| backstage\_ecr | terraform-aws-modules/ecr/aws | ~> 1.6 |
| backstage\_postgres | git::https://github.com/humanitec-architecture/resource-packs-in-cluster.git//humanitec-resource-defs/postgres/basic | n/a |

### Resources

| Name | Type |
|------|------|
| [github_repository.backstage](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [humanitec_application.backstage](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/application) | resource |
| [humanitec_resource_definition.no_scc_for_backstage_app](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition_criteria.backstage_postgres](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.no_scc_for_backstage_app](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_value.app_config_backend_auth_keys](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.aws_default_region](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_cloud_provider](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_github_app_client_id](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_github_app_client_secret](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_github_app_id](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_github_app_private_key](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_github_app_webhook_secret](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_github_org_id](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_humanitec_org](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [humanitec_value.backstage_humanitec_token](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/value) | resource |
| [random_bytes.backstage_service_to_service_auth_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS region | `string` | n/a | yes |
| github\_app\_client\_id | GitHub App Client ID | `string` | n/a | yes |
| github\_app\_client\_secret | GitHub App Client Secret | `string` | n/a | yes |
| github\_app\_id | GitHub App ID | `string` | n/a | yes |
| github\_app\_private\_key | GitHub App Private Key | `string` | n/a | yes |
| github\_org\_id | GitHub org id | `string` | n/a | yes |
| github\_webhook\_secret | GitHub Webhook Secret | `string` | n/a | yes |
| humanitec\_ci\_service\_user\_token | Humanitec CI Service User Token | `string` | n/a | yes |
| humanitec\_org\_id | Humanitec Organization ID | `string` | n/a | yes |
<!-- END_TF_DOCS -->
